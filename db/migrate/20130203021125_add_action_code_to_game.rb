class AddActionCodeToGame < ActiveRecord::Migration
  def change
    add_column :games, :actioncode, :integer, :default => nil
  end
end
