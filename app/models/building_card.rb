class BuildingCard < ActiveRecord::Base
  attr_readonly :name, :variant, :key, :is_base, :is_cloister, :age, :available_location_types, :number_players, :cost_wood, 
                :cost_clay, :cost_stone, :cost_straw, :cost_coin, :cost_fuel, :cost_food, :economic_value, :dwelling_value



end

class GameVariant
  ALL = 0
  FRANCE = 1
  IRELAND = 2
end

class LocationType
  PLAINS = 1
  HILLSIDE = 2
  COAST = 4
  MOUNTAIN = 8
  WATER = 16
  CLAYMOUND = 32
end

class NumberOfPlayers
  ONE = 1
  TWO = 2
  THREE = 4
  FOUR = 8
end

class Age
  START = 0
  A = 1
  B = 2
  C = 3
  D = 4
end