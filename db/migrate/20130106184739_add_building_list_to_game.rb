class AddBuildingListToGame < ActiveRecord::Migration
  def up
    create_table :building_cards_games, :id => false do |t|
      t.references :game, :null => false
      t.references :building_card, :null => false
    end

    add_index :building_cards_games, [:game_id, :building_card_id]
  end

  def down
    drop_table :building_cards_games
  end
end
