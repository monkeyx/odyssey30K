class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.integer :colony_id
      t.integer :building_type_id
      t.integer :owner_id
      t.integer :level
      t.float   :efficiency
      t.integer :bonus_wages
      t.boolean :automated
      t.timestamps
    end
    create_table :building_items do |t|
      t.integer :building_id
      t.integer :item_id
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :buildings
    drop_table :building_items
  end
end
