class Deposit < ActiveRecord::Base
  after_save              :destroy_empty
  
  validates_presence_of   :celestial_body_id
  belongs_to              :celestial_body
  
  validates_presence_of   :item_id
  belongs_to              :item
  
  validates_numericality_of :deposit_yield, :only_integer => true, :greater_than  => 0
  validates_numericality_of :deposit_reserves, :only_integer => true, :greater_than_or_equal_to  => 0
  validates_numericality_of :deposit_growth, :only_integer => true, :greater_than_or_equal_to  => 0
  
  named_scope   :on,  lambda {|body|
    {:conditions => {:celestial_body_id => body.id}}
  }
  
  named_scope   :ores, {:conditions => ['item_id IN (?)',Item.ores.map{|i| i.id}]}
  named_scope   :resources, {:conditions => ['item_id IN (?)',Item.resources.map{|i| i.id}]}
  
  def self.average_yield(item)
    calc = Deposit.find(:first, :select => 'AVG(deposit_yield) AS avg_yield', :conditions => ['item_id = ?', item.id])
    calc ? calc.avg_yield.to_f : 1.0
  end
  
  def destroy_empty
    destroy if deposit_reserves < 1
  end
  
  def use!(amount)
    # puts "use #{amount} from deposit #{id} - #{celestial_body} - #{item} - #{deposit_reserves}"
    return unless amount > 0
    amount = self.deposit_reserves if deposit_reserves < amount
    reserves = (self.deposit_reserves - amount).to_i
    update_attributes!(:deposit_reserves => reserves)
    amount
  end
  
  def grow!
    return unless deposit_growth > 0
    update_attributes!(:deposit_reserves => deposit_reserves + deposit_growth)
  end
end
