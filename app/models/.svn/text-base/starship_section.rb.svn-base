class StarshipSection < ActiveRecord::Base
  validates_presence_of     :starship_id
  validates_numericality_of :starship_id,   :only_integer => true
  belongs_to                :starship
  
  validates_presence_of     :section_id
  validates_numericality_of :section_id,   :only_integer => true
  belongs_to                :section,      :class_name  => 'Item'
  
  named_scope   :in_starship, lambda {|starship| 
    {:conditions => {:starship_id => starship.id}}
  }
  
  named_scope   :of_item, lambda {|item| 
    {:conditions => {:section_id => item.id}}
  }

  named_scope    :in_items, lambda {|items|
    { :conditions => ['section_id IN (?)',items.map{|i|i.id}]}
  }
  
  named_scope    :command, {:conditions => ['section_id IN (?)',Item.command.map{|i|i.id}]}
  named_scope    :mission, {:conditions => ['section_id IN (?)',Item.mission.map{|i|i.id}]}
  named_scope    :engine, {:conditions => ['section_id IN (?)',Item.engine.map{|i|i.id}]}
end
