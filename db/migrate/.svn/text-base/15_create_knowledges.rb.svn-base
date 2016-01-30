class CreateKnowledges < ActiveRecord::Migration
  def self.up
    create_table :knowledges do |t|
      t.string :name
      t.string :knowledge_type
      t.integer :prequisite_id
      t.integer :allows_production_id
      t.string :officer_skill_attribute
      t.float :attribute_modifier

      t.timestamps
    end
  end

  def self.down
    drop_table :knowledges
  end
end
