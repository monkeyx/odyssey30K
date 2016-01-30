class Item < ActiveRecord::Base
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100
  
  named_scope :named, lambda {|name|
    {:conditions => {:name => name}}
  }
  
  named_scope :ores, :conditions => "sub_category = 'ore'"
  named_scope :metals, :conditions => {:name => 'Metals', :sub_category => 'ore'}
  named_scope :minerals, :conditions => {:name => 'Minerals', :sub_category => 'ore'}
  named_scope :hydrocarbons, :conditions => {:name => 'Hydrocarbons', :sub_category => 'ore'}
  named_scope :crystals, :conditions => {:name => 'Crystals', :sub_category => 'ore'}
  named_scope :resources, :conditions => "sub_category = 'resource'"
  named_scope :clothing, :conditions => {:name => 'Clothing', :sub_category => 'resource'}
  named_scope :food, :conditions => {:name => 'Food', :sub_category => 'resource'}
  named_scope :wine, :conditions => {:name => 'Wine', :sub_category => 'resource'}
  named_scope :luxuries, :conditions => {:name => 'Luxuries', :sub_category => 'resource'}
  
  named_scope :restricted, :conditions => {:restricted => true}
  named_scope :unrestricted, :conditions => {:restricted => false}
  
  named_scope :civilian_modules, :conditions => {:name => 'Civilian Module', :sub_category => 'module'}
  named_scope :industrial_modules, :conditions => {:name => 'Industrial Module', :sub_category => 'module'}
  named_scope :transportation_modules, :conditions => {:name => 'Transportation Module', :sub_category => 'module'}
  named_scope :security_modules, :conditions => {:name => 'Security Module', :sub_category => 'module'}
  
  named_scope :livestock, :conditions => {:name => 'Livestock', :sub_category => 'lifeform'}
  named_scope :plantlife, :conditions => {:name => 'Plantlife', :sub_category => 'lifeform'}
  named_scope :slaves, :conditions => {:name => 'Slave', :sub_category => 'lifeform'}
  named_scope :freemen, :conditions => {:name => 'Freeman', :sub_category => 'lifeform'}
  named_scope :sailors, :conditions => {:name => 'Sailor', :sub_category => 'lifeform'}
  named_scope :marines, :conditions => {:name => 'Marine', :sub_category => 'lifeform'}
  named_scope :engineers, :conditions => {:name => 'Engineer', :sub_category => 'lifeform'}
  named_scope :soldiers, :conditions => {:name => 'Soldier', :sub_category => 'lifeform'}
  named_scope :officers, :conditions => {:name => 'Officer', :sub_category => 'lifeform'}
  named_scope :master_artisans, :conditions => {:name => 'Master Artisan', :sub_category => 'lifeform'}
  named_scope :philosophers, :conditions => {:name => 'Philosopher', :sub_category => 'lifeform'}
  
  named_scope :crew, :conditions => "name IN ('Sailor','Marine','Engineer','Officer')"
  named_scope :unique_individuals, :conditions => ['name IN (?)', ['Officer', 'Master Artisan', 'Philosopher']]
  
  named_scope :admin_center, :conditions => {:name => 'Administration Center', :category => 'building'}
  named_scope :warehouse, :conditions => {:name => 'Warehouse', :category => 'building'}
  named_scope :mine, :conditions => {:name => 'Mine', :category => 'building'}
  named_scope :harvester, :conditions => {:name => 'Harvester', :category => 'building'}
  named_scope :ranch, :conditions => {:name => 'Ranch', :category => 'building'}
  named_scope :farm, :conditions => {:name => 'Farm', :category => 'building'}
  named_scope :slaughterhouse, :conditions => {:name => 'Slaughterhouse', :category => 'building'}
  named_scope :bakery, :conditions => {:name => 'Bakery', :category => 'building'}
  named_scope :weavers, :conditions => {:name => 'Weavers', :category => 'building'}
  named_scope :tannery, :conditions => {:name => 'Tannery', :category => 'building'}
  named_scope :vineyard, :conditions => {:name => 'Vineyard', :category => 'building'}
  named_scope :workshop, :conditions => {:name => 'Workshop', :category => 'building'}
  named_scope :shipyard, :conditions => {:name => 'Shipyard', :category => 'building'}
  named_scope :rigger, :conditions => {:name => 'Rigger', :category => 'building'}
  named_scope :school, :conditions => {:name => 'School', :category => 'building'}
  named_scope :boot_camp, :conditions => {:name => 'Boot Camp', :category => 'building'}
  named_scope :training_camp, :conditions => {:name => 'Training Camp', :category => 'building'}
  named_scope :naval_camp, :conditions => {:name => 'Naval Camp', :category => 'building'}
  named_scope :technical_college, :conditions => {:name => 'Technological College', :category => 'building'}
  named_scope :academy, :conditions => {:name => 'Academy', :category => 'building'}
  named_scope :university, :conditions => {:name => 'University', :category => 'building'}

  named_scope :unique_buildings, :conditions => ['name IN (?)', ['Administration Center', 'Academy', 'University']]
  
  named_scope :chassis, :conditions => {:sub_category => 'chassis'}
  named_scope :command, :conditions => {:sub_category => 'command'}
  named_scope :mission, :conditions => {:sub_category => 'mission'}
  named_scope :engine, :conditions => {:sub_category => 'engine'}

  validates_numericality_of :mass,  :only_integer => true, :greater_than_or_equal_to  => 1
  
  CATEGORIES = ['commodity', 'artisan', 'ship_section', 'building']
  CATEGORIES.each {|s| named_scope s.pluralize, :conditions => {:category => s}}
  
  validates_inclusion_of  :category,  :in => CATEGORIES
  
  SUB_CATEGORIES = ["ore", "lifeform", "resource", "module", "hull", "chassis", "command", "mission", "engine", "armour", "building"]
  SUB_CATEGORIES.each {|s| named_scope s.pluralize, :conditions => {:sub_category => s}}
  
  ALLOWED_FILTERS = ['all'] + CATEGORIES.map{|s|s.pluralize} + SUB_CATEGORIES.map{|s|s.pluralize}
  
  validates_inclusion_of  :sub_category,  :in => SUB_CATEGORIES
  
  default_value_for   :restricted do
    false
  end
  
  def restrict!(priori)
    Knowledge.create_technos!(self, priori)
  end
  
  named_scope               :known_by_user_id,  lambda{|userid|
    {:conditions => ["restricted = 0 OR restricted IS NULL or knowledge_id IN (?)", User.find(userid).knowledges.to_a.map{|k|k.id}]}
  }
  
  def self.known_by_user(user)
    return nil unless user && user.is_a?(User)
    return self.all if user.zeus?
    return self.senator.known_by_user_id(user.id) if user.senator?
    return self.citizen.known_by_user_id(user.id) if user.citizen?
    self.freeman.known_by_user_id(user.id)
  end
  
  validates_numericality_of :knowledge_id, :only_integer => true, :allow_nil => true  
  belongs_to                :knowledge
  
  validates_inclusion_of  :user_type_restriction,  :in => User::CHARACTER_TYPES
  
  named_scope :freeman, :conditions => {:user_type_restriction => 'freeman'}
  named_scope :citizen, :conditions => ['user_type_restriction IN (?)', ['freeman','citizen']]
  named_scope :senator, :conditions => ['user_type_restriction IN (?)', ['freeman','citizen','senator']]
  named_scope :zeus, :conditions => ['user_type_restriction IN (?)', ['freeman','citizen','senator', 'zeus']]
  
  default_value_for   :user_type_restriction do
    "freeman"
  end
  
  def citizen_only?
    self.user_type_restriction == "citizen"
  end
  
  def senator_only?
    self.user_type_restriction == "senator"
  end
  
  def citizen_only!
    update_attributes!(:user_type_restriction => "citizen")
  end
  
  def senator_only!
    update_attributes!(:user_type_restriction => "senator")
  end
  
  def commodity?
    category == 'commodity'
  end
  
  def artisan?
    category == 'artisan'
  end
  
  def produceable?
    artisan? || ship_section?
  end
  
  def tradeable?
    commodity? || produceable?
  end
  
  def building?
    category == 'building'
  end
  
  def ship_section?
    category == 'ship_section'
  end
  
  def chassis?
    sub_category == 'chassis'
  end
  
  def command?
    sub_category == 'command'
  end

  def mission?
    sub_category == 'mission'
  end

  def engine?
    sub_category == 'engine'
  end

  def armour?
    sub_category == 'armour'
  end

  def ore?
    sub_category == 'ore'
  end

  def lifeform?
    sub_category == 'lifeform'
  end

  def resource?
    sub_category == 'resource'
  end
  
  def plantlife?
    name == 'Plantlife'
  end
  
  def livestock?
    name == 'Livestock'
  end
  
  def slave?
    name == 'Slave'
  end
  
  def freeman?
    name == 'Freeman'
  end
  
  def sailor?
    name == 'Sailor'
  end
  
  def solder?
    name == 'Soldier'
  end
  
  def marine?
    name == 'Marine'
  end
  
  def master_artisan?
    name == 'Master Artisan'
  end
  
  def philosopher?
    name == 'Philosopher'
  end
  
  def officer?
    name == 'Officer'
  end
  
  def food?
    name == 'Food'
  end
  
  def clothing?
    name == 'Clothing'
  end
  
  def wine?
    name == 'Wine'
  end
  
  def luxuries?
    name == 'Luxuries'
  end

  def item_attributes
    attrs = {}
    ItemAttribute.find(:all, :conditions => ['item_id = ?', self.id]).each do |ia|
      attrs[ia.name] = ia.value
    end
    attrs
  end
  
  def item_attributes=(values)
    values.each do |name,value|
      set_item_attribute_value!(name,value)
    end
  end
  
  def item_attribute_value(name)
    ItemAttribute.attribute(self,name)
  end
  
  def set_item_attribute_value!(name, value)
    ItemAttribute.set_attribute!(self, name, value)
  end
  
  def raw_materials
    rms = {}
    ItemRawMaterials.for_item(self).each do |rm|
      rms[rm.raw_material] = rm.quantity
    end
    rms
  end
  
  def raw_materials=(values)
    values.each do |item_id,quantity|
      set_raw_material_quantity!(Item.find(item_id),quantity)
    end
  end
  
  def raw_material_quantity(item)
    ItemRawMaterials.count_for_item(self, item)
  end
  
  def set_raw_material_quantity!(item, quantity)
    ItemRawMaterials.set_for_item(self, item, quantity)
  end
  
  def add_raw_materials(items = Industry.calculate_raw_materials(self))
    items.each do |item, quantity|
      set_raw_material_quantity!(item, quantity)
    end
  end
  
  def self.create_ore!(name)
    create!(:name => name, :category => "commodity", :sub_category => "ore", :mass => 1)
  end
  
  def self.create_lifeform!(name, lifeform_wages = 0, trained = 0, knowledge_bearer = 0)
    i = create!(:name => name, :category => "commodity", :sub_category => "lifeform", :mass => 1)
    i.set_item_attribute_value!(Attributes::KNOWLEDGE_BEARER, knowledge_bearer) if knowledge_bearer > 0
    i.set_item_attribute_value!(Attributes::WAGES, lifeform_wages) if lifeform_wages > 0
    i.set_item_attribute_value!(Attributes::TRAINED, trained) if trained > 0
    i.set_item_attribute_value!(Attributes::UNIQUE_INDIVIDUAL, 1) if knowledge_bearer > 0
    i
  end
  
  def self.create_resource!(name)
    create!(:name => name, :category => "commodity", :sub_category => "resource", :mass => 1)
  end
  
  def self.create_module!(name, raw_materials = {})
    i = create!(:name => name, :category => "artisan", :sub_category => "module", :mass => 50)
    i.add_raw_materials(raw_materials)
    i
  end
  
  def self.create_hull!(name, hull_integrity = 1000, restricted = nil)
    i = create!(:name => name, :category => "artisan", :sub_category => "hull", :mass => 1000)
    i.set_item_attribute_value!(Attributes::HULL_INTEGRITY, hull_integrity)
    i.set_item_attribute_value!(Attributes::SENSOR_PROFILE, 5)
    i.add_raw_materials
    i.restrict!(restricted) unless restricted.nil?
    i
  end
  
  def self.create_chassis!(name, hull_type, restricted, command, mission, engine, armour = 0)
    i = create!(:name => name, :category => "ship_section", :sub_category => "chassis", :mass => ((command + mission + engine) * 1000))
    i.set_item_attribute_value!(Attributes::COMMAND_SECTIONS, command)
    i.set_item_attribute_value!(Attributes::MISSION_SECTIONS, mission)
    i.set_item_attribute_value!(Attributes::ENGINE_SECTIONS, engine)
    i.set_item_attribute_value!(Attributes::ARMOUR_CAPACITY, armour)
    i.set_raw_material_quantity!(hull_type, (command + mission + engine))
    i.restrict!(restricted) unless restricted.nil?
    i
  end
  
  def self.create_command!(name, armour_factor, restricted)
    i = create!(:name => name, :category => "ship_section", :sub_category => "command", :mass => 1000)
    i.set_item_attribute_value!(Attributes::ARMOUR_FACTOR, armour_factor)
    i.restrict!(restricted) unless restricted.nil?
    i
  end
  
  def self.create_bridge!(name, crew_efficiency = 0, combat_efficiency = 0, sensor_power = 0, armour_factor = 100, restricted = nil)
    i = create_command!(name, armour_factor, restricted)
    i.set_item_attribute_value!(Attributes::CREW_EFFICIENCY, crew_efficiency)
    i.set_item_attribute_value!(Attributes::COMBAT_EFFICIENCY, combat_efficiency)
    i.set_item_attribute_value!(Attributes::SENSOR_POWER, sensor_power)
    i.add_raw_materials
    i
  end

  def self.create_sensor!(name, sensor_power = 0, restricted = nil)
    i = create_command!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::SENSOR_POWER, sensor_power)
    i.add_raw_materials
    i
  end  

  def self.create_stealth!(name, sensor_profile = 0, restricted = nil)
    i = create_command!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::SENSOR_PROFILE, sensor_profile)
    i.add_raw_materials
    i
  end  

  def self.create_targetting!(name, ship_accuracy = 0, restricted = nil)
    i = create_command!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::SHIP_ACCURACY, ship_accuracy)
    i.add_raw_materials
    i
  end  

  def self.create_cloak!(name, energy_cost = 0, restricted = nil)
    i = create_command!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::CLOAKING, energy_cost)
    i.add_raw_materials
    i
  end 
  
  def self.create_squadron_command!(name, armour_factor = 100, restricted = nil)
    i = create_command!(name, armour_factor, restricted)
    i.set_item_attribute_value!(Attributes::SQUADRON_LEADER, 1)
    i.add_raw_materials
    i
  end

  def self.create_mission!(name, armour_factor = 100, restricted = nil)
    i = create!(:name => name, :category => "ship_section", :sub_category => "mission", :mass => 1000)
    i.set_item_attribute_value!(Attributes::ARMOUR_FACTOR, armour_factor)
    i.restrict!(restricted) unless restricted.nil?
    i
  end
  
  def self.create_life_capacity!(name, life_capacty = 0, armour_factor = 100, restricted = nil)
    i = create_mission!(name, armour_factor, restricted)
    i.set_item_attribute_value!(Attributes::LIFE_CAPACITY, life_capacty)
    i.add_raw_materials
    i
  end

  def self.create_cargo_capacity!(name, cargo_capacty = 0, armour_factor = 100, restricted = nil)
    i = create_mission!(name, armour_factor, restricted)
    i.set_item_attribute_value!(Attributes::CARGO_CAPACITY, cargo_capacty)
    i.add_raw_materials
    i
  end

  def self.create_ore_capacity!(name, ore_capacty = 0, armour_factor = 100, restricted = nil)
    i = create_mission!(name, armour_factor, restricted)
    i.set_item_attribute_value!(Attributes::ORE_CAPACITY, ore_capacty)
    i.add_raw_materials
    i
  end

  def self.create_resource_capacity!(name, resource_capacty = 0, armour_factor = 100, restricted = nil)
    i = create_mission!(name, armour_factor, restricted)
    i.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY, resource_capacty)
    i.add_raw_materials
    i
  end

  def self.create_mining_section!(name, ore_capacty = 0, restricted = nil)
    i = create_mission!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::ORE_CAPACITY, ore_capacty)
    i.set_item_attribute_value!(Attributes::MINING, 1)
    i.add_raw_materials
    i
  end

  def self.create_resource_section!(name, resource_capacty = 0, restricted = nil)
    i = create_mission!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY, resource_capacty)
    i.set_item_attribute_value!(Attributes::HARVESTING, 1)
    i.add_raw_materials
    i
  end
  
  def self.create_marine_capacity!(name, marine_capacty = 0, restricted = nil)
    i = create_mission!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::MARINE_CAPACITY, marine_capacty)
    i.add_raw_materials
    i
  end

  def self.create_weapon!(name, weapon_type, damage = 0, accuracy_bonus = 0, restricted = nil)
    i = create_mission!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::WEAPON_TYPE, weapon_type)
    i.set_item_attribute_value!(Attributes::DAMAGE, damage)
    i.set_item_attribute_value!(Attributes::WEAPON_ACCURACY, accuracy_bonus) if accuracy_bonus > 0
    i.add_raw_materials
    i
  end
  
  def self.create_drone!(name, damage = 0, point_defenses = 0, restricted = nil)
    i = create_mission!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::WEAPON_TYPE, Attributes::WEAPON_TYPE_DRONE)
    i.set_item_attribute_value!(Attributes::POINT_DEFENSE_FACTORS, point_defenses)
    i.set_item_attribute_value!(Attributes::DAMAGE, damage)
    i.add_raw_materials
    i
  end
  
  def self.create_shield!(name, energy_absorption = 0, restricted = nil)
    i = create_mission!(name, 250, restricted)
    i.set_item_attribute_value!(Attributes::ENERGY_ABSORPTION, energy_absorption)
    i.add_raw_materials
    i
  end

  def self.create_point_defense!(name, point_defenses = 0, restricted = nil)
    i = create_mission!(name, 100, restricted)
    i.set_item_attribute_value!(Attributes::POINT_DEFENSE_FACTORS, point_defenses)
    i.add_raw_materials
    i
  end

  def self.create_engine!(name, energy_charge = 0, thrust_speed = 0, node_speed = 0, warp_speed = 0, restricted = nil)
    i = create!(:name => name, :category => "ship_section", :sub_category => "engine", :mass => 1000)
    i.set_item_attribute_value!(Attributes::ARMOUR_FACTOR, 100)
    i.set_item_attribute_value!(Attributes::ENERGY_CHARGE, energy_charge)
    i.set_item_attribute_value!(Attributes::MAX_ENERGY, energy_charge * 20)
    i.set_item_attribute_value!(Attributes::THRUST_SPEED, thrust_speed)
    i.set_item_attribute_value!(Attributes::NODE_SPEED, node_speed)
    i.set_item_attribute_value!(Attributes::WARP_SPEED, warp_speed)
    i.add_raw_materials
    i.restrict!(restricted) unless restricted.nil?
    i
  end
  
  def self.create_power_plant!(name, energy_charge = 0, restricted = nil)
    create_engine!(name, energy_charge, 0, 0, 0, restricted)
  end

  def self.create_thrust_engine!(name, thrust_speed = 0, restricted = nil)
    create_engine!(name, 0, thrust_speed, 0, 0, restricted)
  end

  def self.create_node_drive!(name, node_speed = 0, restricted = nil)
    create_engine!(name, 0, 0, node_speed, 0, restricted)
  end

  def self.create_warp_drive!(name, warp_speed = 0, restricted = nil)
    create_engine!(name, 0, 0, 0, warp_speed, restricted)
  end

  def self.create_armour!(name,mass,energy_absorption = 0, sensor_profile = 0, armour_factor = 100, restricted = nil)
    i = create!(:name => name, :category => "ship_section", :sub_category => "armour", :mass => mass)
    i.set_item_attribute_value!(Attributes::ARMOUR_FACTOR, armour_factor)
    i.set_item_attribute_value!(Attributes::ENERGY_ABSORPTION, energy_absorption)
    i.set_item_attribute_value!(Attributes::SENSOR_PROFILE, sensor_profile)
    i.add_raw_materials
    i.restrict!(restricted) unless restricted.nil?
    i
  end

  def self.create_building!(name, civilian, industrial, transportation, security, restricted = nil, senators_only = false)
    i = create!(:name => name, :category => "building", :sub_category => "building", :mass => (civilian + industrial + transportation + security) * 500)
    i.set_raw_material_quantity!(Item.civilian_modules.first, civilian) if civilian > 0
    i.set_raw_material_quantity!(Item.industrial_modules.first, industrial) if industrial > 0
    i.set_raw_material_quantity!(Item.transportation_modules.first, transportation) if transportation > 0
    i.set_raw_material_quantity!(Item.security_modules.first, security) if security > 0
    i.restrict!(restricted) if restricted
    if senators_only
      i.senator_only!
    else
      i.citizen_only!  
    end
    i
  end
  
  def to_s
    self.name
  end
  
  def notes
    descriptor = ""
    descriptor="#{descriptor}, tough" if tough?
    descriptor="#{descriptor}, efficient" if efficient?
    descriptor="#{descriptor}, keen" if keen?
    descriptor="#{descriptor}, stealthed" if stealthed?
    descriptor="#{descriptor}, specialized" if specialized?
    descriptor="#{descriptor}, accurate" if accurate?
    if luxurious?
      descriptor="#{descriptor}, luxurious" if luxurious?
    elsif compact?
      descriptor="#{descriptor}, compact" 
    end
    if high_energy?
      descriptor="#{descriptor}, high energy" 
    elsif low_energy?
      descriptor="#{descriptor}, low energy" 
    end
    descriptor="#{descriptor}, fast" if fast?
    descriptor.length > 0 ? descriptor[2..descriptor.length].capitalize : 'None'
  end
  
  def torpedo?
    item_attribute_value(Attributes::WEAPON_TYPE) == Attributes::WEAPON_TYPE_TORPEDO
  end

  def laser?
    item_attribute_value(Attributes::WEAPON_TYPE) == Attributes::WEAPON_TYPE_LASER
  end

  def drone?
    item_attribute_value(Attributes::WEAPON_TYPE) == Attributes::WEAPON_TYPE_DRONE
  end

  def missile?
    item_attribute_value(Attributes::WEAPON_TYPE) == Attributes::WEAPON_TYPE_MISSILE
  end

  def particle?
    item_attribute_value(Attributes::WEAPON_TYPE) == Attributes::WEAPON_TYPE_PARTICLE
  end

  def kinetic?
    item_attribute_value(Attributes::WEAPON_TYPE) == Attributes::WEAPON_TYPE_KINETIC
  end

  def tough?
    return false unless ship_section?
    (item_attribute_value(Attributes::ARMOUR_FACTOR) > 0 && mass / item_attribute_value(Attributes::ARMOUR_FACTOR) < 10) ||
    (item_attribute_value(Attributes::HULL_INTEGRITY) > 0 && mass / item_attribute_value(Attributes::HULL_INTEGRITY) < 1)
  end
  
  def efficient?
    return false unless ship_section?
    item_attribute_value(Attributes::CREW_EFFICIENCY) > 100 ||
    item_attribute_value(Attributes::COMBAT_EFFICIENCY) > 50
  end
  
  def keen?
    return false unless ship_section?
    item_attribute_value(Attributes::SENSOR_POWER) > 10
  end
  
  def stealthed?
    return false unless ship_section?
    item_attribute_value(Attributes::SENSOR_PROFILE) < 0 ||
    item_attribute_value(Attributes::CLOAKING) > 0 ||
    (drone? && item_attribute_value(Attributes::DAMAGE) > 50)
  end
  
  def specialized?
    return false unless ship_section?
    item_attribute_value(Attributes::SQUADRON_LEADER) > 0 ||
    item_attribute_value(Attributes::MINING) > 0 ||
    item_attribute_value(Attributes::HARVESTING) > 0 ||
    item_attribute_value(Attributes::MARINE_CAPACITY) > 0
  end
  
  def accurate?
    return false unless ship_section?
    item_attribute_value(Attributes::SHIP_ACCURACY) > 0 ||
    item_attribute_value(Attributes::WEAPON_ACCURACY) > 0 ||
    laser? ||
    drone? ||
    item_attribute_value(Attributes::POINT_DEFENSE_FACTORS) >= 100
  end
  
  def luxurious?
    return false unless ship_section?
      !compact? && (
      item_attribute_value(Attributes::MARINE_CAPACITY) > 0 ||
      item_attribute_value(Attributes::LIFE_CAPACITY) > 0
      )
  end
    
  def compact?
    return false unless ship_section?
    item_attribute_value(Attributes::MARINE_CAPACITY) > 100 ||
    item_attribute_value(Attributes::LIFE_CAPACITY) > 100 ||
    item_attribute_value(Attributes::ORE_CAPACITY) > 1000 ||
    item_attribute_value(Attributes::RESOURCE_CAPACITY) > 500 ||
    item_attribute_value(Attributes::CARGO_CAPACITY) > 1000 ||
    (item_attribute_value(Attributes::HULL_INTEGRITY) > 0 && mass / item_attribute_value(Attributes::HULL_INTEGRITY) < 0.5)
  end
  
  def low_energy?
    return false unless ship_section?
    item_attribute_value(Attributes::ENERGY_CHARGE) > 0 ||
    item_attribute_value(Attributes::MAX_ENERGY) > 0 ||
    item_attribute_value(Attributes::ENERGY_ABSORPTION) > 0 ||
    item_attribute_value(Attributes::THRUST_SPEED) > 0 ||
    laser? ||
    drone? ||
    missile? ||
    kinetic?
  end
  
  def high_energy?
    return false unless ship_section?
    item_attribute_value(Attributes::POINT_DEFENSE_FACTORS) > 200 ||
    item_attribute_value(Attributes::ENERGY_CHARGE) > 25 ||
    item_attribute_value(Attributes::ENERGY_ABSORPTION) / mass >= 0.1 ||
    item_attribute_value(Attributes::MAX_ENERGY) > 500 ||
    (item_attribute_value(Attributes::THRUST_SPEED) > 0 && item_attribute_value(Attributes::THRUST_SPEED) < 10) ||
    item_attribute_value(Attributes::NODE_SPEED) > 0 ||
    item_attribute_value(Attributes::WARP_SPEED) > 0 ||
    item_attribute_value(Attributes::CLOAKING) > 0 ||
    item_attribute_value(Attributes::LIFE_CAPACITY) >= 750 ||
    (missile? && item_attribute_value(Attributes::DAMAGE) >= 150) ||
    (kinetic? && item_attribute_value(Attributes::DAMAGE) >= 1000) ||
    torpedo? ||
    particle?
  end
  
  def fast?
    return false unless ship_section?
    (item_attribute_value(Attributes::THRUST_SPEED) > 0 && item_attribute_value(Attributes::THRUST_SPEED) < 20) ||
    (item_attribute_value(Attributes::NODE_SPEED) > 0 && item_attribute_value(Attributes::NODE_SPEED) < 50) ||
    (item_attribute_value(Attributes::WARP_SPEED) > 0 && item_attribute_value(Attributes::WARP_SPEED) < 100) ||
    drone?
  end
  
  def governor?
    item_attribute_value(Attributes::GOVERNOR) > 0
  end
  
  def mining?
    item_attribute_value(Attributes::MINING) > 0
  end
  
  def harvesting?
    item_attribute_value(Attributes::HARVESTING) > 0
  end
  
  def breeding?
    item_attribute_value(Attributes::BREEDING) > 0
  end
  
  def farming?
    item_attribute_value(Attributes::FARMING) > 0
  end

  def butchering?
    item_attribute_value(Attributes::BUTCHERING) > 0
  end
  
  def tanning?
    item_attribute_value(Attributes::TANNING) > 0
  end

  def weaving?
    item_attribute_value(Attributes::WEAVING) > 0
  end

  def vineyard?
    item_attribute_value(Attributes::WINE_MAKING) > 0
  end

  def baking?
    item_attribute_value(Attributes::BAKING) > 0
  end

  def production
    item_attribute_value(Attributes::PRODUCTION)
  end

  def ship_building
    item_attribute_value(Attributes::SHIP_BUILDING)
  end

  def ship_repair?
    item_attribute_value(Attributes::SHIP_REPAIR)
  end

  def education?
    item_attribute_value(Attributes::EDUCATION) > 0
  end

  def research?
    item_attribute_value(Attributes::RESEARCH) > 0
  end
  
  def wages
    item_attribute_value(Attributes::WAGES).to_i
  end
  
  def freemen
    item_attribute_value(Attributes::EMPLOYEE_FREEMEN).to_i
  end
  
  def slaves
    item_attribute_value(Attributes::EMPLOYEE_SLAVES).to_i
  end
  
  def engineers
    item_attribute_value(Attributes::EMPLOYEE_ENGINEERS).to_i
  end
  
  def soldiers
    item_attribute_value(Attributes::EMPLOYEE_SOLDIERS).to_i
  end
  
  def marines
    item_attribute_value(Attributes::EMPLOYEE_MARINES).to_i
  end
  
  def sailors
    item_attribute_value(Attributes::EMPLOYEE_SAILORS).to_i
  end
  
  def officers
    item_attribute_value(Attributes::EMPLOYEE_OFFICER).to_i
  end
  
  def philosophers
    item_attribute_value(Attributes::EMPLOYEE_PHILOSOPHER).to_i
  end
  
  def master_artisans
    item_attribute_value(Attributes::EMPLOYEE_MASTER_ARTISAN).to_i
  end
  
  def unique_individual?
    item_attribute_value(Attributes::UNIQUE_INDIVIDUAL) > 0
  end
  
  def unique_building?
    item_attribute_value(Attributes::UNIQUE_BUILDING) > 0
  end
  
  def cargo_capacity
    item_attribute_value(Attributes::CARGO_CAPACITY).to_i
  end
  
  def ore_capacity
    item_attribute_value(Attributes::ORE_CAPACITY).to_i
  end
  
  def resource_capacity
    item_attribute_value(Attributes::RESOURCE_CAPACITY).to_i
  end
  
  def life_capacity
    item_attribute_value(Attributes::LIFE_CAPACITY).to_i
  end

  def marine_capacity
    item_attribute_value(Attributes::MARINE_CAPACITY).to_i
  end
  
  def breeds_item
    breed_item_id = item_attribute_value(Attributes::BREEDS_ITEM).to_i
    Item.find(:first, :conditions => {:id => breed_item_id}) if breed_item_id > 0
  end
  
  def breeds_item=(item)
    set_item_attribute_value!(Attributes::BREEDS_ITEM,item.id)
  end
  
  def employees_needed
    employees = {}
    employees[Item.freemen.first] = freemen
    employees[Item.slaves.first] = slaves
    employees[Item.engineers.first] = engineers
    employees[Item.soldiers.first] = soldiers
    employees[Item.marines.first] = marines
    employees[Item.sailors.first] = sailors
    employees[Item.officers.first] = officers
    employees[Item.philosophers.first] = philosophers
    employees[Item.master_artisans.first] = master_artisans
    employees
  end
  
  def wage_cost
    total = 0
    employees_needed.each do |employee, quantity|
      total += (employee.wages * quantity)
    end
    total
  end
  
  def mass_produced_per_maintenance
    ship_building > 0 ? ship_building * 1000 : production
  end
  
  def producer
    return nil unless produceable?
    chassis? ? Item.shipyard.first : Item.workshop.first
  end
  
  def raw_material_cost
    return @raw_material_cost unless @raw_material_cost.nil?
    @raw_material_cost = 0
    raw_materials.each do |item, quantity|
      @raw_material_cost += (item.raw_cost * quantity)
    end
    @raw_material_cost
  end
  
  def raw_cost
    @raw_cost ||= if ore?
      (Item.mine.first.wage_cost / Deposit.average_yield(self)).round(2)
    elsif resource?
      (Item.mine.first.wage_cost / Deposit.average_yield(self)).round(2)
    elsif lifeform?
      if wages > 0
        wages
      elsif plantlife?
        (Item.farm.first.wage_cost / 100.0).round(2)
      elsif livestock?
        (Item.ranch.first.wage_cost / 100.0).round(2)
      end
    elsif produceable?
      (producer.wage_cost / producer.mass_produced_per_maintenance).round(2) + raw_material_cost
    elsif building?
      raw_material_cost
    else
      0
    end
  end
end
