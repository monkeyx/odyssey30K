class CreateStarships < ActiveRecord::Migration
  def self.up
    create_table :starships do |t|
      t.string :name
      t.integer :captain_id
      t.integer :squadron_id
      t.integer :celestial_body_id
      t.integer :colony_id
      t.integer :chassis_id
      t.float   :crew_efficiency
      t.float   :combat_efficiency
      t.float   :current_integrity
      t.float   :current_energy
      t.timestamps
    end
    create_table :starship_attributes do |t|
      t.integer :starship_id
      t.string :name
      t.float :value
    end
    create_table :starship_sections do |t|
      t.integer :starship_id
      t.integer :section_id
    end
    create_table :starship_cargos do |t|
      t.integer :starship_id
      t.integer :item_id
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :starships
    drop_table :starship_attributes
    drop_table :starship_section
    drop_table :starship_cargo
  end
end
