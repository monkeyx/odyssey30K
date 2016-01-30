class CreateStarSystems < ActiveRecord::Migration
  def self.up
    create_table :star_systems do |t|
      t.string :name
      t.integer :x
      t.integer :y
      t.string :star_type
      t.string :sec_zone
      t.integer :cluster_id

      t.timestamps
    end
    create_table :node_links do |t|
      t.integer :from_star_system_id
      t.integer :to_star_system_id

      t.timestamps
    end
  end

  def self.down
    drop_table :star_systems
    drop_table :node_links
  end
end
