class ChangeActionTakenToCountInGame < ActiveRecord::Migration
  def up
    remove_column :games, :action_taken
    add_column :games, :actions_taken, :integer, :default => 0
  end

  def down
    remove_column :games, :actions_taken
    add_column :games, :action_taken, :boolean, :default => false
  end
end
