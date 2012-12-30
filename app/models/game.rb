class Game < ActiveRecord::Base
  attr_accessible :name, :number_of_players, :variant, :is_short_game, :use_loamy_landscape
  has_many :seats
  has_many :users, :through => :seats
  has_many :districts, :as => :districtable
  has_many :plots, :as => :plotable
  has_many :chatlogs

  validate :correct_number_of_users

  def correct_number_of_users
    errors.add(:base, "Incorrect number of players") if users.count > 4
  end
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