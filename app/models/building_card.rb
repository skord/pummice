class BuildingCard < ActiveRecord::Base
  attr_readonly :name, :variant, :key, :is_base, :is_cloister, :age, :available_location_types, :number_players, :cost_wood, 
                :cost_clay, :cost_stone, :cost_straw, :cost_coin, :cost_fuel, :cost_food, :economic_value, :dwelling_value

  has_many :seats

end