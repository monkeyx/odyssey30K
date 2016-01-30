class CreateProductionItems < ActiveRecord::Migration
  def self.up
    create_table :production_items do |t|
      t.integer :building_id
      t.integer :item_id
      t.integer :quantity
      t.float :produced

      t.timestamps
    end
  end

  def self.down
    drop_table :workshop_queues
  end
end
