class ItemRawMaterials < ActiveRecord::Base
  after_save             :destroy_empty
  
  validates_presence_of     :item_id
  validates_numericality_of :item_id,   :only_integer => true
  belongs_to                :item

  validates_presence_of     :raw_material_id
  validates_numericality_of :raw_material_id,   :only_integer => true
  belongs_to                :raw_material, :class_name => 'Item'
  
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0
  
  def self.for_item(item)
    find(:all, :conditions => ['item_id = ?', item.id])
  end
  
  def self.count_for_item(for_item, of_item)
    rm = find(:first, :conditions => ['item_id = ? AND raw_material_id = ?',for_item.id, of_item.id])
    rm.nil? ? 0 : rm.quantity
  end
  
  def self.set_for_item(for_item, of_item, quantity)
    rm = find(:first, :conditions => ['item_id = ? AND raw_material_id = ?',for_item.id, of_item.id])
    rm = new(:item_id => for_item.id, :raw_material_id => of_item.id) if rm.nil?
    rm.quantity = quantity
    rm.save
  end
  
  def destroy_empty
    self.destroy if quantity < 1
  end
end
