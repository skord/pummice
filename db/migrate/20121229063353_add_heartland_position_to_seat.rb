class AddHeartlandPositionToSeat < ActiveRecord::Migration
  def change
    add_column :seats, :heartland_position_x, :integer, :default => 100
    add_column :seats, :heartland_position_y, :integer, :default => 100
  end
end
