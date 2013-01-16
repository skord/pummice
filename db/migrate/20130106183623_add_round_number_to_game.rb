class AddRoundNumberToGame < ActiveRecord::Migration
  def change
    add_column :games, :age, :integer, :default => 0
    add_column :games, :phase, :integer, :default => 0
    add_column :games, :round, :integer, :default => 0
    add_column :games, :turn, :integer, :default => 0
  end
end
