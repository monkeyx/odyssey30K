class CreateSquadrons < ActiveRecord::Migration
  def self.up
    create_table :squadrons do |t|
      t.string :name
      t.integer :squadron_leader_id

      t.timestamps
    end
  end

  def self.down
    drop_table :squadrons
  end
end
