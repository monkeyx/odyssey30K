class BuildingItem < ActiveRecord::Base
  after_save             :destroy_empty
  
  validates_presence_of   :building_id
  belongs_to              :building
  
  validates_presence_of   :item_id
  belongs_to              :item
  
  validates_numericality_of :quantity,  :greater_than_or_equal_to => 0
  
  named_scope             :in_building, lambda {|building|
    {:conditions => {:building_id => building.id}}
  }
  
  named_scope             :item, lambda {|item|
    {:conditions => {:item_id => item.id}}
  }
  
  def self.count_item(building, item)
    total = 0
    in_building(building).item(item).each do |bi|
      total += bi.quantity
    end
    total
  end
  
  def destroy_empty
    self.destroy if quantity < 1
  end
end
