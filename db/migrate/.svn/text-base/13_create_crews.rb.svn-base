class CreateCrews < ActiveRecord::Migration
  def self.up
    create_table :crews do |t|
      t.string  :name
      t.integer :starship_id
      t.integer :lifeform_id
      t.integer :quantity

      t.timestamps
    end
    create_table :officer_skills do |t|
      t.integer :crew_id
      t.integer :skill_id

      t.timestamps
    end
  end

  def self.down
    drop_table :crews
    drop_table :officer_skills
  end
end
