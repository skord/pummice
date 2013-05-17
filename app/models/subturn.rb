class Subturn < ActiveRecord::Base
  attr_accessible :seat_id, :timestamp, :actioncode, :message, :parameters
  belongs_to :game
  belongs_to :seat
end

class SubturnActionCode
  NOTHING = 0
  FELL_TREES = 1
  CUT_PEAT = 2
  CHOOSE_TILE_LOCATIONS = 3
  CHOOSE_PRODUCTION_TOKENS = 4
  CHOOSE_CLERGY_MEMBER = 5
  ENTER_BUILDING = 6
  BUILD_BUILDING = 7
  DECIDE_ENTER_BUILDING = 8
  CHOOSE_BUILDING_ACTION = 9
  CONVERT_RESOURCES = 10
  BUY_LANDSCAPE = 11
  PLACE_LANDSCAPE = 12
  RETURN_CLERGY = 13
  CHOOSE_RESOURCES = 14
  GAIN_LANDSCAPE = 15
  WORK_CONTRACT = 16
end

class SubturnResourceMode
  UNIQUES = 1
  FUEL_FOOD = 2
  OPTIONS = 3
  VPS = 4
  SPEND_CHOICES = 5
end