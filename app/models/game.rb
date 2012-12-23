class Game < ActiveRecord::Base
  attr_accessible :name, :number_of_players, :variant, :is_short_game, :use_loamy_landscape
  has_many :seats
  has_many :users, :through => :seats

  validate :correct_number_of_users

  def correct_number_of_users
    errors.add(:base, "Incorrect number of players") if users.count > 4
  end
end

class GameVariant
  FRANCE = 0
  IRELAND = 1
end