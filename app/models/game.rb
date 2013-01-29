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

  scope :active, where('round > 0')
  scope :pending_users, where('round = 0')

  def find_seat_by_user(user)
    nil if !user.is_a? User
    seats.where(:user_id => user.id).first
  end

  def correct_number_of_users
    errors.add(:base, "Incorrect number of players") if users.count > 4
  end

  def grape_enters
    if variant == GameVariant::IRELAND
      return 0
    end
    case number_of_players
    when 1
      return 0
    when 2
      return 11
    when 3
      if is_short_game
        return 4
      end
      return 8
    when 4
      if is_short_game
        return 4
      end
      return 8
    end
  end

  def stone_enters
    case number_of_players
    when 1
      return 0
    when 2
      return 18
    when 3
      if is_short_game
        return 6
      end
      return 13
    when 4
      if is_short_game
        return 6
      end
      return 13
    end
  end

  def map_age
    case age
    when Age::START
      return 'Start'
    when Age::A
      return 'A'
    when Age::B
      return 'B'
    when Age::C
      return 'C'
    when Age::D
      return 'D'
    else
      return ''
    end
  end

  def map_phase
    case phase
    when Phase::NORMAL
      return 'Action'
    when Phase::SETTLEMENT
      return 'Settlement'
    when Phase::ENDGAME
      return 'End of Game'
    else
      return ''
    end
  end

  def production_list
    if (number_of_players == 2 && is_short_game == true)
      return [0, 1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 8, 10]
    end
    return [0, 2, 3, 4, 5, 6, 6, 7, 7, 8, 8, 9, 10]
  end

  def wood_production
    production_list[(wheel_position - wheel_wood_position) % 13] if wheel_wood_position > 0
  end

  def peat_production
    production_list[(wheel_position - wheel_peat_position) % 13] if wheel_peat_position > 0
  end

  def grain_production
    production_list[(wheel_position - wheel_grain_position) % 13] if wheel_grain_position > 0
  end

  def livestock_production
    production_list[(wheel_position - wheel_livestock_position) % 13] if wheel_livestock_position > 0
  end

  def clay_production
    production_list[(wheel_position - wheel_clay_position) % 13] if wheel_clay_position > 0
  end

  def coin_production
    production_list[(wheel_position - wheel_coin_position) % 13] if wheel_coin_position > 0
  end

  def joker_production
    production_list[(wheel_position - wheel_joker_position) % 13] if wheel_joker_position > 0
  end

  def grape_production
    production_list[(wheel_position - wheel_grape_position) % 13] if 
      variant == GameVariant::FRANCE && number_of_players > 1 && wheel_grape_position > 0
  end

  def stone_production
    production_list[(wheel_position - wheel_stone_position) % 13] if number_of_players > 1 && wheel_stone_position > 0
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
