class RemoveGamesUsersAssocCreateNewAssoc < ActiveRecord::Migration
  def up
  	drop_table :games_users

    create_table :seats do |t|
      t.references :game, :null => false
      t.references :user, :null => true

      t.integer :number, :default => 0
    end
    add_index :seats, [:game_id, :user_id]
  end

  def down
    drop_table :seats

    create_table :games_users, :id => false do |t|
      t.references :game, :null => false
      t.references :user, :null => false
    end
    add_index :games_users, [:game_id, :user_id]
  end
end
