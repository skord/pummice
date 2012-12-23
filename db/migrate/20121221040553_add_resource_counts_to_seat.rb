class AddResourceCountsToSeat < ActiveRecord::Migration
  def change
    add_column :seats, :res_peat, :integer, :default => 0
    add_column :seats, :res_peatcoal, :integer, :default => 0
    add_column :seats, :res_livestock, :integer, :default => 0
    add_column :seats, :res_meat, :integer, :default => 0
    add_column :seats, :res_grain, :integer, :default => 0
    add_column :seats, :res_straw, :integer, :default => 0
    add_column :seats, :res_wood, :integer, :default => 0
    add_column :seats, :res_whiskey, :integer, :default => 0
    add_column :seats, :res_clay, :integer, :default => 0
    add_column :seats, :res_ceramic, :integer, :default => 0
    add_column :seats, :res_coin, :integer, :default => 0
    add_column :seats, :res_book, :integer, :default => 0
    add_column :seats, :res_5coin, :integer, :default => 0
    add_column :seats, :res_reliquery, :integer, :default => 0
    add_column :seats, :res_stone, :integer, :default => 0
    add_column :seats, :res_ornament, :integer, :default => 0
    add_column :seats, :res_grapes, :integer, :default => 0
    add_column :seats, :res_wine, :integer, :default => 0
    add_column :seats, :res_flour, :integer, :default => 0
    add_column :seats, :res_bread, :integer, :default => 0
    add_column :seats, :res_malt, :integer, :default => 0
    add_column :seats, :res_beer, :integer, :default => 0
    add_column :seats, :res_wonder, :integer, :default => 0
  end
end
