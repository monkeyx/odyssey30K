class CreateUserKnowledges < ActiveRecord::Migration
  def self.up
    create_table :user_knowledges do |t|
      t.integer :user_id
      t.integer :knowledge_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_knowledges
  end
end
