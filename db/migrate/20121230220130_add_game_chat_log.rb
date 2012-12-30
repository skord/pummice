class AddGameChatLog < ActiveRecord::Migration
  def up
    create_table :chatlogs do |t|
      t.references :game, :null => false
      t.references :seat, :null => false
      t.datetime :timestamp
      t.text :message
    end

    add_index :chatlogs, [:game_id, :seat_id]
  end

  def down
    drop_table :chatlogs
  end
end
