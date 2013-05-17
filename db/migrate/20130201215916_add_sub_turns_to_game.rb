class AddSubTurnsToGame < ActiveRecord::Migration
  def up
    create_table :subturns do |t|
      t.references :game, :null => false
      t.references :seat, :null => false
      t.datetime :timestamp
      t.integer :actioncode
      t.string :parameters
    end

    add_index :subturns, [:game_id, :seat_id]


    add_column :games, :action_seat_id, :integer, :default => nil

    add_index :games, [:action_seat_id]
  end

  def down
    drop_table :subturns
    remove_column :games, :action_seat_id
  end
end
