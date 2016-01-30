class ProductionItem < ActiveRecord::Base
  after_save                :destroy_empty
  
  validates_presence_of     :building_id
  belongs_to                :building
  validates_presence_of     :item_id
  belongs_to                :item
  validates_numericality_of :quantity, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :produced,  :greater_than_or_equal_to => 0
  default_value_for         :produced, 0
  
  def destroy_empty
    self.destroy if self.quantity < 1
  end
end
