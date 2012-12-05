class Game < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :users

  validate :correct_number_of_users

  def correct_number_of_users
    errors.add(:base, "Incorrect number of users") if users.count > 4
  end
end
