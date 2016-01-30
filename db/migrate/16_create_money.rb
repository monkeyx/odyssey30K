class CreateMoney < ActiveRecord::Migration
  def self.up
    create_table :money do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :sender_model
      t.string :receiver_model
      t.float :amount
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :cashes
  end
end
