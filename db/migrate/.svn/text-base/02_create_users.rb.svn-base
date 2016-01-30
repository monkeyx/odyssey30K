class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   :login,                     :limit => 40
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      
      t.string   :character_type,            :limit => 40
      t.integer  :drachma                    
      t.datetime :subscription_until
      
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at

      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at

    end
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
    
    create_table "roles" do |t|
      t.string :name
    end
    
    # generate the join table
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"
  end

  def self.down
    drop_table "users"
    drop_table "roles"
    drop_table "roles_users"
  end
end
