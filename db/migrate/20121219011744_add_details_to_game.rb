class AddDetailsToGame < ActiveRecord::Migration
  def change
    add_column :games, :variant, :integer, :default => 0
    add_column :games, :is_short_game, :boolean, :default => true
    add_column :games, :use_loamy_landscape, :boolean, :default => false
  end
end
