class Attributes
  ARMOUR_FACTOR = "armour_factor"
  HULL_INTEGRITY = "hull_integrity"
  CREW_EFFICIENCY = "crew_efficiency"
  COMBAT_EFFICIENCY = "combat_efficiency"
  SENSOR_POWER = "sensor_power"
  SENSOR_PROFILE = "sensor_profile"
  CLOAKING = "cloaking"
  SQUADRON_LEADER = "squadron_leader"
  MINING = "mining"
  HARVESTING = "harvesting"
  BREEDING = 'breeding'
  FARMING = 'farming'
  BUTCHERING = 'butchering'
  BAKING = 'baking'
  TANNING = 'tanning'
  WEAVING = 'weaving'
  WINE_MAKING = 'wine_making'
  PRODUCTION = 'production'
  SHIP_BUILDING = 'ship_building'
  SHIP_REPAIR = 'ship_repair'
  EDUCATION = 'education'
  RESEARCH = 'research'
  KNOWLEDGE_BEARER = "knowledge_bearer"
  TRAINED = "trained"
  GOVERNOR = 'governor'
  UNIQUE_BUILDING = 'unique_building'
  UNIQUE_INDIVIDUAL = "unique_individual"
  SHIP_ACCURACY = "ship_accuracy"
  WEAPON_ACCURACY = "weapon_accuracy"
  MARINE_CAPACITY = "marine_capacity"
  LIFE_CAPACITY = "life_capacity"
  CARGO_CAPACITY = "cargo_capacity"
  ORE_CAPACITY = "ore_capacity"
  RESOURCE_CAPACITY = "resource_capacity"
  WEAPON_TYPE = "weapon_type"
  DAMAGE = "damage"
  POINT_DEFENSE_FACTORS = "point_defense_factors"
  ENERGY_ABSORPTION = "energy_absorption"
  ENERGY_CHARGE = "energy_charge"
  MAX_ENERGY = "max_energy"
  THRUST_SPEED = "thrust_speed"
  NODE_SPEED = "node_speed"
  WARP_SPEED = "warp_speed"
  COMMAND_SECTIONS = "command_sections"
  MISSION_SECTIONS = "missions_sections"
  ENGINE_SECTIONS = "engine_sections"
  ARMOUR_CAPACITY = "armour_capacity"
  WAGES = "wages"
  EMPLOYEE_FREEMEN = 'employee_freemen'
  EMPLOYEE_SLAVES = 'employee_slaves'
  EMPLOYEE_ENGINEERS = 'employee_engineers'
  EMPLOYEE_SOLDIERS = 'employee_soldier'
  EMPLOYEE_MARINES = 'employee_marines'
  EMPLOYEE_SAILORS = 'employee_sailors'
  EMPLOYEE_OFFICER = 'employee_officer'
  EMPLOYEE_PHILOSOPHER = 'employee_philosopher'
  EMPLOYEE_MASTER_ARTISAN = 'employee_master_artisan'
  BREEDS_ITEM = 'breeds_item'
  
  ALL = [ARMOUR_FACTOR, HULL_INTEGRITY, 
         CREW_EFFICIENCY, COMBAT_EFFICIENCY,
         SENSOR_POWER, SENSOR_PROFILE, 
         CLOAKING, SQUADRON_LEADER, GOVERNOR,
         MINING, HARVESTING, BREEDING, FARMING, BUTCHERING, BAKING, TANNING, WEAVING, WINE_MAKING,
         PRODUCTION, SHIP_BUILDING, SHIP_REPAIR,
         EDUCATION, RESEARCH, KNOWLEDGE_BEARER, TRAINED, UNIQUE_INDIVIDUAL, UNIQUE_BUILDING,
         SHIP_ACCURACY, SHIP_ACCURACY, 
         MARINE_CAPACITY, LIFE_CAPACITY, CARGO_CAPACITY, ORE_CAPACITY, RESOURCE_CAPACITY,
         WEAPON_TYPE, WEAPON_ACCURACY, DAMAGE, POINT_DEFENSE_FACTORS, ENERGY_ABSORPTION,
         ENERGY_CHARGE, MAX_ENERGY, THRUST_SPEED, NODE_SPEED, WARP_SPEED,
         COMMAND_SECTIONS, MISSION_SECTIONS, ENGINE_SECTIONS, ARMOUR_CAPACITY,
         WAGES, EMPLOYEE_FREEMEN, EMPLOYEE_SLAVES, EMPLOYEE_ENGINEERS, EMPLOYEE_SOLDIERS, EMPLOYEE_MARINES,
         EMPLOYEE_SAILORS, EMPLOYEE_OFFICER, EMPLOYEE_PHILOSOPHER, EMPLOYEE_MASTER_ARTISAN,
         BREEDS_ITEM
  ]
  
  WEAPON_TYPE_TORPEDO = 1
  WEAPON_TYPE_LASER = 2
  WEAPON_TYPE_DRONE = 3
  WEAPON_TYPE_MISSILE = 4
  WEAPON_TYPE_PARTICLE = 5
  WEAPON_TYPE_KINETIC = 6
  
  def self.weapon_type(value)
    return case value
    when WEAPON_TYPE_TORPEDO then 'Torpedo'
    when WEAPON_TYPE_LASER then 'Laser'
    when WEAPON_TYPE_DRONE then 'Drone'
    when WEAPON_TYPE_MISSILE then 'Missile'
    when WEAPON_TYPE_PARTICLE then 'Particle'
    when WEAPON_TYPE_KINETIC then 'Kinetic'
    end
  end
  
  KNOWLEDGE_BEARER_ALL = 1
  KNOWLEDGE_BEARER_AXIOM = 2
  KNOWLEDGE_BEARER_PRIORI = 3
  KNOWLEDGE_BEARER_TECHNOS = 4
  KNOWLEDGE_BEARER_SKILLS = 5
  
  def self.knowledge_bearer(value)
    return case value
    when KNOWLEDGE_BEARER_ALL then 'All'
    when KNOWLEDGE_BEARER_AXIOM then 'Axioms'
    when KNOWLEDGE_BEARER_PRIORI then 'Priori'
    when KNOWLEDGE_BEARER_TECHNOS then 'Technos'
    when KNOWLEDGE_BEARER_SKILLS then 'Skills'
    end
  end
  
  TRAINED_SAILOR = 1
  TRAINED_OFFICER = 2
  TRAINED_ENGINEER = 3
  TRAINED_SOLDIER = 4
  TRAINED_MARINE = 5
  TRAINED_MASTER_ARTISAN = 6
  TRAINED_PHILOSOPHER = 7
  
  def self.trained(value)
    return case value
    when TRAINED_SAILOR then 'Sailor'
    when TRAINED_OFFICER then 'Officer'
    when TRAINED_ENGINEER then 'Engineer'
    when TRAINED_SOLDIER then 'Soldier'
    when TRAINED_MARINE then 'Marine'
    when TRAINED_MASTER_ARTISAN then 'Master Artisan'
    when TRAINED_PHILOSOPHER then 'Philosopher'
    end
  end
  
  def self.calculate_ship_attribute(name, existing_value, section_value)
    return case name
    when ARMOUR_FACTOR then nil
    when WEAPON_ACCURACY then nil
    when WEAPON_TYPE then nil
    when DAMAGE then nil
    when KNOWLEDGE_BEARER then nil
    when TRAINED then nil
    when UNIQUE_INDIVIDUAL then nil
    when THRUST_SPEED then (existing_value < section_value ? section_value : existing_value)
    when NODE_SPEED then (existing_value < section_value ? section_value : existing_value)
    when WARP_SPEED then (existing_value < section_value ? section_value : existing_value)
    when CLOAKING then (existing_value < section_value ? existing_value : section_value)
    when SQUADRON_LEADER then (section_value > 0 ? section_value : existing_value)
    when MINING then (section_value > 0 ? section_value : existing_value)
    when HARVESTING then (section_value > 0 ? section_value : existing_value)
    else
      existing_value + section_value  
    end
  end
  
  EDUCATION_SLAVES = 1
  EDUCATION_SOLDIERS = 2
  EDUCATION_MARINES = 3
  EDUCATION_SAILORS = 4
  EDUCATION_ENGINEERS = 5
  EDUCATION_OFFICERS = 6
  EDUCATION_PHILOSOPHER = 7
  
  def self.educates(value)
    return case value
    when EDUCATION_SLAVES then 'Slaves'
    when EDUCATION_SOLDIERS then 'Soldiers'
    when EDUCATION_MARINES then 'Marines'
    when EDUCATION_SAILORS then 'Sailors'
    when EDUCATION_ENGINEERS then 'Engineers'
    when EDUCATION_OFFICERS then 'Officers'
    when EDUCATION_PHILOSOPHER then 'Philosophers'
    end
  end
  
  OFFICERS_PER_COMMAND_SECTION = 2
  ENGINEERS_PER_COMMAND_SECTION = 4
  SAILORS_PER_MISSION_SECTION = 10
end