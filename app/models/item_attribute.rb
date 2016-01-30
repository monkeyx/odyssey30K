class ItemAttribute < ActiveRecord::Base
  after_save             :destroy_zero
  
  validates_presence_of     :item_id
  validates_numericality_of :item_id,   :only_integer => true
  belongs_to                :item
  
  validates_inclusion_of     :name, :in => Attributes::ALL
  
  validates_numericality_of  :value,     :allow_nil => true
  
  def self.set_attribute!(item, name, value)
    attr = find(:first, :conditions => ['item_id = ? AND name = ?',item.id, name])
    attr = create(:item_id => item.id, :name => name) if attr.nil?
    attr.value = value
    attr.save!
  end
  
  def self.attribute(item, name)
    attr = find(:first, :conditions => ['item_id = ? AND name = ?', item.id, name])
    attr.nil? ? 0 : attr.value
  end
  
  def destroy_zero
    self.destroy if value == 0
  end
end
