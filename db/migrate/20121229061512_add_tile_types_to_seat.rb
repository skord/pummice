class AddTileTypesToSeat < ActiveRecord::Migration
  def change
    add_column :seats, :tile00_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile10_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile01_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile11_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile02_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile12_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile03_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile13_type, :integer, :default => LocationType::PLAINS
    add_column :seats, :tile04_type, :integer, :default => LocationType::HILLSIDE
    add_column :seats, :tile14_type, :integer, :default => LocationType::PLAINS
  end
end

class LocationType
  PLAINS = 1
  HILLSIDE = 2
  COAST = 4
  MOUNTAIN = 8
  WATER = 16
  CLAYMOUND = 32
end