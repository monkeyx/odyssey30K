class Starship < ActiveRecord::Base
  
  before_validation       :calculate_attributes
  after_save              :check_integrity
  
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100

  validates_presence_of   :celestial_body_id
  belongs_to              :celestial_body
  
  has_one                 :star_system, :through => :celestial_body

  validates_presence_of   :captain_id
  belongs_to              :captain,    :class_name => 'User'
  
  validates_numericality_of   :squadron_id,   :only_integer => true, :allow_nil => true
  belongs_to              :squadron
  
  validates_numericality_of   :colony_id,   :only_integer => true, :allow_nil => true
  belongs_to              :colony
  
  validates_presence_of   :chassis_id
  belongs_to              :chassis,     :class_name => 'Item'
  
  validates_numericality_of :crew_efficiency
  validates_numericality_of :combat_efficiency
  
  validates_numericality_of :current_integrity
  default_value_for         :current_integrity, 100.0
  
  validates_numericality_of :current_energy
  default_value_for         :current_energy, 0.0
  
  has_many                :crew
  has_many                :cargo,       :class_name => 'StarshipCargo'
  
  named_scope   :at_colony, lambda {|colony| 
    {:conditions => {:colony_id => colony.id}}
  }
  
  named_scope   :in_orbit, lambda {|body| 
    {:conditions => {:celestial_body_id => body.id}}
  }

  def self.build_ship!(colony, chassis, captain, name = "#{captain.login} Ship")
    s = create!(:name => name, :celestial_body_id => colony.celestial_body_id, :captain_id => captain.id, :colony_id => colony.id, :chassis_id => chassis.id)
    s.add_item_knowledge!(chassis)
    s
  end
  
  MAX_ENERGY_COST = 10000000
  ACTIVE_SCAN_ENERGY_COST = 10
  PROBE_ENERGY_COST = 50
  ORBITAL_ENERGY_CONSTANT = 300
  
  def use_energy!(e)
    return false if self.current_energy < e
    update_attributes(:current_energy => self.current_energy - e.to_i)
    true
  end
  
  def energy_cost_base_thrust(distance)
    return MAX_ENERGY_COST if crew_efficiency == 0 || starship_attribute_value(Attributes::THRUST_SPEED) == 0
    (distance / (starship_attribute_value(Attributes::THRUST_SPEED) * (crew_efficiency / 100.0))).to_i
  end
  
  def energy_cost_take_off_or_land(gravity_rating=self.celestial_body.gravity_rating)
    energy_cost_base_thrust(ORBITAL_ENERGY_CONSTANT * gravity_rating)
  end
  
  def energy_cost_thrust_move(destination)
    x = self.celestial_body.orbital_ring > destination.orbital_ring ? self.celestial_body.orbital_ring - destination.orbital_ring : destination.orbital_ring - self.celestial_body.orbital_ring
    x *= ORBITAL_ENERGY_CONSTANT
    y = self.celestial_body.orbital_quadrant > destination.orbital_quadrant ? self.celestial_body.orbital_quadrant - destination.orbital_quadrant : destination.orbital_quadrant - self.celestial_body.orbital_quadrant
    y *= ORBITAL_ENERGY_CONSTANT
    distance = x + y > 0 ? x + y : 1
    energy_cost_base_thrust(distance) + energy_cost_take_off_or_land(destination.gravity_rating)
  end
  
  def thrust_move!(destination)
    raise "Cannot move from colony" if self.colony
    raise "Cannot move if not in orbit of a celestial body" if self.celestial_body.nil?
    raise "No need to move" if self.celestial_body == destination
    raise "Cannot thrust move to another star system" if self.celestial_body.star_system != destination.star_system
    raise "Insufficient energy" unless use_energy!(energy_cost_thrust_move(destination))
    update_attributes!(:celestial_body_id => destination.id)
    log!("Moved to orbit of #{destination.name}")
    true
  end
  
  def dock!
    raise "Cannot dock from colony" if self.colony
    raise "Cannot dock if not in orbit of a celestial body" if self.celestial_body.nil?
    raise "No colony here" if self.celestial_body.colony.nil?
    raise "Insufficient energy" unless use_energy!(energy_cost_take_off_or_land)
    update_attributes!(:colony_id => self.celestial_body.colony.id)
    log!("Docked at #{self.colony}")
    true
  end
  
  def take_off!
    raise "Cannot take off unless at colony" unless self.colony
    raise "Insufficient energy" unless use_energy!(energy_cost_take_off_or_land)
    update_attributes!(:colony_id => nil) 
    log!("Took off into orbit of #{self.celestial_body}")
    true
  end
  
  def scanned?(sensor_power)
    ProbabilityMatrix.test(sensor_power, ProbabilityMatrix::VERY_EASY + starship_attribute_value(Attributes::SENSOR_PROFILE))
  end
  
  def can_attack?
    # TODO
    true
  end
  
  def can_board?
    # TODO
    true
  end
  
  def attackable?(by_ship, boarding=false)
    return false unless by_ship.can_attack? && !boarding
    return false unless by_ship.can_board? && boarding
    # can't attack own ships
    return false if self.captain_id == by_ship.captain_id
    # no attacks in sec zone alpha
    return false if self.star_system.sec_zone_alpha?
    # no PvP attacks in sec zone beta
    return false if self.star_system.sec_zone_beta? && !self.captain == User.zeus
    # only boarding attacks in sec zone gamma
    return false if self.star_system_sec_zone_gamma? && !boarding
    true
  end
  
  def scan
    if self.colony
      Starship.at_colony(self.colony).select{|s| s != self && s.scanned?(starship_attribute_value(Attributes::SENSOR_POWER))}
    else
      Starship.in_orbit(self.celestial_body).select{|s| s != self && s.scanned?(starship_attribute_value(Attributes::SENSOR_POWER))}
    end
  end
  
  def current_galactic_coordinates
    raise "Invalid location" unless self.celestial_body
    self.celestial_body.galactic_coordinates
  end
  
  def location
    self.colony || self.celestial_body
  end
  
  def location_status
    self.colony ? "docked at" : "orbiting"
  end
  
  def starship_attributes
    attrs = {}
    StarshipAttribute.find(:all, :conditions => ['starship_id = ?', self.id]).each do |ia|
      attrs[ia.name] = ia.value
    end
    attrs
  end
  
  def starship_attributes=(values)
    values.each do |name,value|
      set_starship_attribute_value!(name,value)
    end
    save
  end
  
  def starship_attribute_value(name)
    StarshipAttribute.attribute(self, name)
  end
  
  def set_starship_attribute_value!(name, value)
    StarshipAttribute.set_attribute(self, name, value)
  end
  
  def sections=(values)
    StarshipSection.delete_all("starship_id = #{self.id}")
    values.each do |section|
      section = Item.find(section) unless section.is_a?(Item)
      add_section!(section)
    end
  end
  
  def sections
    r = []
    StarshipSection.find(:all, :conditions => ['starship_id = ?', self.id]).each do |ss|
      r << ss.section
    end
    r
  end
  
  def count_command_sections
    StarshipSection.in_starship(self).command.size
  end
  
  def count_mission_sections
    StarshipSection.in_starship(self).mission.size
  end
  
  def count_engine_sections
    StarshipSection.in_starship(self).engine.size
  end
  
  def can_add_sections(section)
    quantity = if section.command?
      starship_attribute_value(Attributes::COMMAND_SECTIONS) - count_command_sections
    elsif section.mission?
      starship_attribute_value(Attributes::MISSION_SECTIONS) - count_mission_sections
    elsif section.engine?
      starship_attribute_value(Attributes::ENGINE_SECTIONS) - count_engine_sections
    else
      0
    end
    quantity.to_i
  end
  
  def add_section!(section)
    StarshipSection.create!(:starship_id => self.id, :section_id => section.id)
    add_item_knowledge!(section)
    save
  end
  
  def remove_section!(section)
    ss = StarshipSection.find(:first, :conditions => ['starship_id = ? AND section_id = ?', self.id, section.id])
    ss.destroy if ss
    save
  end
  
  def count_sections(section)
    StarshipSection.count(:conditions => ['starship_id = ? AND section_id = ?', self.id, section.id])
  end
  
  def has_section?(section)
    count_sections(section) > 0
  end
  
  def installed_sections
    r = {}
    StarshipSection.find(:all, :conditions => ['starship_id = ?', self.id]).each do |ss|
      count = r[ss.section]
      count = 0 if count.nil?
      count += 1
      r[ss.section] = count
    end
    r
  end
  
  # BEGIN ITEM CONTAINER
  include ItemContainer
  
  def cargo_capacity
    starship_attribute_value(Attributes::CARGO_CAPACITY).to_i
  end
  
  def ore_capacity
    starship_attribute_value(Attributes::ORE_CAPACITY).to_i
  end
  
  def resource_capacity
    starship_attribute_value(Attributes::RESOURCE_CAPACITY).to_i
  end
  
  def life_capacity
    starship_attribute_value(Attributes::LIFE_CAPACITY).to_i
  end
  
  alias_method :stored_items, :cargo
  
  def count_item(item)
    StarshipCargo.count_item(self,item)
  end
  
  def get_stored_item(item)
    sc = StarshipCargo.find(:first, :conditions => ['starship_id = ? AND item_id = ?', self.id, item.id])
    sc = StarshipCargo.new(:starship_id => self.id, :item_id => item.id, :quantity => 0) if sc.nil?
    sc
  end
  
  def add_item_knowledge!(item)
    captain.add_knowledge!(item.knowledge) if item.restricted? && !captain.has_knowledge?(item.knowledge)
  end
  
  # END ITEM CONTAINER

  def add_crew!(lifeform, quantity)
    if lifeform.unique_individual? && quantity > 1
      (1..quantity).each{add_crew!(lifeform,1)}
      return
    end
    add_item_knowledge!(lifeform)
    c = Crew.find(:first, :conditions => {:starship_id => self.id, :lifeform_id => lifeform.id})
    c = Crew.new(:starship_id => self.id, :lifeform_id => lifeform.id, :quantity => 0) unless c && !c.unique?
    c.quantity = c.quantity + quantity.to_i
    c.save!
    save!
  end
  
  def remove_crew!(lifeform, quantity)
    c = Crew.find(:first, :conditions => {:starship_id => self.id, :lifeform_id => lifeform.id})
    c.update_attributes!(:quantity => c.quantity - quantity) if c
    save!
  end
  
  def count_crew(lifeform)
    if lifeform.unique_individual?
      Crew.count(:conditions => "lifeform_id = #{lifeform.id} AND starship_id = #{self.id}")
    else
      c = Crew.find(:first, :conditions => ['starship_id = ? AND lifeform_id = ?', self.id, lifeform.id])
      c.nil? ? 0 : c.quantity
    end
  end
  
  def required_crew
    r = {}
    r[Item.officers.first] = starship_attribute_value(Attributes::COMMAND_SECTIONS).to_i * Attributes::OFFICERS_PER_COMMAND_SECTION
    r[Item.engineers.first] = starship_attribute_value(Attributes::ENGINE_SECTIONS).to_i * Attributes::ENGINEERS_PER_COMMAND_SECTION
    r[Item.sailors.first] = starship_attribute_value(Attributes::MISSION_SECTIONS).to_i * Attributes::SAILORS_PER_MISSION_SECTION
    r[Item.marines.first] = starship_attribute_value(Attributes::MARINE_CAPACITY).to_i
    r
  end
  
  def can_hire_crew(lifeform)
    required_crew[lifeform] ? required_crew[lifeform] - count_crew(lifeform) : 0
  end
  
  def integrity_loss!(amount = (rand(100) / 10.0))
    self.current_integrity = self.current_integerity - amount.round(2)
    save!
    log!("lost #{amount.round(2)} integrity.")
  end
  
  def derelict!
    self.current_integrity = 0
    save!
    log!("integrity failure - ship turned into debris!")
  end
  
  def check_integrity
    if self.current_integrity < 20 && rand(20) > self.current_integrity
      derelict!
    end
  end
  
  private
  def calculate_attributes
    StarshipAttribute.delete_all({:starship_id => self.id })
    chassis.item_attributes.each do |attribute|
      value = Attributes.calculate_ship_attribute(attribute[0], starship_attribute_value(attribute[0]), attribute[1])
      set_starship_attribute_value!(attribute[0], value) unless value.nil?
    end
    self.sections.each do |section|
      section.item_attributes.each do |attribute|
        value = Attributes.calculate_ship_attribute(attribute[0], starship_attribute_value(attribute[0]), attribute[1])
        set_starship_attribute_value!(attribute[0], value) unless value.nil?
      end
    end
    max_energy = starship_attribute_value(Attributes::MAX_ENERGY)
    if max_energy > 0 && self.current_energy == 0
      self.current_energy = max_energy
    end
    self.crew.each do |crew|
      crew.skills.each do |skill|
        attr_name = skill.officer_skill_attribute
        value = Attributes.calculate_ship_attribute(attr_name, starship_attribute_value(attr_name), skill.attribute_modifier)
        set_starship_attribute_value!(attr_name, value) unless value.nil?
      end
    end
    calculate_efficiency!
  end
  
  def calculate_efficiency!
    base_efficiency = 0.0
    required_crew.each do |lifeform, quantity|
      base_efficiency += (count_crew(lifeform) / quantity) if quantity > 0
    end
    base_efficiency = base_efficiency / 3
    self.crew_efficiency = starship_attribute_value(Attributes::CREW_EFFICIENCY) * base_efficiency
    self.combat_efficiency = starship_attribute_value(Attributes::COMBAT_EFFICIENCY) * base_efficiency
  end
  
  public
  def tick!
    transaction do
      self.current_energy = self.current_energy + starship_attribute_value(Attributes::ENERGY_CHARGE)
      self.current_energy = starship_attribute_value(Attributes::MAX_ENERGY) if self.current_energy > starship_attribute_value(Attributes::MAX_ENERGY)
      save!
    end
  end
  
  def self.maintain_all!(colonies = Colony.all)
    colonies.each do |c|
      c.maintenance!
      print "."
    end
  end
  
  def maintenance!
    transaction do
      self.crew.each do |c|
        c.maintenance!
      end
      integrity_loss! if rand(100) > 80
    end
  end
  
  def log!(description)
    Event.log!(self.captain, self, description)
  end
  
  def event_log
    Event.find(:all, :conditions => {:model_id => self.id, :model_class => self.class.name})
  end
  
  def to_s
    name
  end
end
