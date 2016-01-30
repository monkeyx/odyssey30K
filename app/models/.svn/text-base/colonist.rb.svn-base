class Colonist < ActiveRecord::Base
  before_save             :destroy_empty
  before_validation       :generate_name

  BASE_MORALE               = 25.0
  MORALE_BOOST_PER_CATEGORY = 25.0
  GOOD_MORALE               = 75.0
  
  validates_length_of     :name,    :maximum => 100

  validates_numericality_of   :colony_id, :only_integer => true, :allow_nil => true
  belongs_to              :colony

  validates_numericality_of   :building_id, :only_integer => true, :allow_nil => true
  belongs_to              :building

  validates_presence_of   :lifeform_id
  belongs_to              :lifeform,  :class_name => 'Item'
  
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0
  default_value_for       :quantity, 0
  
  validates_numericality_of :morale, :greater_than_or_equal_to => 0
  default_value_for       :morale, BASE_MORALE
  
  validates_numericality_of :drachma, :greater_than_or_equal_to => 0
  default_value_for       :drachma, 0
  
  named_scope   :unique,  :conditions => ['lifeform_id IN (?)', Item.unique_individuals.map{|lifeform| lifeform.id}]
  named_scope   :at_colony, lambda {|colony| 
    { :conditions => {:colony_id => colony.id } }
  }
  named_scope   :in_building, lambda {|building| 
    { :conditions => {:building_id => building.id }}
  }
  named_scope   :lifeform, lambda {|lifeform| 
    { :conditions => {:lifeform_id => lifeform.id }}
  }
  named_scope   :employed_by, lambda {|employer| 
    {:conditions => ['building_id IN (?)', Building.owned_by(employer).map{|building| building.id}]}
  }
  
  def self.add_colonist!(colony, lifeform, quantity, building = nil)
    return unless quantity && quantity > 0
    if lifeform.unique_individual?
      (1..quantity).each do
        Colonist.create!(:colony_id => colony.id, :building_id => building ? building.id : nil, :lifeform_id => lifeform.id, :quantity => 1)
      end
    else
      if building
        colonist = Colonist.find(:first, :conditions => ['building_id = ? AND lifeform_id = ?',building.id, lifeform.id])
      else
        colonist = Colonist.find(:first, :conditions => ['colony_id = ? AND lifeform_id = ? AND (building_id IS NULL or building_id = 0)',colony.id, lifeform.id])
      end
      colonist = Colonist.new(:colony_id => colony.id, :quantity => 0, :building_id => building ? building.id : nil, :lifeform_id => lifeform.id) if colonist.nil?
      colonist.quantity = colonist.quantity + quantity
      colonist.save!
    end
  end
  
  def validate
    if lifeform.unique_individual? && quantity > 1
      errors.add(:quantity, 'cannot group unique individuals')
    end
  end
  
  def knowledge
    k = []
    ColonistKnowledge.find(:all, :conditions => ['colonist_id = ?', self.id]).each do |ck|
      k << ck.knowledge
    end
    k
  end
  
  def has_knowledge?(knowledge)
    ColonistKnowledge.count(:conditions => ['colonist_id = ? AND knowledge_id = ? ', self.id, knowledge.id]) > 0  
  end
  
  def add_knowledge!(knowledge)
    ColonistKnowledge.create!(:colonist_id => self.id, :knowledge_id => knowledge.id) unless has_knowledge?(knowledge)
  end
  
  def unique?
    lifeform.unique_individual?
  end
  
  def master_artisan?
    lifeform.master_artisan?
  end
  
  def officer?
    lifeform.officer?
  end
  
  def philosopher?
    lifeform.philosopher?
  end
  
  def employer
    self.building ? self.building.owner : self.starship ? self.starship.captain : nil 
  end
  
  def colony
    self.building ? self.building.colony : nil
  end
  
  def governor
    colony ? colony.governor : nil
  end
  
  SURNAME_SUFFIX = ['akis','as','atos','allis','idis','ides','iadis','iades','opoulos','oglou','ou','akos','eas']
  
  private
  def generate_name
    return unless name.blank?
    if unique?
      names = $NPC_NAME_GENERATOR.generate_names(2)
      self.name = "#{names[0]} #{names[1]}#{SURNAME_SUFFIX.sort_by{rand}.first}"
    else
      self.name = lifeform.name
    end
  end
  
  def destroy_empty
    self.destroy if quantity < 1
  end
  
  public
  
  def payday!
    return unless employer
    # wages + bonus
    wages_due = (lifeform.wages * quantity)
    wages_paid = employer.drachma > wages_due ? wages_due : employer.drachma
    Money.cash_transaction!(employer, self, wages_paid, "Wages")
    bonus_due = (lifeform.wages * quantity * (building.bonus_wages / 100.0))
    bonus_paid = employer.drachma > bonus_due ? bonus_due : employer.drachma
    Money.cash_transaction!(employer, self, bonus_paid, "Bonus")
    # taxes
    if governor
      taxes = (wages_paid + bonus_paid)  * (colony.tax_rate / 100)
      Money.cash_transaction!(self, governor, taxes, "Taxation")
    end
    drachma
  end
  
  def calculate_morale!
    return unless colony
    self.morale = BASE_MORALE + colony.planet.morale_modifier
    buy_resources!(Item.food) if drachma > 0
    buy_resources!(Item.wine) if drachma > 0
    buy_resources!(Item.clothing) if drachma > 0
    buy_resources!(Item.luxuries) if drachma > 0
    self.morale = 0 if morale < 0
    save! # updated morale
    morale
  end
  
  def breed!
    return unless colony
    new_colonists = (quantity * (colony.planet.colonist_growth_rate / 100.0)).to_i
    if new_colonists > 0
      # puts "#{self} bred #{new_colonists} new colonists"
      new_colonists_type = lifeform.breeds_item
      MarketOrder.sell!(governor, colony, [new_colonists_type], new_colonists, MarketOrder.suggested_sell_price(colony,[new_colonists_type]), true)
    end
    new_colonists
  end
  
  def quit!
    return unless colony
    quitting_colonists = (quantity * (BASE_MORALE - morale) / 100.0).to_i
    if quitting_colonists > 0
      building.log!("#{quitting_colonists} #{lifeform} quit due to poor morale.")
      update_attributes!(:quantity => quantity - quitting_colonists)
      MarketOrder.sell!(governor, colony, [lifeform], quitting_colonists, MarketOrder.suggested_sell_price(colony,[lifeform]), true)
    end
    quitting_colonists
  end
  
  def maintenance!
    return if quantity < 1 # sanity check to avoid divide by zeros
    payday!
    calculate_morale!
    breed! if morale >= GOOD_MORALE
    quit! if morale < BASE_MORALE
  end
  
  def buy_resources!(items)
    # puts "#{self} trying to buy #{items}"
    MarketOrder.buy!(self, colony, items, quantity, self.drachma).each do |item,qty_bought|
      # puts "#{self} bought #{qty_bought} of #{item}"
      self.morale += MORALE_BOOST_PER_CATEGORY * (qty_bought / quantity)
    end
  end
  
  def cash_log
    Money.cash_log(self)
  end
  
  def wealth
    return "Poor" if (drachma / quantity) < 10
    return "Rich" if (drachma / quantity) >= 500
    return "Middle Class"
  end
  
  def to_s
    name
  end
end
