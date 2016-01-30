class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :name
      t.integer :mass
      t.string :category
      t.string :sub_category
      t.boolean :restricted
      t.integer :knowledge_id
      t.string :user_type_restriction

      t.timestamps
    end
    create_table :item_attributes do |t|
      t.integer :item_id
      t.string :name
      t.float :value
    end
    create_table :item_raw_materials do |t|
      t.integer :item_id
      t.integer :raw_material_id
      t.float :quantity
    end
  end

  def self.down
    drop_table :items
    drop_table :item_attributes
    drop_table :item_raw_materials
  end
end
