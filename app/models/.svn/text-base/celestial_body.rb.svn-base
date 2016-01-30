class CelestialBody < ActiveRecord::Base
  before_validation       :calculate_growth_and_morale
  
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100

  BODY_TYPE = ["gas_giant", "asteroid_belt", "nebula", "planet", "moon"]
  BODY_TYPE.each {|s| named_scope s, :conditions => {:body_type => s}}

  HABITABLE_BODY_TYPES = ["planet","moon"]
  
  validates_inclusion_of  :body_type,  :in => BODY_TYPE
  
  def body_type_string
    body_type.gsub('_', ' ').titleize
  end
  
  validates_presence_of   :star_system_id
  belongs_to              :star_system
  
  validates_numericality_of :orbital_ring,   :only_integer => true, :great_than => 0, :less_than => 11
  validates_numericality_of :orbital_quadrant,   :only_integer => true, :great_than => 0, :less_than => 5
  
  validates_numericality_of :gravity_rating, :greater_than_or_equal_to => 0
  
  ATMOSPHERE_TYPES = ["vacuum", "toxic", "poisonous", "green", "idyllic", "nanite"]
  
  ATMOSPHERE_TYPES.each {|s| named_scope s, :conditions => {:atmosphere_type => s}}
  
  BREATHABLE_ATMOSPHERES = ["green","idyllic","nanite"]
  
  def self.random_atmosphere
    ATMOSPHERE_TYPES[0,5].sort_by{rand}.first
  end
  
  validates_inclusion_of  :atmosphere_type,  :in => ATMOSPHERE_TYPES
  
  SURFACE_TYPES = ["clouds", "craters", "rocky", "ice", "magma", "urban", "ruins", "forest", "jungle", "grasslands", "ocean"]
  SURFACE_TYPES.each {|s| named_scope s, :conditions => {:surface_types => s}}
  
  LIVEABLE_SURFACE_TYPES = ["ice", "urban", "ruins", "forest", "jungle", "grasslands", "ocean"]
  
  def self.random_surface
    SURFACE_TYPES[1,10].sort_by{rand}.first
  end
  
  validates_inclusion_of  :surface_type,  :in => SURFACE_TYPES
  
  has_many                :deposits
  has_one                 :colony
  
  named_scope             :breathable,    :conditions => ['atmosphere_type IN (?)', BREATHABLE_ATMOSPHERES]
  named_scope             :unbreathable,  :conditions => ['atmosphere_type NOT IN (?)', BREATHABLE_ATMOSPHERES]
  
  named_scope             :habitable,     :conditions => ['body_type IN (?) AND surface_type IN (?)', HABITABLE_BODY_TYPES, LIVEABLE_SURFACE_TYPES]
  named_scope             :unhabitable,   :conditions => ['body_type NOT IN (?) AND surface_type NOT IN (?)', HABITABLE_BODY_TYPES, LIVEABLE_SURFACE_TYPES]
  
  named_scope             :terraformable, :conditions => ['body_type IN (?) AND (surface_type NOT IN (?) OR atmosphere_type NOT IN (?))', HABITABLE_BODY_TYPES, LIVEABLE_SURFACE_TYPES, BREATHABLE_ATMOSPHERES]
  
  StarSystem::SEC_ZONES.each {|s| named_scope "security_#{s}", :conditions => ['star_system_id IN (?)', StarSystem.send("security_#{s}".to_sym).map{|s|s.id}]}
  
  named_scope             :occupied,      :conditions => ['id IN (?)',Colony.find(:all).map{|c|c.celestial_body_id}]
  named_scope             :unoccupied,      :conditions => ['id NOT IN (?)',Colony.find(:all).map{|c|c.celestial_body_id}]
  
  validates_numericality_of :colonist_growth_rate
  validates_numericality_of :morale_modifier
  
  def galactic_coordinates
    star_system.galactic_coordinates
  end
  
  def supports_life?
    HABITABLE_BODY_TYPES.include?(self.body_type) && BREATHABLE_ATMOSPHERES.include?(self.atmosphere_type) && LIVEABLE_SURFACE_TYPES.include?(self.surface_type)
  end
  
  def terraformable?
    HABITABLE_BODY_TYPES.include?(self.body_type) && !supports_life?
  end
  
  def terraform!
    self.atmosphere_type = BREATHABLE_ATMOSPHERES.sort_by{rand}.first unless BREATHABLE_ATMOSPHERES.include?(self.atmosphere_type)
    self.surface_type = ["forest", "jungle", "grasslands", "ocean"].sort_by{rand}.first unless LIVEABLE_SURFACE_TYPES.include?(self.surface_type)
    self.colonist_growth_rate = nil
    self.morale_modifier = nil
    save!
    self
  end
  
  def calculate_growth_and_morale
    mod = (BREATHABLE_ATMOSPHERES.include?(self.atmosphere_type) ? 1 : -1) + (LIVEABLE_SURFACE_TYPES.include?(self.surface_type) ? 1 : -1)
    if colonist_growth_rate.nil?
      self.colonist_growth_rate = mod
    end
    if morale_modifier.nil?
      self.morale_modifier = Colonist::MORALE_BOOST_PER_CATEGORY * mod
    end
  end
  
  def distance(to_celestal_body)
    return nil unless self.system == to_celestial_body.system
    x1 = self.orbital_ring > to_celestial_body.orbital_ring ? self.orbital_ring : to_celestial_body.orbital_ring
    x2 = self.orbital_ring < to_celestial_body.orbital_ring ? self.orbital_ring : to_celestial_body.orbital_ring
    dx = (x1 - x2)
    y1 = self.orbital_quadrant > to_celestial_body.orbital_quadrant ? self.orbital_quadrant : to_celestial_body.orbital_quadrant
    y2 = self.orbital_quadrant < to_celestial_body.orbital_quadrant ? self.orbital_quadrant : to_celestial_body.orbital_quadrant
    dy = (y1 - y2) * 5
    d = (dx + dy).to_i
    d > 0 ? d : 1
  end
  
  def to_s
    self.name
  end
  
  def create_deposit!(item, y)
    return unless y > 0
    growth = item.ore? ? 0 : (y * 20)
    reserves = item.ore? ? (20000 * y) : (y * 20)
    Deposit.create!(:celestial_body_id => self.id, :item_id => item.id, :deposit_yield => y, :deposit_growth => growth, :deposit_reserves => reserves)
  end
  
  def generate_deposits!
    create_deposit!(Item.metals.first,metals_yield)
    create_deposit!(Item.minerals.first,minerals_yield)
    create_deposit!(Item.hydrocarbons.first,hydrocarbons_yield)
    create_deposit!(Item.crystals.first,crystals_yield)
    create_deposit!(Item.clothing.first,clothing_yield)
    create_deposit!(Item.food.first,food_yield)
    create_deposit!(Item.wine.first,wine_yield)
    create_deposit!(Item.luxuries.first,luxuries_yield)
  end
  
  private
  def ore_yield(high_yield_surfaces, low_yield_surfaces)
    if high_yield_surfaces.include?(surface_type)
      return rand(60) + 90
    elsif low_yield_surfaces.include?(surface_type)
      return rand(20)
    else
      return 0
    end
  end
  
  def metals_yield
    ore_yield(["craters", "rocky", "magma", "urban", "ruins", "forest", "jungle", "grasslands"],["ice", "ocean"])
  end
  
  def minerals_yield
    ore_yield(["craters","rocky","ice", "magma", "urban", "ruins", "forest", "jungle", "ocean"],["grasslands"])
  end
  
  def hydrocarbons_yield
    ore_yield(["clouds","ice","forest","jungle", "grasslands", "ocean"],["magma","urban","ruins"])
  end
  
  def crystals_yield
    ore_yield(["magma"],["clouds","urban","ruins","forest","jungle","grasslands","ocean"])
  end
  
  def resource_yield(common_terrain, rare_terrain, resource_rarity)
    if common_terrain.include?(surface_type)
      return rand(60) + (80 - (4 * resource_rarity))
    elsif rare_terrain.include?(surface_type)
      return rand(20) + (80 - (4 * resource_rarity))
    else
      return 0
    end
  end
  
  def food_yield
    resource_yield(["urban","forest","jungle","grasslands","ocean"],["ice","ruins"], 0)
  end
  
  def wine_yield
    resource_yield(["forest","grasslands"],["urban","jungle"],10)
  end
  
  def clothing_yield
    resource_yield(["urban","forest","grasslands"],["ruins","jungle"],15)
  end
  
  def luxuries_yield
    resource_yield(["urban","forest","jungle"],["ice","ruins","grasslands","ocean"],19)
  end
  
  public
  def maintenance!
    # deposits growth
    deposits.each do |d|
      d.grow!
    end
  end
end
