class Chatlog < ActiveRecord::Base
  attr_accessible :seat_id, :timestamp, :message
  belongs_to :game
  belongs_to :seat
end