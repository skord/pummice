class AddActiveToGame < ActiveRecord::Migration
  def change
    add_column :games, :active, :boolean, default: true
  end
end
