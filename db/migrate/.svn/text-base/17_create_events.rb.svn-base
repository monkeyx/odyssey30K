class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.integer :model_id
      t.string :model_class
      t.text :description
      t.boolean :major
      
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
