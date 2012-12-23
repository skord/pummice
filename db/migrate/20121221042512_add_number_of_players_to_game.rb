class AddNumberOfPlayersToGame < ActiveRecord::Migration
  def change
    add_column :games, :number_of_players, :integer, :default => 2
  end
end
