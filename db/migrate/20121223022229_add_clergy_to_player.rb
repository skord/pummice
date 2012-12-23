class AddClergyToPlayer < ActiveRecord::Migration
  def change
    add_column :seats, :prior_locationX, :integer, :default => 0
    add_column :seats, :prior_locationY, :integer, :default => 0
    add_column :seats, :prior_location_seat_id, :integer
    add_column :seats, :clergy0_locationX, :integer, :default => 0
    add_column :seats, :clergy0_locationY, :integer, :default => 0
    add_column :seats, :clergy1_locationX, :integer, :default => 0
    add_column :seats, :clergy1_locationY, :integer, :default => 0
  end
end
