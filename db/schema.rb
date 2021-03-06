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

ActiveRecord::Schema.define(:version => 20130511061632) do

  create_table "building_cards", :force => true do |t|
    t.string  "name"
    t.integer "variant"
    t.string  "key"
    t.boolean "is_base"
    t.boolean "is_cloister"
    t.integer "age"
    t.integer "available_location_types"
    t.integer "number_players"
    t.integer "cost_wood"
    t.integer "cost_clay"
    t.integer "cost_stone"
    t.integer "cost_straw"
    t.integer "cost_coin"
    t.integer "cost_fuel"
    t.integer "cost_food"
    t.integer "economic_value"
    t.integer "dwelling_value"
  end

  create_table "building_cards_games", :id => false, :force => true do |t|
    t.integer "game_id",          :null => false
    t.integer "building_card_id", :null => false
  end

  add_index "building_cards_games", ["game_id", "building_card_id"], :name => "index_building_cards_games_on_game_id_and_building_card_id"

  create_table "chatlogs", :force => true do |t|
    t.integer  "game_id",   :null => false
    t.integer  "seat_id",   :null => false
    t.datetime "timestamp"
    t.text     "message"
  end

  add_index "chatlogs", ["game_id", "seat_id"], :name => "index_chatlogs_on_game_id_and_seat_id"

  create_table "districts", :force => true do |t|
    t.integer "districtable_id"
    t.string  "districtable_type"
    t.integer "cost"
    t.integer "side"
    t.integer "position_x"
    t.integer "position_y"
    t.integer "tile0_id"
    t.integer "tile1_id"
    t.integer "tile2_id"
    t.integer "tile3_id"
    t.integer "tile4_id"
    t.integer "tile0_type"
    t.integer "tile1_type"
    t.integer "tile2_type"
    t.integer "tile3_type"
    t.integer "tile4_type"
  end

  add_index "districts", ["tile0_id"], :name => "index_districts_on_tile0_id"
  add_index "districts", ["tile1_id"], :name => "index_districts_on_tile1_id"
  add_index "districts", ["tile2_id"], :name => "index_districts_on_tile2_id"
  add_index "districts", ["tile3_id"], :name => "index_districts_on_tile3_id"
  add_index "districts", ["tile4_id"], :name => "index_districts_on_tile4_id"

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
    t.integer  "age",                      :default => 0
    t.integer  "phase",                    :default => 0
    t.integer  "round",                    :default => 0
    t.integer  "turn",                     :default => 0
    t.integer  "action_seat_id"
    t.integer  "actioncode"
    t.boolean  "landscape_purchased",      :default => false
    t.integer  "actions_taken",            :default => 0
  end

  add_index "games", ["action_seat_id"], :name => "index_games_on_action_seat_id"

  create_table "plots", :force => true do |t|
    t.integer "plotable_id"
    t.string  "plotable_type"
    t.integer "cost"
    t.integer "side"
    t.integer "position_x"
    t.integer "position_y"
    t.integer "tile00_id"
    t.integer "tile10_id"
    t.integer "tile01_id"
    t.integer "tile11_id"
    t.integer "tile00_type"
    t.integer "tile10_type"
    t.integer "tile01_type"
    t.integer "tile11_type"
  end

  add_index "plots", ["tile00_id"], :name => "index_plots_on_tile00_id"
  add_index "plots", ["tile01_id"], :name => "index_plots_on_tile01_id"
  add_index "plots", ["tile10_id"], :name => "index_plots_on_tile10_id"
  add_index "plots", ["tile11_id"], :name => "index_plots_on_tile11_id"

  create_table "seats", :force => true do |t|
    t.integer "game_id",                                 :null => false
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
    t.integer "tile00_id"
    t.integer "tile10_id"
    t.integer "tile01_id"
    t.integer "tile11_id"
    t.integer "tile02_id"
    t.integer "tile12_id"
    t.integer "tile03_id"
    t.integer "tile13_id"
    t.integer "tile04_id"
    t.integer "tile14_id"
    t.integer "tile00_type",            :default => 1
    t.integer "tile10_type",            :default => 1
    t.integer "tile01_type",            :default => 1
    t.integer "tile11_type",            :default => 1
    t.integer "tile02_type",            :default => 1
    t.integer "tile12_type",            :default => 1
    t.integer "tile03_type",            :default => 1
    t.integer "tile13_type",            :default => 1
    t.integer "tile04_type",            :default => 2
    t.integer "tile14_type",            :default => 1
    t.integer "settlement0_id"
    t.integer "settlement1_id"
    t.integer "settlement2_id"
    t.integer "settlement3_id"
    t.integer "settlement4_id"
    t.integer "settlement5_id"
    t.integer "settlement6_id"
    t.integer "settlement7_id"
    t.integer "heartland_position_x",   :default => 100
    t.integer "heartland_position_y",   :default => 100
    t.integer "prior_location_x",       :default => 0
    t.integer "prior_location_y",       :default => 0
    t.integer "prior_location_seat_id"
    t.integer "clergy0_location_x",     :default => 0
    t.integer "clergy0_location_y",     :default => 0
    t.integer "clergy1_location_x",     :default => 0
    t.integer "clergy1_location_y",     :default => 0
  end

  add_index "seats", ["game_id", "user_id"], :name => "index_seats_on_game_id_and_user_id"
  add_index "seats", ["settlement0_id", "settlement1_id"], :name => "index_seats_on_settlement0_id_and_settlement1_id"
  add_index "seats", ["settlement2_id", "settlement3_id"], :name => "index_seats_on_settlement2_id_and_settlement3_id"
  add_index "seats", ["settlement4_id", "settlement5_id"], :name => "index_seats_on_settlement4_id_and_settlement5_id"
  add_index "seats", ["settlement6_id", "settlement7_id"], :name => "index_seats_on_settlement6_id_and_settlement7_id"
  add_index "seats", ["tile00_id", "tile10_id"], :name => "index_seats_on_tile00_id_and_tile10_id"
  add_index "seats", ["tile01_id", "tile11_id"], :name => "index_seats_on_tile01_id_and_tile11_id"
  add_index "seats", ["tile02_id", "tile12_id"], :name => "index_seats_on_tile02_id_and_tile12_id"
  add_index "seats", ["tile03_id", "tile13_id"], :name => "index_seats_on_tile03_id_and_tile13_id"
  add_index "seats", ["tile04_id", "tile14_id"], :name => "index_seats_on_tile04_id_and_tile14_id"

  create_table "subturns", :force => true do |t|
    t.integer  "game_id",    :null => false
    t.integer  "seat_id",    :null => false
    t.datetime "timestamp"
    t.integer  "actioncode"
    t.string   "parameters"
  end

  add_index "subturns", ["game_id", "seat_id"], :name => "index_subturns_on_game_id_and_seat_id"

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
