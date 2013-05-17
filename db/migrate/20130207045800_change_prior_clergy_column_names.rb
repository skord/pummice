class ChangePriorClergyColumnNames < ActiveRecord::Migration
  def up
    remove_column :seats, :prior_locationX
    remove_column :seats, :prior_locationY
    remove_column :seats, :prior_location_seat_id
    remove_column :seats, :clergy0_locationX
    remove_column :seats, :clergy0_locationY
    remove_column :seats, :clergy1_locationX
    remove_column :seats, :clergy1_locationY

    add_column :seats, :prior_location_x, :integer, :default => 0
    add_column :seats, :prior_location_y, :integer, :default => 0
    add_column :seats, :prior_location_seat_id, :integer
    add_column :seats, :clergy0_location_x, :integer, :default => 0
    add_column :seats, :clergy0_location_y, :integer, :default => 0
    add_column :seats, :clergy1_location_x, :integer, :default => 0
    add_column :seats, :clergy1_location_y, :integer, :default => 0
  end

  def down
    remove_column :seats, :prior_location_x
    remove_column :seats, :prior_location_y
    remove_column :seats, :prior_location_seat_id
    remove_column :seats, :clergy0_location_x
    remove_column :seats, :clergy0_location_y
    remove_column :seats, :clergy1_location_x
    remove_column :seats, :clergy1_location_y

    add_column :seats, :prior_locationX, :integer, :default => 0
    add_column :seats, :prior_locationY, :integer, :default => 0
    add_column :seats, :prior_location_seat_id, :integer
    add_column :seats, :clergy0_locationX, :integer, :default => 0
    add_column :seats, :clergy0_locationY, :integer, :default => 0
    add_column :seats, :clergy1_locationX, :integer, :default => 0
    add_column :seats, :clergy1_locationY, :integer, :default => 0
  end
end
