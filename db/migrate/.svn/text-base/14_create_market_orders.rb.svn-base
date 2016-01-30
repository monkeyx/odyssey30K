class CreateMarketOrders < ActiveRecord::Migration
  def self.up
    create_table :market_orders do |t|
      t.integer :user_id
      t.integer :colony_id
      t.integer :item_id
      t.integer :buy_quantity
      t.integer :sell_quantity
      t.float :price
      t.integer :destination_id
      t.string :destination_model
      t.timestamps
    end
  end

  def self.down
    drop_table :market_orders
  end
end
