class Crew < ActiveRecord::Base
  after_save              :destroy_empty
  before_validation       :generate_name
  
  validates_length_of     :name,    :maximum => 100
  
  validates_presence_of   :starship_id
  belongs_to              :starship

  validates_presence_of   :lifeform_id
  belongs_to              :lifeform,  :class_name => 'Item'
  
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0
  
  def unique?
    lifeform.unique_individual?
  end
  
  def officer?
    lifeform.officer?
  end
  
  def employer
    self.starship.captain
  end
  
  def skills
    k = []
    OfficerSkill.find(:all, :conditions => ['crew_id = ?', self.id]).each do |ck|
      k << ck.skill
    end
    k
  end
  
  def has_skill?(skill)
    OfficerSkill.count(:conditions => ['crew_id = ? AND skill_id = ? ', self.id, skill.id]) > 0  
  end
  
  def add_skill!(skill)
    OfficerSkill.create!(:crew_id => self.id, :skill_id => skill.id)
  end
  
  def payday!
    return unless employer
    # wages + bonus
    wages_due = (lifeform.wages * quantity)
    wages_paid = employer.drachma > wages_due ? wages_due : employer.drachma
    Money.cash_transaction!(employer, self, wages_paid, "Wages")
    bonus_due = (lifeform.wages * quantity * (building.bonus_wages / 100.0))
    bonus_paid = employer.drachma > bonus_due ? bonus_due : employer.drachma
    Money.cash_transaction!(employer, self, bonus_paid, "Bonus")
    drachma
  end
  
  def maintenance!
    return if quantity < 1 # sanity check to avoid divide by zeros
    payday!
  end
  
  def skill_description
    skills.any? ? "[#{skills.join(',')}]" : ""
  end
  
  def to_s
    unique? ? "#{name} (#{lifeform.name}) #{skill_description}" : name
  end
  
  private
  def generate_name
    return unless name.blank?
    if unique?
      names = $NPC_NAME_GENERATOR.generate_names(2)
      self.name = "#{names[0]} #{names[1]}#{Colonist::SURNAME_SUFFIX.sort_by{rand}.first}"
    else
      self.name = lifeform.name
    end
  end
  
  def destroy_empty
    self.destroy if quantity < 1
  end
end
