class StarshipCargo < ActiveRecord::Base
  after_save             :destroy_empty
  
  validates_presence_of   :starship_id
  belongs_to              :starship
  
  validates_presence_of   :item_id
  belongs_to              :item
  
  validates_numericality_of :quantity,  :greater_than_or_equal_to => 0
  
  named_scope             :on_starship, lambda {|starship|
    {:conditions => {:starship_id => starship.id}}
  }
  
  named_scope             :item, lambda {|item|
    {:conditions => {:item_id => item.id}}
  }
  
  def self.count_item(starship, item)
    total = 0
    on_starship(starship).item(item).each do |sc|
      total += sc.quantity
    end
    total
  end
  
  def destroy_empty
    self.destroy if quantity < 1
  end
end
