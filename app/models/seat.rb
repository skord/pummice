class Seat < ActiveRecord::Base
  attr_accessible :number
  belongs_to :game
  belongs_to :user

end