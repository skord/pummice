class Chatlog < ActiveRecord::Base
  attr_accessible :message
  belongs_to :game
  belongs_to :seat
end