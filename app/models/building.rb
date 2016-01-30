class Building < ActiveRecord::Base
  after_save              :destroy_derelict
  
  validates_presence_of   :colony_id
  belongs_to              :colony
  
  has_one                 :celestial_body,  :through => :colony
  alias_method            :planet, :celestial_body
  
  validates_presence_of   :building_type_id
  belongs_to              :building_type,   :class_name => 'Item'
  
  validates_presence_of   :owner_id
  belongs_to              :owner,   :class_name => 'User'
  
  has_many                :items,   :class_name => 'BuildingItem'
  has_many                :colonists
  
  validates_numericality_of :efficiency, :greater_than_or_equal_to => 0
  default_value_for         :efficiency, 0
  
  validates_numericality_of :bonus_wages, :greater_than_or_equal_to => 0
  default_value_for         :bonus_wages, 0
  
  validates_numericality_of :level, :greater_than_or_equal_to => 0
  default_value_for         :level, 0
  
  default_value_for         :automated do
    false
  end
  
  has_many                  :production_items
  
  named_scope   :in_colony, lambda {|colony| 
    {:conditions => {:colony_id => colony.id}}
  }
  named_scope   :owned_by,  lambda {|owner| 
    {:conditions => {:owner_id => owner.id}}
  }
  named_scope   :building_type, lambda {|building_type| 
    {:conditions => {:building_type_id => building_type.id}}
  }
  def unique?
    building_type.unique_building?
  end
  
  # BEGIN ITEM CONTAINER
  include ItemContainer
  
  def cargo_capacity
    building_type.cargo_capacity * level
  end
  
  def ore_capacity
    building_type.ore_capacity * level
  end
  
  def resource_capacity
    building_type.resource_capacity * level
  end
  
  def life_capacity
    building_type.life_capacity * level
  end
  
  alias_method :stored_items, :items
  
  def count_item(item)
    BuildingItem.count_item(self,item)
  end
  
  def get_stored_item(item)
    bi = BuildingItem.find(:first, :conditions => ['building_id = ? AND item_id = ?', self.id, item.id])
    bi = BuildingItem.new(:building_id => self.id, :item_id => item.id, :quantity => 0) if bi.nil?
    bi
  end
  
  def add_item_knowledge!(item)
    owner.add_knowledge!(item.knowledge) if item.restricted? && !owner.has_knowledge?(item.knowledge)
  end
  
  # END ITEM CONTAINER

  # START BUILDING
  def self.cost_to_build(colony, building_type, owner)
    building = Building.find(:first, :conditions => ['colony_id = ? AND building_type_id = ? AND owner_id = ?',colony.id, building_type.id, owner.id])
    building ? building.expansion_cost : building_type.raw_materials
  end
  
  def self.build!(colony, building_type, owner, source = nil)
    if source
      building_materials = cost_to_build(colony, building_type, owner)
      if source.has_items?(building_materials)
        source.remove_all_items!(building_materials)
      else
        return false
      end
    end
    building = Building.find(:first, :conditions => ['colony_id = ? AND building_type_id = ? AND owner_id = ?',colony.id, building_type.id, owner.id])
    building = Building.new(:colony_id => colony.id, :building_type_id => building_type.id, :owner_id => owner.id) if building.nil?
    building.level += 1
    building.save!
    building
  end
  
  def destroy_derelict
    self.destroy if self.level < 1
  end
  
  def expansion_cost
    rms = building_type.raw_materials
    rms.keys.each{|k|rms[k] = rms[k] * (self.level + 1)}
    rms
  end
  
  # END BUILDING

  # START EMPLOYEES

  def employees_needed
    employees = building_type.employees_needed
    employees.each do |employee, quantity|
      employees[employee] = quantity * level
    end
    employees
  end
  
  def add_employee!(lifeform, quantity)
    Colonist.add_colonist!(colony, lifeform, quantity, self)
  end
  
  def employees_by_lifeform(lifeform)
    Colonist.in_building(self).lifeform(lifeform)
  end
  
  # END EMPLOYEES

  # START PRODUCTION ITEM
  def raw_materials_for_item(item)
    max = nil
    item.raw_materials.each do |rm, qty|
      t = count_item(rm) / qty
      max = t if max.nil? || t < max
    end
    max
  end

  def add_production_item!(item, quantity)
    return false unless quantity >= 1 && item.produceable? && ((building_type.production > 0 && !item.chassis?) || (building_type.ship_building && item.chassis?))
    self.production_items.create!(:item_id => item.id, :quantity => quantity.to_i) 
  end
  
  def alter_production_item!(row, quantity)
    return false unless self.workshop_queue.size > row
    self.production_items[row].update_attributes!(:quantity => quantity)
  end
  
  def clear_production_items!
    ProductionItem.delete_all("building_id = #{self.id}")
  end
  
  def next_production_item
    self.production_items.first
  end
  
  def empty_production_items?
    self.production_items.empty?
  end  
  
  # END PRODUCTION ITEM

  def to_s
    building_type.nil? ? '' : building_type.name 
  end
  
  # START MAINTENANCE

  private
  def work_deposits!(deposits)
    deposits.each do |d|
      qty = (level * d.deposit_yield * (efficiency / 100.0)).round(0)
      if qty > 0
        qty = add_items!(d.item, qty) 
        d.use!(qty)
        if d.item.ore?
          log!("Mined #{qty.to_i} #{d.item}")
        elsif d.item.resource?
          log!("Harvested #{qty.to_i} #{d.item}")
        end
      end
    end
  end
  def grow_items!(item, growth_rate)
    return unless growth_rate > 0
    existing = count_item(item)
    grown = (existing * (growth_rate / 100.0) * (efficiency / 100.0)).floor
    return unless grown > 0
    space_for = space_for_item(item)
    grown = space_for if space_for < grown
    log! "Grew #{grown.to_i} #{item}"
    add_items!(item, grown)    
  end
  def convert_items!(from_items, to_item, conversion_rate)
    # puts "#{self.id} CONVERT #{from_items} => #{to_item} #{conversion_rate}"
    return unless conversion_rate > 0
    from_items = [from_items] if from_items.is_a?(Item)
    # puts "#{self.id} FROM ITEMS #{from_items} (#{from_items.class.name})"
    existing = count_item(from_items.first)
    # puts "#{self.id} EXISTING #{existing} (first)"
    from_items.each {|from_item| c = count_item(from_item); existing = c if existing > c}
    # puts "#{self.id} EXISTING #{existing} (all)"
    converted = (existing * conversion_rate * (efficiency / 100.0)).round(0)
    # puts "#{self.id} CONVERTED #{converted}"
    return unless converted > 0
    space_for = space_for_item(to_item)
    converted = space_for if space_for < converted
    converted = converted.round(0)
    remove_existing = (converted / conversion_rate).round(0)
    msg = from_items.map{|i| "#{remove_existing.to_i} #{i.name}" }.join(',')
    log! "#{msg} turned into #{converted.to_i} #{to_item}"
    from_items.each{|from_item| remove_items!(from_item, remove_existing)}
    add_items!(to_item, converted)
  end
  def produce_items!(production_amount)
    return unless production_amount > 0
    production_amount = (production_amount * (efficiency / 100.0) * level).round(0)
    # puts "produce_items! #{production_amount}"
    while pi = next_production_item do
      # puts "produce_items! #{production_amount} -> #{pi.quantity} #{pi.item}"
      production_amount += pi.produced
      qty_produced = (production_amount / pi.item.mass).round(0)
      qty_produced = pi.quantity if qty_produced > pi.quantity
      raw_materials_for = raw_materials_for_item(pi.item)
      qty_produced = raw_materials_for if qty_produced > raw_materials_for
      space_for = space_for_item(pi.item)
      qty_produced = space_for if qty_produced > space_for
      qty_produced = qty_produced.to_i
      if qty_produced <= 0
        if pi && pi.quantity > 0 # carry production forward to last item in queue
          pi.produced = production_amount
          pi.save
        end
        return
      end
      use_raw_materials!(pi.item, qty_produced) if qty_produced > 0
      if qty_produced > 0
        add_items!(pi.item, qty_produced)
        pi.quantity = pi.quantity - qty_produced
        pi.quantity > 0 ? pi.save! : pi.destroy
        production_amount -= (qty_produced * pi.item.mass)
        log! "Produced #{qty_produced.to_i} #{pi.item}"
      end
    end
  end
  
  public
  def mine!
    return unless building_type.mining?
    work_deposits!(Deposit.on(planet).ores)
  end
  
  def harvest! 
    return unless building_type.harvesting?
    work_deposits!(Deposit.on(planet).resources)
  end
  
  def breed! 
    return unless building_type.breeding?
    grow_items!(Item.livestock.first, building_type.item_attribute_value(Attributes::BREEDING))
  end
  
  def farm! 
    return unless building_type.farming?
    grow_items!(Item.plantlife.first, building_type.item_attribute_value(Attributes::FARMING))
  end
  
  def butcher! 
    return unless building_type.butchering?
    convert_items!(Item.livestock.first, Item.food.first, building_type.item_attribute_value(Attributes::BUTCHERING))
  end
  
  def tan! 
    return unless building_type.tanning?
    convert_items!(Item.livestock.first, Item.clothing.first, building_type.item_attribute_value(Attributes::TANNING))
  end
  
  def weave! 
    return unless building_type.weaving?
    convert_items!(Item.plantlife.first, Item.clothing.first, building_type.item_attribute_value(Attributes::WEAVING))
  end
  
  def make_wine! 
    return unless building_type.vineyard?
    convert_items!(Item.plantlife.first, Item.wine.first, building_type.item_attribute_value(Attributes::WINE_MAKING))
  end
  
  def bake! 
    return unless building_type.baking?
    convert_items!(Item.plantlife.first, Item.food.first, building_type.item_attribute_value(Attributes::BAKING))
  end
  
  def production! 
    return unless building_type.production > 0
    produce_items!(building_type.production)
  end
  
  def build_ship! 
    return unless building_type.ship_building > 0
    produce_items!(building_type.ship_building * 1000)
  end
  
  def educate! 
    return unless building_type.education?
  end
  
  def research! 
    return unless building_type.research?
  end
  
  def calculate_efficiency!
    self.efficiency = 0 # reset
    emp_needed = employees_needed
    total_needed = emp_needed.values.sum.to_f
    emp_needed.each do |lifeform, quantity_needed|
      # puts "Need #{quantity_needed} of #{lifeform}"
      employees_by_lifeform(lifeform).each do |colonist|
        # puts "Colonist #{colonist} is #{colonist.quantity} of #{colonist.lifeform}"
        qty = quantity_needed > colonist.quantity ? colonist.quantity : quantity_needed
        quantity_needed -= qty
        efficiency_adj = ((qty.to_f / total_needed) * colonist.morale)
        # puts "Quantity now needed #{quantity_needed}. #{qty.to_f} / #{total_needed} * #{colonist.morale} = #{efficiency_adj}"
        self.efficiency += efficiency_adj
      end
    end
    save!
    self.efficiency
  end
  
  def hire_workers!
    employees_needed.each do |lifeform, quantity_needed|
      employees_by_lifeform(lifeform).each do |colonist|
        qty = quantity_needed > colonist.quantity ? colonist.quantity : quantity_needed
        quantity_needed -= qty
      end
      if quantity_needed > 0
        # puts "#{owner}, #{colony}, #{[lifeform]}, #{quantity_needed}, #{owner.drachma}, false"
        bought = MarketOrder.buy!(owner, colony, [lifeform], quantity_needed, owner.drachma, false)
        if bought[lifeform] && bought[lifeform] > 0
          log!("Hired #{bought[lifeform]} #{lifeform}")
          add_employee!(lifeform, bought[lifeform])
        end
      end
    end
  end
  
  def sell_items!(items_arrays)
    items_arrays.each do |entry|
      # puts "sell_items! #{entry}"
      item, quantity = entry[0], entry[1]
      # puts "item = #{item} (#{item.class.name}), quantity = #{quantity}"
      price = MarketOrder.suggested_sell_price(self.colony, [item])
      MarketOrder.sell!(self.owner, self.colony, [item], quantity, price, true, self)
    end
  end
  
  def buy_items!(items_arrays)
    items_arrays.each do |entry|
      # puts "buy_items! #{entry}"
      item, quantity = entry[0], entry[1]
      # puts "item = #{item} (#{item.class.name}), quantity = #{quantity}"
      price = MarketOrder.suggested_buy_price(self.colony, [item])
      MarketOrder.buy!(self.owner, self.colony, [item], quantity, price, true, self)
    end
  end
  
  def automation!
    # sell every item at an admin center, mine or harvester
    sell_items!(self.items.map{|bi| [bi.item, bi.quantity]}) if building_type.mining? || building_type.harvesting? || building_type.governor?
    # sell some livestock from a ranch
    if building_type.breeding?
      livestock_qty = count_item(Item.livestock.first) - (life_capacity / 2)
      sell_items!([[Item.livestock.first, livestock_qty]])
    end
    # sell some plantlife from a farm
    if building_type.farming?
      plantlife_qty = count_item(Item.plantlife.first) - (life_capacity / 2)
      sell_items!([[Item.plantlife.first, plantlife_qty]])
    end
    # sell all food from a bakery or slaughterhouse
    sell_items!([[Item.food.first, count_item(Item.food.first)]]) if building_type.butchering? || building_type.baking?
    # sell all clothes from a weavers or tannery
    sell_items!([[Item.clothing.first, count_item(Item.clothing.first)]]) if building_type.tanning? || building_type.weaving?
    # sell all wines from a vineyard
    sell_items!([[Item.wine.first, count_item(Item.wine.first)]]) if building_type.vineyard?
    # buy livestock for a slaughterhouse or tannery
    buy_items!([[Item.livestock.first, free_life_capacity]]) if building_type.butchering? || building_type.tanning?
    # buy plantlife for a bakery or weavers or vineyard
    buy_items!([[Item.plantlife.first, free_life_capacity]]) if building_type.baking? || building_type.weaving? || building_type.vineyard?
    if building_type.production > 0
      # buy ores for workshops
      ores_to_buy = ore_capacity / 4
      buy_items!(Item.ores.map{|o| [o, ores_to_buy]})
      # sell modules from workshops
      sell_items!(Item.modules.map{|mod| [mod, count_item(mod)]})
      # produce modules if queue is empty
      Item.modules.each{|mod| add_production_item!(mod, 10)} if empty_production_items?
    end
  end
    
  def maintenance!
    # puts "START MAINTENANCE #{self}"
    # calculate efficiency
    calculate_efficiency!
    # do work
    mine! || harvest! || breed! || farm! || butcher! || bake! || tan! || weave! || make_wine! || production! || build_ship! || educate! || research!
    # hire workers if possible
    hire_workers!
    # automated orders
    automation! if automated || owner == User.zeus
    # puts "END MAINTENANCE #{self}"
  end
  
  # END MAINTENANCE

  def log!(description)
    Event.log!(self.owner, self, description)
  end
  
  def event_log
    Event.find(:all, :conditions => {:model_id => self.id, :model_class => self.class.name})
  end
end
