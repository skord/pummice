# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121223022229) do

  create_table "games", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "active",                   :default => true
    t.integer  "variant",                  :default => 0
    t.boolean  "is_short_game",            :default => true
    t.boolean  "use_loamy_landscape",      :default => false
    t.integer  "number_of_players",        :default => 2
    t.integer  "wheel_type",               :default => 0
    t.integer  "wheel_position",           :default => 0
    t.integer  "wheel_wood_position",      :default => 0
    t.integer  "wheel_peat_position",      :default => 0
    t.integer  "wheel_grain_position",     :default => 0
    t.integer  "wheel_livestock_position", :default => 0
    t.integer  "wheel_clay_position",      :default => 0
    t.integer  "wheel_coin_position",      :default => 0
    t.integer  "wheel_joker_position",     :default => 0
    t.integer  "wheel_grape_position",     :default => 0
    t.integer  "wheel_stone_position",     :default => 0
    t.integer  "wheel_house_position",     :default => 0
  end

  create_table "seats", :force => true do |t|
    t.integer "game_id",                               :null => false
    t.integer "user_id"
    t.integer "number",                 :default => 0
    t.integer "res_peat",               :default => 0
    t.integer "res_peatcoal",           :default => 0
    t.integer "res_livestock",          :default => 0
    t.integer "res_meat",               :default => 0
    t.integer "res_grain",              :default => 0
    t.integer "res_straw",              :default => 0
    t.integer "res_wood",               :default => 0
    t.integer "res_whiskey",            :default => 0
    t.integer "res_clay",               :default => 0
    t.integer "res_ceramic",            :default => 0
    t.integer "res_coin",               :default => 0
    t.integer "res_book",               :default => 0
    t.integer "res_5coin",              :default => 0
    t.integer "res_reliquery",          :default => 0
    t.integer "res_stone",              :default => 0
    t.integer "res_ornament",           :default => 0
    t.integer "res_grapes",             :default => 0
    t.integer "res_wine",               :default => 0
    t.integer "res_flour",              :default => 0
    t.integer "res_bread",              :default => 0
    t.integer "res_malt",               :default => 0
    t.integer "res_beer",               :default => 0
    t.integer "res_wonder",             :default => 0
    t.integer "prior_locationX",        :default => 0
    t.integer "prior_locationY",        :default => 0
    t.integer "prior_location_seat_id"
    t.integer "clergy0_locationX",      :default => 0
    t.integer "clergy0_locationY",      :default => 0
    t.integer "clergy1_locationX",      :default => 0
    t.integer "clergy1_locationY",      :default => 0
  end

  add_index "seats", ["game_id", "user_id"], :name => "index_seats_on_game_id_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",                           :null => false
    t.string   "encrypted_password",     :default => "",                           :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.string   "lastname"
    t.string   "firstname"
    t.boolean  "admin"
    t.string   "timezone",               :default => "Central Time (US & Canada)"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
