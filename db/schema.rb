# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20) do

  create_table "building_items", :force => true do |t|
    t.integer  "building_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buildings", :force => true do |t|
    t.integer  "colony_id"
    t.integer  "building_type_id"
    t.integer  "owner_id"
    t.integer  "level"
    t.float    "efficiency"
    t.integer  "bonus_wages"
    t.boolean  "automated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "celestial_bodies", :force => true do |t|
    t.string   "name"
    t.string   "body_type"
    t.integer  "star_system_id"
    t.integer  "orbital_ring"
    t.integer  "orbital_quadrant"
    t.float    "gravity_rating"
    t.string   "atmosphere_type"
    t.string   "surface_type"
    t.float    "colonist_growth_rate"
    t.float    "morale_modifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clusters", :force => true do |t|
    t.string   "name"
    t.boolean  "restricted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colonies", :force => true do |t|
    t.string   "name"
    t.integer  "celestial_body_id"
    t.integer  "governor_id"
    t.float    "tax_rate"
    t.string   "building_policy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colonist_knowledges", :force => true do |t|
    t.integer  "colonist_id"
    t.integer  "knowledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colonists", :force => true do |t|
    t.integer  "colony_id"
    t.integer  "building_id"
    t.integer  "lifeform_id"
    t.integer  "quantity"
    t.string   "name"
    t.float    "morale"
    t.integer  "drachma"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crews", :force => true do |t|
    t.string   "name"
    t.integer  "starship_id"
    t.integer  "lifeform_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deposits", :force => true do |t|
    t.integer  "celestial_body_id"
    t.integer  "item_id"
    t.integer  "deposit_yield"
    t.integer  "deposit_reserves"
    t.integer  "deposit_growth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "model_id"
    t.string   "model_class"
    t.text     "description"
    t.boolean  "major"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_attributes", :force => true do |t|
    t.integer "item_id"
    t.string  "name"
    t.float   "value"
  end

  create_table "item_raw_materials", :force => true do |t|
    t.integer "item_id"
    t.integer "raw_material_id"
    t.float   "quantity"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "mass"
    t.string   "category"
    t.string   "sub_category"
    t.boolean  "restricted"
    t.integer  "knowledge_id"
    t.string   "user_type_restriction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "knowledges", :force => true do |t|
    t.string   "name"
    t.string   "knowledge_type"
    t.integer  "prequisite_id"
    t.integer  "allows_production_id"
    t.string   "officer_skill_attribute"
    t.float    "attribute_modifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "market_orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "colony_id"
    t.integer  "item_id"
    t.integer  "buy_quantity"
    t.integer  "sell_quantity"
    t.float    "price"
    t.integer  "destination_id"
    t.string   "destination_model"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "money", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "sender_model"
    t.string   "receiver_model"
    t.float    "amount"
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "node_links", :force => true do |t|
    t.integer  "from_star_system_id"
    t.integer  "to_star_system_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "officer_skills", :force => true do |t|
    t.integer  "crew_id"
    t.integer  "skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "production_items", :force => true do |t|
    t.integer  "building_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.float    "produced"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "squadrons", :force => true do |t|
    t.string   "name"
    t.integer  "squadron_leader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "star_systems", :force => true do |t|
    t.string   "name"
    t.integer  "x"
    t.integer  "y"
    t.string   "star_type"
    t.string   "sec_zone"
    t.integer  "cluster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "starship_attributes", :force => true do |t|
    t.integer "starship_id"
    t.string  "name"
    t.float   "value"
  end

  create_table "starship_cargos", :force => true do |t|
    t.integer  "starship_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "starship_sections", :force => true do |t|
    t.integer "starship_id"
    t.integer "section_id"
  end

  create_table "starships", :force => true do |t|
    t.string   "name"
    t.integer  "captain_id"
    t.integer  "squadron_id"
    t.integer  "celestial_body_id"
    t.integer  "colony_id"
    t.integer  "chassis_id"
    t.float    "crew_efficiency"
    t.float    "combat_efficiency"
    t.float    "current_integrity"
    t.float    "current_energy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_knowledges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "knowledge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "character_type",            :limit => 40
    t.integer  "drachma"
    t.datetime "subscription_until"
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
