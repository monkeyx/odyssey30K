class Knowledge < ActiveRecord::Base
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100

  KNOWLEDGE_TYPES = ["axiom", "priori", "technos", "skill"]
  KNOWLEDGE_TYPES.each {|s| named_scope s.pluralize, :conditions => {:knowledge_type => s}}
  validates_inclusion_of  :knowledge_type,  :in => KNOWLEDGE_TYPES
  
  ALLOWED_FILTERS = ['all'] + KNOWLEDGE_TYPES.map{|s|s.pluralize}
  
  named_scope :all, :order => 'knowledge_type ASC, name ASC'
  
  def axiom?
    self.knowledge_type == "axiom"
  end
  
  def priori?
    self.knowledge_type == "priori"
  end
  
  def technos?
    self.knowledge_type == "technos"
  end
  
  def skill?
    self.knowledge_type == "skill"
  end
  
  validates_numericality_of :prequisite_id, :only_integer => true, :greater_than => 0, :if => Proc.new{|k|k.priori? || k.technos?}, :message => 'must be chose for priori/technos'
  belongs_to              :prequisite,  :class_name => 'Knowledge'
  
  validates_numericality_of :allows_production_id, :only_integer => true, :greater_than => 0, :if => Proc.new{|k|k.technos?}, :message => 'must be chosen for a technos'
  belongs_to              :allows_production,  :class_name => 'Item'
  
  has_many                :children,  :foreign_key => 'prequisite_id', :class_name => 'Knowledge'
  
  # officer_skill_attribute
  validates_inclusion_of  :officer_skill_attribute, :in => Attributes::ALL, :if => Proc.new{|k|k.skill?}, :message => 'must be chosen for a skill'
  # attribute_modifier
  default_value_for       :attribute_modifier, 0
  
  def self.create_axiom!(name, axiom = nil)
    create!(:name => name, :knowledge_type => "axiom", :prequisite_id => axiom.nil? ? 0 : axiom.id)
  end
  
  def self.create_priori!(name, axiom_or_priori)
    create!(:name => name, :knowledge_type => "priori", :prequisite_id => axiom_or_priori.id)
  end
  
  def self.create_technos!(item, priori)
    t = create!(:name => item.name, :knowledge_type => "technos", :prequisite_id => priori.id, :allows_production_id => item.id)
    item.knowledge = t
    item.restricted = true
    item.save
    t
  end
  
  def self.create_skill!(name, attribute_name, attribute_modifier)
    create!(:name => name, :knowledge_type => "skill", :officer_skill_attribute => attribute_name, :attribute_modifier => attribute_modifier)
  end
  
  def to_s
    name
  end
end
