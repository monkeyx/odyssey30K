puts "===================="
puts "===================="
puts "==== KNOWLEDGE ====="
puts "===================="

User.transaction do

puts "===== Atomics ======"
atomics = Knowledge.create_axiom!('Atomics')
  plastics = Knowledge.create_priori!('Plastics', atomics)
  nanoscience = Knowledge.create_axiom!('Nano Science', atomics)
    nanites = Knowledge.create_priori!('Nanites', nanoscience)
    lattice_integration = Knowledge.create_axiom!('Lattice Integration', nanoscience)
      crystalysis = Knowledge.create_priori!('Crystalysis', lattice_integration) 
        jump_drives = Knowledge.create_priori!('Jump Drives', crystalysis)

puts "===== Energy ======"
energy = Knowledge.create_axiom!('Energy')
  ballistics = Knowledge.create_priori!('Ballistics', energy)
  sensors = Knowledge.create_priori!('Sensors', energy)
  fusion = Knowledge.create_priori!('Fusion', energy)
    neutronics = Knowledge.create_priori!('Neutronics', fusion)
    reaction_drives = Knowledge.create_priori!('Reaction Drives', fusion)
      drones = Knowledge.create_priori!('Drones', reaction_drives)
        interceptors = Knowledge.create_priori!('Interceptors', drones)
  photonics = Knowledge.create_priori!('Photonics', energy)
    disruptors = Knowledge.create_priori!('Disruptors', photonics)
  unified_theory = Knowledge.create_axiom!('Unified Theory', energy)
    gravitonics = Knowledge.create_priori!('Gravitonics', unified_theory)
    phasing = Knowledge.create_priori!('Phasing', unified_theory)
      stealth = Knowledge.create_priori!('Stealth', phasing)
        stealth_bombers = Knowledge.create_priori!('Stealth Bombers', stealth)
    antimatter = Knowledge.create_priori!('Antimatter', unified_theory)
      protonics = Knowledge.create_priori!('Protonics', antimatter)
      inertial_drives = Knowledge.create_priori!('Inertial Drives', antimatter)
    degeneration_theory = Knowledge.create_axiom!('Degeneration Theory', unified_theory)
      positronics = Knowledge.create_priori!('Positronics', degeneration_theory)
      warp_theory = Knowledge.create_axiom!('Warp Theory', degeneration_theory)
        warp_drives = Knowledge.create_priori!('Warp Drives', warp_theory)
        warp_power = Knowledge.create_priori!('Warp Power', warp_theory)

puts "===== Engineering ======"
engineering = Knowledge.create_axiom!('Zero G Engineering')
  structural_engineering = Knowledge.create_priori!('Structural Engineering', engineering)
    heavy_engineering = Knowledge.create_priori!('Heavy Engineering', structural_engineering) 
  light_shipbuilding = Knowledge.create_axiom!('Light Ship Building', engineering)
    small_human_freighters = Knowledge.create_priori!('Small Human Freighters', light_shipbuilding)
      medium_human_freighters = Knowledge.create_priori!('Medium Human Freighters', small_human_freighters)
        large_human_freighters = Knowledge.create_priori!('Large Human Freighters', medium_human_freighters)
    heavy_shipbuilding = Knowledge.create_axiom!('Heavy Ship Building', light_shipbuilding)
      small_human_warships = Knowledge.create_priori!('Small Human Warships', heavy_shipbuilding)
        medium_human_warships = Knowledge.create_priori!('Medium Human Warships', small_human_warships)
          large_human_warships = Knowledge.create_priori!('Large Human Warships', medium_human_warships)
            human_cruisers = Knowledge.create_priori!('Human Cruisers', large_human_warships)
              human_battleships = Knowledge.create_priori!('Human Battleships', human_cruisers)

puts "===== Genetics ======"
genetics = Knowledge.create_axiom!('Genetics')
  agriculture = Knowledge.create_priori!('Agriculture', genetics)
  artificial_life = Knowledge.create_axiom!('Artificial Life', genetics)
    cryogenics = Knowledge.create_priori!('Cryogenics', artificial_life)
    xenobiology = Knowledge.create_axiom!('Xenobiology', artificial_life)
      hassari_science = Knowledge.create_axiom!('Hassari Science', xenobiology)
        hassari_technology = Knowledge.create_priori!('Hassari Technology', hassari_science)
      vrok_science = Knowledge.create_axiom!("V'rok Science", xenobiology)
        vrok_technology = Knowledge.create_priori!("V'rok Technology", vrok_science)

puts "===== Cybernetics ======"
cybernetics = Knowledge.create_axiom!('Cybernetics')
  robotics = Knowledge.create_priori!('Robotics', cybernetics)
  cybernetic_systems = Knowledge.create_priori!('Cybernetic Systems', cybernetics)
  neural_networks = Knowledge.create_axiom!('Neural Networks', cybernetics)
    artificial_intelligence = Knowledge.create_axiom!('Artificial Intelligence', neural_networks)
      ai_systems = Knowledge.create_priori!('AI Systems', artificial_intelligence)
      ai_administration = Knowledge.create_priori!('AI Administration', artificial_intelligence)

puts "===== Tactics ======"
tactics = Knowledge.create_axiom!('Tactics')
  electronic_warfare = Knowledge.create_priori!('Electronic Warfare', tactics)
  stratagem = Knowledge.create_axiom!('Stratagem', tactics)
    space_warfare = Knowledge.create_priori!('Space Warfare', stratagem)
    logistics = Knowledge.create_axiom!('Logistica', stratagem)

puts "==== Skills ====="
leadership = Knowledge.create_skill!("Leadership", Attributes::CREW_EFFICIENCY, 50)
combat_training = Knowledge.create_skill!("Combat Training", Attributes::COMBAT_EFFICIENCY, 25)
accuracy = Knowledge.create_skill!("Accuracy", Attributes::SHIP_ACCURACY, 10)
science = Knowledge.create_skill!("Science", Attributes::SENSOR_POWER, 25)
counter_intelligence = Knowledge.create_skill!("Counter Intelligence", Attributes::SENSOR_PROFILE, -25)
gunnery = Knowledge.create_skill!("Gunnery", Attributes::POINT_DEFENSE_FACTORS, 100)
shield_engineering = Knowledge.create_skill!("Shield Engineering", Attributes::ENERGY_ABSORPTION, 100)
power_engineering = Knowledge.create_skill!("Power Engineering", Attributes::ENERGY_CHARGE, 10)

puts "===================="
puts "====== ITEMS ======="
puts "===================="

puts "===== Ores ======"
metals = Item.create_ore!('Metals')
minerals = Item.create_ore!('Minerals')
hydrocarbons = Item.create_ore!('Hydrocarbons')
crystals = Item.create_ore!('Crystals')

puts "===== Lifeforms ======"
livestock = Item.create_lifeform!('Livestock')
livestock.breeds_item = livestock
plantlife = Item.create_lifeform!('Plantlife')
plantlife.breeds_item = plantlife
slaves = Item.create_lifeform!('Slave', 1)
slaves.breeds_item = slaves
freemen = Item.create_lifeform!('Freeman',5)
freemen.breeds_item = freemen
sailor = Item.create_lifeform!('Sailor', 10, Attributes::TRAINED_SAILOR)
sailor.breeds_item = freemen
marine = Item.create_lifeform!('Marine', 10, Attributes::TRAINED_MARINE)
marine.breeds_item = freemen
engineer = Item.create_lifeform!('Engineer', 10, Attributes::TRAINED_ENGINEER)
engineer.breeds_item = freemen
soldier = Item.create_lifeform!('Soldier', 10, Attributes::TRAINED_SOLDIER)
soldier.breeds_item = freemen
officer = Item.create_lifeform!('Officer', 20, Attributes::TRAINED_OFFICER, Attributes::KNOWLEDGE_BEARER_SKILLS)
officer.breeds_item = freemen
master_artisan = Item.create_lifeform!('Master Artisan', 100, Attributes::TRAINED_MASTER_ARTISAN, Attributes::KNOWLEDGE_BEARER_TECHNOS)
master_artisan.breeds_item = freemen
master_artisan.citizen_only!
philosopher = Item.create_lifeform!('Philosopher', 50, Attributes::TRAINED_PHILOSOPHER, Attributes::KNOWLEDGE_BEARER_ALL)
philosopher.breeds_item = freemen
philosopher.senator_only!

puts "===== Resources ======"
clothing = Item.create_resource!('Clothing')
food = Item.create_resource!('Food')
wine = Item.create_resource!('Wine')
luxuries = Item.create_resource!('Luxuries')

puts "===== Modules ======"
civilian_module = Item.create_module!('Civilian Module', {metals => 10, minerals => 40})
industrial_module = Item.create_module!('Industrial Module', {metals => 20, minerals => 20, hydrocarbons => 10})
transportation_module = Item.create_module!('Transportation Module', {metals => 15, minerals => 15, hydrocarbons => 20})
security_module = Item.create_module!('Security Module', {metals => 15, minerals => 25, hydrocarbons => 10})

puts "===== Hulls ======"
standard_hull = Item.create_hull!('Standard Hull', 1000)
reinforced_hull = Item.create_hull!('Reinforced Hull', 2000, structural_engineering)
heavy_hull = Item.create_hull!('Heavy Hull', 4000, heavy_engineering)

puts "===== Bridges ======"
standard_bridge = Item.create_bridge!('Standard Bridge',100, 50, 25, 100)
battle_bridge = Item.create_bridge!('Battle Bridge',100, 100, 40, 200,space_warfare)
aux_bridge = Item.create_bridge!('Aux Bridge',50, 25, 10, 125, cybernetics)
ai_bridge = Item.create_bridge!('AI Bridge',150, 125, 60, 150, ai_systems)

puts "===== Sensors ======"
scanner = Item.create_sensor!('Scanner',25, sensors)
jammer = Item.create_stealth!('Jammer',-25, electronic_warfare)
cloaking_device = Item.create_cloak!('Cloaking Device', 50, stealth)

puts "===== Tactical ======"
tactical_targetting_system = Item.create_targetting!('Tactical Targetting System', 15, cybernetics)
ai_targetting_system = Item.create_targetting!('AI Targetting System', 15, ai_systems)
squadron_command = Item.create_squadron_command!('Squadron Command', 250, space_warfare)

puts "===== Cargo ======"
quarters = Item.create_life_capacity!('Quarters', 350)
cargo_deck = Item.create_cargo_capacity!('Cargo Deck', 1000)
ore_deck = Item.create_ore_capacity!('Ore Deck', 5000)
cryo_pods = Item.create_life_capacity!('Cryo Pods', 750, 150, cryogenics)

puts "===== Special ======"
mining_section = Item.create_mining_section!('Mining', 2000, robotics)
harvester_section = Item.create_resource_section!('Harvester', 1000, robotics)

puts "===== Weapons ======"
assault_pod = Item.create_marine_capacity!('Assault Pods',350, space_warfare)

photon_torp = Item.create_weapon!('Photon Torpedo', Attributes::WEAPON_TYPE_TORPEDO, 150, 0, photonics)
disruptor_torp = Item.create_weapon!('Disruptor Torpedo', Attributes::WEAPON_TYPE_TORPEDO, 250, 0, disruptors)
antimatter_torp = Item.create_weapon!('Antimatter Torpedo', Attributes::WEAPON_TYPE_TORPEDO, 500, 0, protonics)

pulsar = Item.create_weapon!('Pulsar', Attributes::WEAPON_TYPE_LASER, 25, 0, photonics)
phaser = Item.create_weapon!('Phaser', Attributes::WEAPON_TYPE_LASER, 50, 10, phasing)
gravity_cannon = Item.create_weapon!('Gravity Cannon', Attributes::WEAPON_TYPE_LASER, 100, 20, gravitonics)

fighter_drones = Item.create_drone!('Fighter Drones', 20, 50, drones)
interceptor_drones = Item.create_drone!('Interceptor Drones', 10, 100, interceptors)
bomber_drones = Item.create_drone!('Bomber Drones', 200, 0, stealth_bombers)

nuclear_missile = Item.create_weapon!('Nuclear Missile', Attributes::WEAPON_TYPE_MISSILE, 75)
nanite_missile = Item.create_weapon!('Nanite Missile', Attributes::WEAPON_TYPE_MISSILE, 75, 15, nanites)
nuetron_missile = Item.create_weapon!('Neutron Missile', Attributes::WEAPON_TYPE_MISSILE, 100, 0, neutronics)
proton_missile = Item.create_weapon!('Antimatter Missile', Attributes::WEAPON_TYPE_MISSILE, 150, 0, protonics)

particle_beam = Item.create_weapon!('Particle Beam', Attributes::WEAPON_TYPE_PARTICLE, 75)
neutron_beam = Item.create_weapon!('Neutron Beam', Attributes::WEAPON_TYPE_PARTICLE, 100, 10, neutronics)
positron_beam = Item.create_weapon!('Positron Beam', Attributes::WEAPON_TYPE_PARTICLE, 150, 20, positronics)

mass_driver = Item.create_weapon!('Mass Driver', Attributes::WEAPON_TYPE_KINETIC, 300, 0, ballistics)
rail_mortar = Item.create_weapon!('Rail Mortar', Attributes::WEAPON_TYPE_KINETIC, 600, 0, neutronics)
siege_driver = Item.create_weapon!('Siege Driver', Attributes::WEAPON_TYPE_KINETIC, 1000, 0, gravitonics)

puts "===== Shields ======"
disruptor_shields = Item.create_shield!('Disruptor Shields',150, disruptors)
positron_shields = Item.create_shield!('Positron Shields',200, positronics)
phase_shields = Item.create_shield!('Phase Shields',300, phasing)

puts "===== Point Defneses ======"
gatlin_lasers = Item.create_point_defense!('Gatlin Lasers',50, photonics)
interceptor_missiles = Item.create_point_defense!('Interceptor Missiles',100,neutronics)
phalanx_missiles = Item.create_point_defense!('Phalanx Missiles',200,protonics)

puts "===== Engines ======"
solar_sail = Item.create_engine!('Solar Sail',10, 30)

puts "===== Power Plants ======"
fusion_power = Item.create_power_plant!('Fusion Power Plant',25, fusion)
antimatter_power = Item.create_power_plant!('Antimatter Power Plant',50, antimatter)
crystal_matrix = Item.create_power_plant!('Crystal Matrix',75, crystalysis)
warp_core = Item.create_power_plant!('Warp Core',100, warp_power)

puts "===== Thrust Engines ======"
thrusters = Item.create_thrust_engine!('Thrusters', 30)
boosters = Item.create_thrust_engine!('Boosters', 60, reaction_drives)
impulse_drive = Item.create_thrust_engine!('Impulse Drive', 100, inertial_drives)

puts "===== FTL Drives ======"
node_drive = Item.create_node_drive!('Node Drive', 50, inertial_drives)
jump_drive = Item.create_node_drive!('Jump Drive', 25, jump_drives)
warp_drive = Item.create_warp_drive!('Warp Drive', 50, warp_drives)

puts "===== Armour ======"
light_alloy_armour = Item.create_armour!('Light Alloy Armour', 250, 10, 5, 200)
heavy_metal_armour = Item.create_armour!('Heavy Metal Armour', 500, 15, 10, 400)
reinforced_plastic_armour = Item.create_armour!('Reinforced Plastic Armour', 250, 20, 2, 150, plastics)
crystal_mesh_armour = Item.create_armour!('Crystal Mesh Armour', 300, 30, 4, 300, crystalysis)
stealth_armour = Item.create_armour!('Stealth Armour', 100, 0, -10, 5, stealth)

puts "===== Chassis ======"
galley = Item.create_chassis!("Galley", standard_hull, small_human_freighters, 1, 2, 1)
barge = Item.create_chassis!("Barge", standard_hull, medium_human_freighters, 1, 4, 2)
galleas = Item.create_chassis!("Galleas", standard_hull, medium_human_freighters, 2, 6, 2, 10)
argosy = Item.create_chassis!("Argosy", reinforced_hull, large_human_freighters, 2, 9, 3, 14)
hulk = Item.create_chassis!("Hulk", reinforced_hull, large_human_freighters, 1, 15, 2)

bireme = Item.create_chassis!("Bireme", reinforced_hull, small_human_warships, 2, 2, 2, 6)
trireme = Item.create_chassis!("Trireme", reinforced_hull, medium_human_warships, 3, 4, 3, 10)
quadrireme = Item.create_chassis!("Quadrireme", reinforced_hull, large_human_warships, 4, 6, 4, 14)
dromon = Item.create_chassis!("Dromon", reinforced_hull, human_cruisers, 4, 10, 4, 18)
liburnian = Item.create_chassis!("Liburnian", heavy_hull, human_cruisers, 4, 10, 4, 18)
seattia = Item.create_chassis!("Seattia", heavy_hull, human_battleships, 6, 18, 4, 28)
penteconter = Item.create_chassis!("Penteconter", heavy_hull, human_battleships, 5, 25, 5, 35)

xebec = Item.create_chassis!("Xebec", reinforced_hull, hassari_technology, 2, 6, 3, 12)
dhow = Item.create_chassis!("Dhow", reinforced_hull, hassari_technology, 2, 10, 3, 15)

drakkar = Item.create_chassis!("Drakkar", heavy_hull, vrok_technology, 3, 9, 3, 15)
knor = Item.create_chassis!("Knor", heavy_hull, vrok_technology, 3, 15, 4, 22)

puts "===== Buildings ======"
admin_center = Item.create_building!('Administration Center', 10, 0, 0, 10, nil, true)
admin_center.set_item_attribute_value!(Attributes::UNIQUE_BUILDING,1)
admin_center.set_item_attribute_value!(Attributes::GOVERNOR,1)
admin_center.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
admin_center.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,100)
admin_center.set_item_attribute_value!(Attributes::CARGO_CAPACITY,10000)

warehouse = Item.create_building!('Warehouse', 5, 5, 5, 5)
warehouse.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,150)
warehouse.set_item_attribute_value!(Attributes::CARGO_CAPACITY,100000)

mine = Item.create_building!('Mine', 0, 15, 5, 0)
mine.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,150)
mine.set_item_attribute_value!(Attributes::MINING,1)
mine.set_item_attribute_value!(Attributes::ORE_CAPACITY,25000)

harvester = Item.create_building!('Harvester', 15, 0, 5, 0)
harvester.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,150)
harvester.set_item_attribute_value!(Attributes::HARVESTING,1)
harvester.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY,5000)

ranch = Item.create_building!('Ranch', 10, 0, 5, 5)
ranch.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,150)
ranch.set_item_attribute_value!(Attributes::BREEDING,1)
ranch.set_item_attribute_value!(Attributes::LIFE_CAPACITY,5000)

farm = Item.create_building!('Farm', 10, 5, 0, 5)
farm.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,150)
farm.set_item_attribute_value!(Attributes::FARMING,1)
farm.set_item_attribute_value!(Attributes::LIFE_CAPACITY,5000)

slaughterhouse = Item.create_building!('Slaughterhouse', 15, 5, 0, 0)
slaughterhouse.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,100)
slaughterhouse.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
slaughterhouse.set_item_attribute_value!(Attributes::BUTCHERING,5)
slaughterhouse.set_item_attribute_value!(Attributes::LIFE_CAPACITY,200)
slaughterhouse.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY,5000)

bakery = Item.create_building!('Bakery', 15, 5, 0, 0)
bakery.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,100)
bakery.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
bakery.set_item_attribute_value!(Attributes::BAKING,5)
bakery.set_item_attribute_value!(Attributes::LIFE_CAPACITY,200)
bakery.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY,5000)

tannery = Item.create_building!('Tannery', 15, 5, 0, 0)
tannery.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,100)
tannery.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
tannery.set_item_attribute_value!(Attributes::TANNING,2)
tannery.set_item_attribute_value!(Attributes::LIFE_CAPACITY,200)
tannery.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY,5000)

weavers = Item.create_building!('Weavers', 15, 5, 0, 0)
weavers.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,100)
weavers.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
weavers.set_item_attribute_value!(Attributes::WEAVING,2)
weavers.set_item_attribute_value!(Attributes::LIFE_CAPACITY,200)
weavers.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY,5000)

vineyard = Item.create_building!('Vineyard', 15, 5, 0, 0)
vineyard.set_item_attribute_value!(Attributes::EMPLOYEE_SLAVES,100)
vineyard.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
vineyard.set_item_attribute_value!(Attributes::WINE_MAKING,5)
vineyard.set_item_attribute_value!(Attributes::LIFE_CAPACITY,200)
vineyard.set_item_attribute_value!(Attributes::RESOURCE_CAPACITY,5000)

workshop = Item.create_building!('Workshop', 5, 15, 0, 0)
workshop.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,100)
workshop.set_item_attribute_value!(Attributes::EMPLOYEE_MASTER_ARTISAN,1)
workshop.set_item_attribute_value!(Attributes::PRODUCTION,100)
workshop.set_item_attribute_value!(Attributes::ORE_CAPACITY,25000)
workshop.set_item_attribute_value!(Attributes::CARGO_CAPACITY,5000)

shipyard = Item.create_building!('Shipyard', 0, 100, 50, 50)
shipyard.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,450)
shipyard.set_item_attribute_value!(Attributes::EMPLOYEE_ENGINEERS,50)
shipyard.set_item_attribute_value!(Attributes::EMPLOYEE_MASTER_ARTISAN,1)
shipyard.set_item_attribute_value!(Attributes::SHIP_BUILDING,1)
shipyard.set_item_attribute_value!(Attributes::CARGO_CAPACITY,250000)

rigger = Item.create_building!('Rigger', 0, 100, 25, 25)
rigger.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,250)
rigger.set_item_attribute_value!(Attributes::EMPLOYEE_ENGINEERS,50)
rigger.set_item_attribute_value!(Attributes::EMPLOYEE_MASTER_ARTISAN,1)
rigger.set_item_attribute_value!(Attributes::SHIP_REPAIR,1)

school = Item.create_building!('School', 100, 0, 0, 0)
school.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,100)
school.set_item_attribute_value!(Attributes::EMPLOYEE_PHILOSOPHER,1)
school.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_SLAVES)
school.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)

boot_camp = Item.create_building!('Boot Camp', 50, 0, 0, 50)
boot_camp.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
boot_camp.set_item_attribute_value!(Attributes::EMPLOYEE_SOLDIERS,50)
boot_camp.set_item_attribute_value!(Attributes::EMPLOYEE_OFFICER,1)
boot_camp.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_SOLDIERS)
boot_camp.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)

training_camp = Item.create_building!('Training Camp', 50, 0, 0, 50)
training_camp.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
training_camp.set_item_attribute_value!(Attributes::EMPLOYEE_MARINES,50)
training_camp.set_item_attribute_value!(Attributes::EMPLOYEE_OFFICER,1)
training_camp.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_MARINES)
training_camp.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)

naval_camp = Item.create_building!('Naval Camp', 50, 0, 25, 25)
naval_camp.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
naval_camp.set_item_attribute_value!(Attributes::EMPLOYEE_SAILORS,50)
naval_camp.set_item_attribute_value!(Attributes::EMPLOYEE_OFFICER,1)
naval_camp.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_SAILORS)
naval_camp.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)

technical_college = Item.create_building!('Technological College', 75, 25, 0, 0)
technical_college.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,50)
technical_college.set_item_attribute_value!(Attributes::EMPLOYEE_ENGINEERS,50)
technical_college.set_item_attribute_value!(Attributes::EMPLOYEE_PHILOSOPHER,1)
technical_college.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_ENGINEERS)
technical_college.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)

academy = Item.create_building!('Academy', 90, 0, 0, 10, nil, true)
academy.set_item_attribute_value!(Attributes::UNIQUE_BUILDING,1)
academy.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,250)
academy.set_item_attribute_value!(Attributes::EMPLOYEE_OFFICER,5)
academy.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_OFFICERS)
academy.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)
academy.set_item_attribute_value!(Attributes::RESEARCH,1)
academy.set_item_attribute_value!(Attributes::KNOWLEDGE_BEARER,Attributes::KNOWLEDGE_BEARER_SKILLS)

university = Item.create_building!('University', 175, 50, 25, 50, nil, true)
university.set_item_attribute_value!(Attributes::UNIQUE_BUILDING,1)
university.set_item_attribute_value!(Attributes::EMPLOYEE_FREEMEN,500)
university.set_item_attribute_value!(Attributes::EMPLOYEE_PHILOSOPHER,5)
university.set_item_attribute_value!(Attributes::EDUCATION,Attributes::EDUCATION_PHILOSOPHER)
university.set_item_attribute_value!(Attributes::LIFE_CAPACITY,1000)
university.set_item_attribute_value!(Attributes::RESEARCH,1)
university.set_item_attribute_value!(Attributes::KNOWLEDGE_BEARER,Attributes::KNOWLEDGE_BEARER_ALL)

puts "===================="
puts "==== GAME MAP ======"
puts "===================="

puts "===== Aegean Cluster ======"
Aegean_Cluster = Cluster.create(:name => 'Aegean Cluster')

Macedonia = Aegean_Cluster.systems.create!(:name => 'Macedonia', :x => -25, :y => 40, :sec_zone => "alpha", :star_type => StarSystem.random_star_type)
Thessaly = Aegean_Cluster.systems.create!(:name => 'Thessaly', :x => -30, :y => 25, :sec_zone => "alpha", :star_type => StarSystem.random_star_type)
Thessaly.add_node_link!(Macedonia)
Phthiotis = Aegean_Cluster.systems.create!(:name => 'Phthiotis', :x => -28, :y => 20, :sec_zone => "beta", :star_type => StarSystem.random_star_type)
Phthiotis.add_node_link!(Thessaly)
Locris = Aegean_Cluster.systems.create!(:name => 'Locris', :x => -25, :y => 18, :sec_zone => "beta", :star_type => StarSystem.random_star_type)
Locris.add_node_link!(Phthiotis)
Boeotia = Aegean_Cluster.systems.create!(:name => 'Boeotia', :x => -20, :y => 15, :sec_zone => "beta", :star_type => StarSystem.random_star_type)
Boeotia.add_node_link!(Locris)
Peloponnese = Aegean_Cluster.systems.create!(:name => 'Peloponnese', :x => -30, :y => 0, :sec_zone => "alpha", :star_type => StarSystem.random_star_type)
Peloponnese.add_node_link!(Boeotia)
Thrace = Aegean_Cluster.systems.create!(:name => 'Thrace', :x => 10, :y => 40, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Thrace.add_node_link!(Macedonia)
Mysia = Aegean_Cluster.systems.create!(:name => 'Mysia', :x => 17, :y => 24, :sec_zone => "delta", :star_type => StarSystem.random_star_type)
Mysia.add_node_link!(Thrace)
Lydia = Aegean_Cluster.systems.create!(:name => 'Lydia', :x => 20, :y => 18, :sec_zone => "delta", :star_type => StarSystem.random_star_type)
Lydia.add_node_link!(Mysia)
Ionia = Aegean_Cluster.systems.create!(:name => 'Ionia', :x => 20, :y => 12, :sec_zone => "delta", :star_type => StarSystem.random_star_type)
Ionia.add_node_link!(Lydia)
Caria = Aegean_Cluster.systems.create!(:name => 'Caria', :x => 25, :y => 5, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Caria.add_node_link!(Ionia)
Andros = Aegean_Cluster.systems.create!(:name => 'Andros', :x => -5, :y => 8, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Andros.add_node_link!(Boeotia)
Cea = Aegean_Cluster.systems.create!(:name => 'Cea', :x => -11, :y => 7, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Cea.add_node_link!(Andros)
Cea.add_node_link!(Boeotia)
Mykonos = Aegean_Cluster.systems.create!(:name => 'Mykonos', :x => -1, :y => 5, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Mykonos.add_node_link!(Andros)
Seriphos = Aegean_Cluster.systems.create!(:name => 'Seriphos', :x => -10, :y => 0, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Seriphos.add_node_link!(Mykonos)
Seriphos.add_node_link!(Cea)
Paros = Aegean_Cluster.systems.create!(:name => 'Paros', :x => -2, :y => 0, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Paros.add_node_link!(Seriphos)
Paros.add_node_link!(Mykonos)
Naxos = Aegean_Cluster.systems.create!(:name => 'Naxos', :x => 0, :y => 0, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Naxos.add_node_link!(Paros)
Naxos.add_node_link!(Mykonos)
Icaria = Aegean_Cluster.systems.create!(:name => 'Icaria', :x => 5, :y => 6, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Icaria.add_node_link!(Mykonos)
Samos = Aegean_Cluster.systems.create!(:name => 'Samos', :x => 14, :y => 8, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Samos.add_node_link!(Icaria)
Samos.add_node_link!(Ionia)
Callist = Aegean_Cluster.systems.create!(:name => 'Callist', :x => -1, :y => -8, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Callist.add_node_link!(Paros)
Anaphe = Aegean_Cluster.systems.create!(:name => 'Anaphe', :x => 3, :y => 8, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Anaphe.add_node_link!(Callist)
Anaphe.add_node_link!(Naxos)
Cos = Aegean_Cluster.systems.create!(:name => 'Cos', :x => 18, :y => -3, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Cos.add_node_link!(Icaria)
Cos.add_node_link!(Naxos)
Cos.add_node_link!(Caria)
Rhodes = Aegean_Cluster.systems.create!(:name => 'Rhodes', :x => 25, :y => -10, :sec_zone => "beta", :star_type => StarSystem.random_star_type)
Rhodes.add_node_link!(Caria)
Rhodes.add_node_link!(Caria)

puts "===== Ionian Cluster ======"
Ionian_Cluster = Cluster.create(:name => 'Ionian Cluster', :restricted => true)

Illyria = Ionian_Cluster.systems.create!(:name => 'Illyria', :x => -55, :y => 42, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Illyria.add_node_link!(Macedonia)
Epirus = Ionian_Cluster.systems.create!(:name => 'Epirus', :x => -50, :y => 32, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Epirus.add_node_link!(Illyria)
Epirus.add_node_link!(Macedonia)
Epirus.add_node_link!(Thessaly)
Acarnania = Ionian_Cluster.systems.create!(:name => 'Acarnania', :x => -45, :y => 20, :sec_zone => "gamma", :star_type => StarSystem.random_star_type)
Acarnania.add_node_link!(Illyria)
Aetolia = Ionian_Cluster.systems.create!(:name => 'Aetolia', :x => -40, :y => 17, :sec_zone => "beta", :star_type => StarSystem.random_star_type)
Aetolia.add_node_link!(Acarnania)
Aetolia.add_node_link!(Locris)
Aetolia.add_node_link!(Peloponnese)

puts "===== Cretan Cluster ======"
Cretan_Cluster = Cluster.create(:name => 'Cretan Cluster', :restricted => true)

Crete  = Cretan_Cluster.systems.create!(:name => 'Crete', :x => -5, :y => -20, :sec_zone => "beta", :star_type => StarSystem.random_star_type)
Crete.add_node_link!(Callist)
Crete.add_node_link!(Anaphe)
Carpathus = Cretan_Cluster.systems.create!(:name => 'Carpathus', :x => 18, :y => -15, :sec_zone => "delta", :star_type => StarSystem.random_star_type)
Carpathus.add_node_link!(Crete)
Carpathus.add_node_link!(Rhodes)

StarSystem.find(:all).each {|ss| ss.generate_map!}

CelestialBody.find(:all).each {|cb| cb.generate_deposits! }

puts "===================="
puts "==== GM / NPC ======"
puts "===================="

GM = User.create!(:login => 'Zeus', 
                  :password => 'password', 
                  :password_confirmation => 'password',
                  :name => 'Gamesmaster', 
                  :email => 'zeus@odyssey-30k.com')
GM.activate!(false)
GM.roles << Role.zeus
GM.drachma = 1000000000
GM.save
puts "===== Alpha Zone Terraforming ======"
CelestialBody.security_alpha.terraformable.each do |body|
  puts body.terraform! if rand(10) < 6
end

puts "===== Beta Zone Terraforming ======"
CelestialBody.security_beta.terraformable.each do |body|
  puts body.terraform! if rand(10) < 6
end

alpha_buy_items = [metals, minerals, hydrocarbons, crystals, livestock, plantlife, food, wine, luxuries]
alpha_sell_items = [metals, minerals, hydrocarbons, crystals, livestock, plantlife, freemen, slaves, sailor, marine, engineer, soldier, food, wine, luxuries, civilian_module, industrial_module, transportation_module, security_module, standard_hull, standard_bridge, quarters, cargo_deck, ore_deck, nuclear_missile, particle_beam, solar_sail, thrusters, light_alloy_armour, heavy_metal_armour, fusion_power, node_drive, barge, galleas, bireme, trireme]
beta_buy_items = [metals, minerals, hydrocarbons, crystals, livestock, plantlife, freemen, slaves, sailor, marine, engineer, soldier, food, wine, luxuries, civilian_module, industrial_module, transportation_module, security_module]
beta_sell_items = [metals, minerals, hydrocarbons, crystals, livestock, plantlife, food, wine, luxuries]

puts "===== Alpha Zone Colonies ======"
CelestialBody.security_alpha.habitable.breathable.each do |body|
  puts c = Colony.seed_colony!(GM, body, 6 + rand(5), "closed")
  c.seed_market!(alpha_buy_items,alpha_sell_items)
end

puts "===== Beta Zone Colonies ======"
CelestialBody.security_beta.habitable.breathable.each do |body|
  puts c = Colony.seed_colony!(GM, body, rand(3) + 1, "open")
  c.seed_market!(beta_buy_items,beta_sell_items)
end

puts "===== NPC Knowledge ======"
NPC_COMMON_PHILOSOPHER_KNOWLEDGE = [atomics, energy, engineering, genetics, cybernetics, tactics]
NPC_RARE_PHILOSOPHER_KNOWLEDGE = [plastics, nanoscience, ballistics, sensors, fusion, photonics, unified_theory, structural_engineering, light_shipbuilding, agriculture, artificial_life, robotics, cybernetic_systems, neural_networks, electronic_warfare, stratagem]
Colonist.unique.each do |npc|
  if npc.philosopher?
    NPC_COMMON_PHILOSOPHER_KNOWLEDGE.each {|k| npc.add_knowledge!(k)}
    npc.add_knowledge!(NPC_RARE_PHILOSOPHER_KNOWLEDGE.sort_by{rand}.first)
  elsif npc.officer?
    (0..rand(5)).each { npc.add_knowledge!(Knowledge.skills.sort_by{rand}.first)}
  end
end
puts "===== Seed Maintenance ======"

(1..2).each do |week|
  puts "Week #{week}"
  Colony.maintain_all!(Colony.all)
  puts "\n"
end

end # User.transaction