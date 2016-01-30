class CreateDeposits < ActiveRecord::Migration
  def self.up
    create_table :deposits do |t|
      t.integer :celestial_body_id
      t.integer :item_id
      t.integer :deposit_yield
      t.integer :deposit_reserves
      t.integer :deposit_growth

      t.timestamps
    end
  end

  def self.down
    drop_table :deposits
  end
end
