class CreateCelestialBodies < ActiveRecord::Migration
  def self.up
    create_table :celestial_bodies do |t|
      t.string :name
      t.string :body_type
      t.integer :star_system_id
      t.integer :orbital_ring
      t.integer :orbital_quadrant
      t.float :gravity_rating
      t.string :atmosphere_type
      t.string :surface_type
      t.float :colonist_growth_rate
      t.float :morale_modifier
      t.timestamps
    end
  end

  def self.down
    drop_table :celestial_bodies
  end
end
