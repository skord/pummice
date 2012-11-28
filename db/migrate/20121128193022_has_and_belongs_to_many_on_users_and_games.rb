class HasAndBelongsToManyOnUsersAndGames < ActiveRecord::Migration
  def up
    create_table :games_users, :id => false do |t|
      t.references :game, :null => false
      t.references :user, :null => false
    end
    add_index :games_users, [:game_id, :user_id]
  end

  def down
    drop_table :games_users
  end
end
