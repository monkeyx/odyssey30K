class Colony < ActiveRecord::Base
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100

  validates_presence_of   :celestial_body_id
  belongs_to              :celestial_body
  alias_method            :planet, :celestial_body

  validates_presence_of   :governor_id
  belongs_to              :governor,    :class_name => 'User'
  
  validates_numericality_of :tax_rate,  :greater_than_or_equal_to => 0
  
  default_value_for :tax_rate, 0
  
  named_scope        :on_planets, lambda {|planets| 
    {:conditions => ['celestial_body_id IN (?)', planets.map{|p| p.id} ]}
  }
  
  named_scope        :has_building, lambda {|building_type|
    {:conditions => ['id IN (?)', Building.building_type(building_type).map{|b| b.colony_id}]}
  }
  
  def self.starting_colonies
    on_planets(CelestialBody.security_alpha).has_building(Item.shipyard.first)
  end
  
  def self.random_starting_colony
    starting_colonies.sort_by{rand}.first
  end
  
  BUILDING_POLICY = ["open", "limited", "closed"]
  
  validates_inclusion_of  :building_policy, :in => BUILDING_POLICY
  default_value_for       :building_policy do
    "open"
  end
  
  def open?
    building_policy == "open"
  end
  
  def limited?
    building_policy == "limited"
  end
  
  def closed?
    building_policy == "closed"
  end
  
  def limited_building!
    log!("Building Policy changed to Limited")
    update_attributes!(:building_policy => "limited")
  end
  
  def closed_building!
    log!("Building Policy changed to Closed")
    update_attributes!(:building_policy => "closed")
  end
  
  def open_building!
    log!("Building Policy changed to Open")
    update_attributes!(:building_policy => "open")
  end
  
  has_many                :buildings
  has_many                :colonists, :order => 'quantity DESC, drachma DESC'
  has_many                :market_orders
  
  def population
    pop = {}
    self.colonists.each do |colonist|
      qty = pop[colonist.lifeform]
      qty = 0 if qty.nil?
      qty += colonist.quantity
      pop[colonist.lifeform] = qty
    end
    pop.sort{|a,b| b[1] <=> a[1]}
  end
  
  def population_size
    total = 0
    population.each do |lifeform, qty|
      total += qty
    end
    total
  end
  
  def has_building?(building_type)
    0 < Building.count(:conditions => ['colony_id = ? AND building_type_id = ?', self.id, building_type.id])
  end
  
  def owns_building?(owner, building_type)
    0 < Building.count(:conditions => ['colony_id = ? AND building_type_id = ? AND owner_id = ?', self.id, building_type.id, owner.id])
  end
  
  def build!(building_type, owner = self.governor)
    b = Building.build!(self, building_type, owner)  
    log!("#{owner} built #{building_type}") if b
    b
  end
  
  def admin_center
    Building.in_colony(self).building_type(Item.admin_center.first).first
  end
  
  def to_s
    self.name
  end
  
  def self.seed_colony!(owner, celestial_body, size, building_policy = "open", name = $COLONY_NAME_GENERATOR.generate_names(1)[0])
    colony = Colony.create!(:name => name, 
                          :celestial_body_id => celestial_body.id, 
                          :governor_id => owner.id, 
                          :tax_rate => 10,
                          :building_policy => building_policy)
    colony.log!("Colony #{name} founded on #{celestial_body}",true)
    colony.build!(Item.admin_center.first)
    (0..(size * 10)).each do
      colony.build!(Item.mine.first)
    end
    (0..(size * 10)).each do
      colony.build!(Item.harvester.first)
    end
    livestock = Item.livestock.first
    (0..(size * 10)).each do
      b = colony.build!(Item.ranch.first)
      b.add_items!(livestock, Item.ranch.first.life_capacity / 2)
    end
    plantlife = Item.plantlife.first
    (0..(size * 10)).each do
      b = colony.build!(Item.farm.first)
      b.add_items!(plantlife, Item.farm.first.life_capacity / 2)
    end
    if size > 2
      (0..(size / 2).to_i).each do
        colony.build!(Item.slaughterhouse.first)
      end
      (0..(size / 2).to_i).each do
        colony.build!(Item.bakery.first)
      end
      (0..(size / 2).to_i).each do
        colony.build!(Item.vineyard.first)
      end
      (0..(size / 2).to_i).each do
        colony.build!(Item.weavers.first)
      end
      (0..(size / 2).to_i).each do
        colony.build!(Item.tannery.first)
      end
    end
    if size > 3
      (0..size).each do
        colony.build!(Item.warehouse.first)
      end
      (0..(size * 3)).each do
        colony.build!(Item.workshop.first)
      end
      colony.build!(Item.school.first)
      colony.build!(Item.boot_camp.first)
    end
    if size > 4
      colony.build!(Item.training_camp.first)
    end
    if size > 5    
      colony.build!(Item.naval_camp.first)
      colony.build!(Item.technical_college.first)
      colony.build!(Item.shipyard.first)
      colony.build!(Item.rigger.first)
    end
    if size > 6
      colony.build!(Item.academy.first)
      colony.build!(Item.university.first)
    end
    colony.buildings.each do |building|
      building.employees_needed.each do |lifeform,quantity|
        building.add_employee!(lifeform, quantity)
      end
    end
    colony
  end
  
  def seed_market!(buy_items, sell_items)
    sell_items.each do |item|
      MarketOrder.sell!(User.zeus, self, [item], 5000, MarketOrder.suggested_sell_price(self, [item]))
    end
    buy_items.each do |item|
      MarketOrder.buy!(User.zeus, self, [item], 5000, MarketOrder.suggested_buy_price(self, [item]), true)
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
      log!("Daily maintenance")
      self.planet.maintenance!
      self.colonists.each do |c|
        c.maintenance!
      end
      self.buildings.each do |b|
        b.maintenance!
      end
      if governor == User.zeus
        governor_buy_resources(Item.food)
        governor_buy_resources(Item.wine)
        governor_buy_resources(Item.clothing)
        governor_buy_resources(Item.luxuries)
      end
    end
  end
  
  def governor_buy_resources(resources)
    # puts "Governor the demand level for #{resources} is #{MarketOrder.demand_level(self, resources)[0]}"
    if MarketOrder.demand_level(self, resources)[0] >= 0
      MarketOrder.buy!(governor, self, resources, population_size, MarketOrder.suggested_buy_price(self, resources), true, admin_center)
    end
  end
  
  def log!(description,major=false)
    Event.log!(self.governor, self, description, major)
  end
  
  def event_log
    Event.find(:all, :conditions => {:model_id => self.id, :model_class => self.class.name})
  end
  
  def can_refit_starship?
    has_building?(Item.rigger.first)
  end
  
  def can_commission_starship?
    has_building?(Item.shipyard.first)
  end
end
