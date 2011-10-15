# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111015172448) do

  create_table "accounts", :force => true do |t|
    t.integer  "employer_id"
    t.integer  "owner_id"
    t.string   "table"
    t.integer  "guests"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["employer_id"], :name => "index_accounts_on_employer_id"
  add_index "accounts", ["owner_id"], :name => "index_accounts_on_owner_id"

  create_table "deliveries", :force => true do |t|
    t.string   "name"
    t.string   "descr"
    t.integer  "menu_id"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deliveries", ["menu_id"], :name => "index_deliveries_on_menu_id"
  add_index "deliveries", ["name"], :name => "index_deliveries_on_name"

  create_table "menus", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menus", ["user_id"], :name => "index_menus_on_user_id"

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["created_at"], :name => "index_microposts_on_created_at"
  add_index "microposts", ["user_id"], :name => "index_microposts_on_user_id"

  create_table "orders", :force => true do |t|
    t.integer  "account_id"
    t.integer  "delivery_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
  end

  add_index "orders", ["account_id", "delivery_id"], :name => "index_orders_on_account_id_and_delivery_id", :unique => true
  add_index "orders", ["account_id"], :name => "index_orders_on_account_id"
  add_index "orders", ["delivery_id"], :name => "index_orders_on_delivery_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "workrelations", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "employer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workrelations", ["employer_id"], :name => "index_workrelations_on_employer_id"
  add_index "workrelations", ["owner_id", "employer_id"], :name => "index_workrelations_on_owner_id_and_employer_id", :unique => true
  add_index "workrelations", ["owner_id"], :name => "index_workrelations_on_owner_id"

end
