class CreateColonies < ActiveRecord::Migration
  def self.up
    create_table :colonies do |t|
      t.string :name
      t.integer :celestial_body_id
      t.integer :governor_id
      t.float :tax_rate
      t.string :building_policy

      t.timestamps
    end
  end

  def self.down
    drop_table :colonies
  end
end
