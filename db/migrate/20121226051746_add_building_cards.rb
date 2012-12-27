class AddBuildingCards < ActiveRecord::Migration
  def up
    create_table :building_cards do |t|
      t.string :name
      t.integer :variant
      t.string :key
      t.boolean :is_base
      t.boolean :is_cloister
      t.integer :age
      t.integer :available_location_types
      t.integer :number_players
      t.integer :cost_wood
      t.integer :cost_clay
      t.integer :cost_stone
      t.integer :cost_straw
      t.integer :cost_coin
      t.integer :cost_fuel
      t.integer :cost_food
      t.integer :economic_value
      t.integer :dwelling_value
    end
  end

  def down
    drop_table :building_cards
  end
end
