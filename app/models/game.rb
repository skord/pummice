class Game < ActiveRecord::Base
  attr_accessible :name, :variant, :is_short_game, :use_loamy_landscape
  has_and_belongs_to_many :users

  validate :correct_number_of_users

  def correct_number_of_users
    errors.add(:base, "Incorrect number of users") if users.count > 4
  end
end

class GameVariant
  FRANCE = 0
  IRELAND = 1
end