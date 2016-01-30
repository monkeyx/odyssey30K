class StarshipAttribute < ActiveRecord::Base
  after_save             :destroy_zero
  
  validates_presence_of     :starship_id
  validates_numericality_of :starship_id,   :only_integer => true
  belongs_to                :starship
  
  validates_inclusion_of     :name, :in => Attributes::ALL
  
  validates_numericality_of  :value,     :allow_nil => true
  
  def self.set_attribute(ship, name, value)
    attr = find(:first, :conditions => ['starship_id = ? AND name = ?',ship.id, name.to_s])
    attr = new(:starship_id => ship.id, :name => name.to_s) if attr.nil?
    attr.value = value
    attr.save
  end
  
  def self.attribute(ship, name)
    attr = find(:first, :conditions => ['starship_id = ? AND name = ?',ship.id, name.to_s])
    attr.nil? ? 0 : attr.value
  end
  
  def destroy_zero
    self.destroy if value == 0
  end
end
