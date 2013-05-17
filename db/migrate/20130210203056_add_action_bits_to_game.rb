class AddActionBitsToGame < ActiveRecord::Migration
  def change
    add_column :games, :action_taken, :boolean, :default => false
    add_column :games, :landscape_purchased, :boolean, :default => false
  end
end
