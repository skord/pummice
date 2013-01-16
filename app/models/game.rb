class Game < ActiveRecord::Base
  attr_accessible :name, :number_of_players, :variant, :is_short_game, :use_loamy_landscape, :age, :phase, :round, :turn,
                  :wheel_type, :wheel_position, :wheel_wood_position, :wheel_peat_position, :wheel_grain_position, 
                  :wheel_livestock_position, :wheel_clay_position, :wheel_coin_position, :wheel_joker_position, 
                  :wheel_grape_position, :wheel_stone_position, :wheel_house_position
  has_many :seats
  has_many :users, :through => :seats
  has_many :districts, :as => :districtable
  has_many :plots, :as => :plotable
  has_many :chatlogs

  has_and_belongs_to_many :building_cards

  validate :correct_number_of_users

  def correct_number_of_users
    errors.add(:base, "Incorrect number of players") if users.count > 4
  end
end

class WheelType
  FOUR_PLAYER = 1
  THREE_PLAYER = 2
  THREE_FOUR_PLAYER_SHORT = 3
  ONE_TWO_PLAYER = 4
  TWO_PLAYER_LONG = 5
end

class GameVariant
  ALL = 0
  FRANCE = 1
  IRELAND = 2
end

class Age
  START = 0
  A = 1
  B = 2
  C = 3
  D = 4
end

class Phase
  NORMAL = 0
  SETTLEMENT = 1
  ENDGAME = 2
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
  TWO_LONG = 16
  THREE_SHORT = 32
  FOUR_SHORT = 64
end
