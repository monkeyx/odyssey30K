class StarSystem < ActiveRecord::Base
  validates_presence_of   :name
  validates_length_of     :name,    :maximum => 100
  
  validates_numericality_of :x,   :only_integer => true
  validates_numericality_of :y,   :only_integer => true
  
  def galactic_coordinates
    [self.x, self.y]
  end
  
  def self.map_bounds
    m = find(:first, :select => "MIN(x) AS min_x, MAX(x) AS max_x, MIN(y) AS min_y, MAX(y) AS max_y")
    [[m.min_x.to_i,m.max_x.to_i], [m.min_y.to_i, m.max_y.to_i]]
  end
  
  def self.star_grid
    cols = {}
    StarSystem.all.each do |star|
      row = cols[star.x]
      row = {} unless row
      row[star.y] = star
      cols[star.x] = row
    end
    cols
  end
  
  named_scope :at_location, lambda{|x,y| 
    { :conditions => {:x => x, :y => y}}
  }
  
  STAR_TYPES = ["T","L","M","K","G","F","A","B","O"]
  STAR_TYPES.each {|s| named_scope "type_#{s}", :conditions => {:star_type => s}}
  
  def self.random_star_type
    STAR_TYPES.sort_by{rand}.first
  end
  
  validates_inclusion_of   :star_type,  :in => STAR_TYPES
  
  SEC_ZONES = ["alpha", "beta", "gamma", "delta"]
  SEC_ZONES.each {|s| named_scope "security_#{s}", :conditions => {:sec_zone => s}}
  
  validates_inclusion_of     :sec_zone,  :in => SEC_ZONES
  
  def sec_zone_alpha?
    self.sec_zone == 'alpha'
  end
  
  def sec_zone_beta?
    self.sec_zone == 'beta'
  end
  
  def sec_zone_gamma?
    self.sec_zone == 'gamma'
  end
  
  def sec_zone_delta?
    self.sec_zone == 'delta'
  end
  
  validates_presence_of :cluster_id
  belongs_to            :cluster
  
  has_many              :bodies,      :class_name => 'CelestialBody'
  has_many              :colonies,    :through => :bodies
  
  CLUSTER_NAMES = Cluster.all.map{|c|c.name}
  
  CLUSTER_NAMES.each {|c| named_scope c, :conditions => {:cluster_id => Cluster.find_by_name(c)}}
  
  ALLOWED_FILTERS = ['all'] + CLUSTER_NAMES + STAR_TYPES.map{|s|"type_#{s}"} + SEC_ZONES.map{|s|"security_#{s}"}
  
  def node_links
    systems = []
    NodeLink.find(:all, :conditions => ['from_star_system_id = ? OR to_star_system_id = ?', self.id, self.id]).each do |nl|
      nl.from == self ? systems << nl.to : systems << nl.from 
    end
    systems
  end
  
  def node_links=(systems)
    NodeLink.delete_all("from_star_system_id = #{self.id} OR to_star_system_id = #{self.id}")
    systems.each do |s|
      s = StarSystem.find(s) unless s.is_a?(StarSystem)
      add_node_link!(s)
    end
  end
  
  def connected?(to_system)
    0 < NodeLink.count(:conditions => ['(from_star_system_id = ? AND to_star_system_id = ?) OR (from_star_system_id = ? AND to_star_system_id = ?)',self.id,to_system.id,to_system.id,self.id])
  end
  
  def add_node_link!(to_system)
    NodeLink.create!(:from_star_system_id => self.id, :to_star_system_id => to_system.id) unless connected?(to_system)
  end
  
  def remove_node_link!(to_system)
    NodeLink.delete_all("(from_star_system_id = #{self.id} AND to_star_system_id = #{to_system.id}) OR (to_star_system_id = #{self.id} AND from_star_system_id = #{to_system.id})")
  end
  
  def distance(to_system)
    dx = self.x > to_system.x ? self.x - to_system.x : to_system.x - self.x
    dy = self.y > to_system.y ? self.y - to_system.y : to_system.y - self.y
    Math.sqrt((dx * dx) + (dy * dy)).to_i
  end
  
  def sector(ring, quadrant)
    CelestialBody.find(:all, :conditions => ['star_system_id = ? AND orbital_ring = ? AND orbital_quadrant = ?', self.id, ring, quadrant])
  end
  
  def create_gas_giant!(name, ring, quadrant)
    CelestialBody.create!(:name => name, :body_type => "gas_giant", :star_system_id => self.id, :orbital_ring => ring, :orbital_quadrant => quadrant, :gravity_rating => 10, :atmosphere_type => "toxic", :surface_type => "clouds")
  end
  
  def create_asteroid_belt!(ring, quadrant)
    CelestialBody.create!(:name => "Asteroid Belt", :body_type => "asteroid_belt", :star_system_id => self.id, :orbital_ring => ring, :orbital_quadrant => quadrant, :gravity_rating => 0.1, :atmosphere_type => "vacuum", :surface_type => "rocky")
  end

  def create_nebula!(ring, quadrant)
    CelestialBody.create!(:name => "Nebula", :body_type => "nebula", :star_system_id => self.id, :orbital_ring => ring, :orbital_quadrant => quadrant, :gravity_rating => 0, :atmosphere_type => "vacuum", :surface_type => "clouds")
  end

  def create_planet!(name, ring, quadrant, atmosphere = CelestialBody.random_atmosphere, surface = CelestialBody.random_surface, gravity_rating = rand * (rand(10) + 1))
    CelestialBody.create!(:name => name, :body_type => "planet", :star_system_id => self.id, :orbital_ring => ring, :orbital_quadrant => quadrant, :gravity_rating => gravity_rating, :atmosphere_type => atmosphere, :surface_type => surface)
  end
  
  def create_moon!(name, ring, quadrant, atmosphere = CelestialBody.random_atmosphere, surface = CelestialBody.random_surface, gravity_rating = rand * (rand(5) + 1))
    CelestialBody.create!(:name => name, :body_type => "moon", :star_system_id => self.id, :orbital_ring => ring, :orbital_quadrant => quadrant, :gravity_rating => gravity_rating, :atmosphere_type => atmosphere, :surface_type => surface)
  end
  
  def generate_map!
    body_count = 0
    (1..10).each do |ring|
      (1..4).each do |quadrant|
        if gas_giant?(ring)
          body_count += 1
          n = generate_body_name(body_count)
          create_gas_giant!(n, ring, quadrant)
          create_moons!(n, 20, ring, quadrant)
        elsif asteroid_belt?(ring)
          create_asteroid_belt!(ring, quadrant)
        elsif nebula?(ring)
          create_nebula!(ring, quadrant)
        elsif planet?(ring)
          body_count += 1
          n = generate_body_name(body_count)
          create_planet!(n, ring, quadrant)
          create_moons!(n, 4, ring, quadrant)
        end
      end
    end
  end
  
  def puts_map
    puts self.to_s
    (1..10).each do |ring|
      (1..4).each do |quadrant|
        sector(ring, quadrant).each do |body|
          puts body
        end
      end
    end
    nil
  end
  
  private
  def gas_giant?(ring)
    rand(100) > (ring < 6 ? 100 : 95)
  end
  def asteroid_belt?(ring)
    rand(100) > (ring < 3 ? 100 : 90)
  end
  def nebula?(ring)
    rand(100) > (ring > 8 ? 100 : 98)
  end
  def planet?(ring)
    rand(100) > 95 
  end
  def generate_body_name(n)
    "#{self.name} #{to_roman(n)}"
  end
  def to_roman(n)
    r = Roman.new
    r.to_roman(n).upcase
  end
  def create_moons!(parent_body_name, max, ring, quadrant)
    total = rand(max) - 1
    (1..total).each do |n|
      nm = "#{parent_body_name}#{(97+n).chr}"
      create_moon!(nm,ring,quadrant)
    end if total > 0
  end
  public
  def to_s
    "#{self.name}"
  end
end
