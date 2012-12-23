class AddWheelInfoToGame < ActiveRecord::Migration
  def change
    add_column :games, :wheel_type, :integer, :default => 0
    add_column :games, :wheel_position, :integer, :default => 0
    add_column :games, :wheel_wood_position, :integer, :default => 0
    add_column :games, :wheel_peat_position, :integer, :default => 0
    add_column :games, :wheel_grain_position, :integer, :default => 0
    add_column :games, :wheel_livestock_position, :integer, :default => 0
    add_column :games, :wheel_clay_position, :integer, :default => 0
    add_column :games, :wheel_coin_position, :integer, :default => 0
    add_column :games, :wheel_joker_position, :integer, :default => 0
    add_column :games, :wheel_grape_position, :integer, :default => 0
    add_column :games, :wheel_stone_position, :integer, :default => 0
    add_column :games, :wheel_house_position, :integer, :default => 0
  end
end
