class CreateColonists < ActiveRecord::Migration
  def self.up
    create_table :colonists do |t|
      t.integer :colony_id
      t.integer :building_id
      t.integer :lifeform_id
      t.integer :quantity
      t.string  :name
      t.float   :morale
      t.integer :drachma
      t.timestamps
    end
    create_table :colonist_knowledges do |t|
      t.integer :colonist_id
      t.integer :knowledge_id

      t.timestamps
    end
  end

  def self.down
    drop_table :colonists
    drop_table :colonist_knowledges
  end
end
