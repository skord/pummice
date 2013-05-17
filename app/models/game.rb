class Game < ActiveRecord::Base
  attr_accessible :name, :number_of_players, :variant, :is_short_game, :use_loamy_landscape, :age, :phase, :round, :turn,
                  :wheel_type, :wheel_position, :wheel_wood_position, :wheel_peat_position, :wheel_grain_position, 
                  :wheel_livestock_position, :wheel_clay_position, :wheel_coin_position, :wheel_joker_position, 
                  :wheel_grape_position, :wheel_stone_position, :wheel_house_position, :actions_taken, :landscape_purchased
  has_many :seats
  has_many :users, :through => :seats
  has_many :districts, :as => :districtable
  has_many :plots, :as => :plotable
  has_many :chatlogs
  has_many :subturns

  has_and_belongs_to_many :building_cards

  belongs_to :action_seat, :class_name => 'Seat', :foreign_key => "action_seat_id"

  validate :correct_number_of_users

  scope :active, where('round > 0')
  scope :pending_users, where('round = 0')

  def current_seat_number
    ((round - 1) + ((turn % 10) - 1)) % number_of_players + 1
  end

  def find_seat_by_user(user)
    nil if !user.is_a? User
    seats.where(:user_id => user.id).first
  end

  def find_seat_by_number(num)
    nil if !num.is_a? Integer
    seats.where(:number => num).first
  end

  def correct_number_of_users
    errors.add(:base, "Incorrect number of players") if users.count > 4
  end

  def actions_remaining
    return 0 if actions_taken == 2
    if phase == Phase::SETTLEMENT or phase == Phase::FINALACTION
      return 1 if actions_taken == 0
      return 0
    end
    if card_players == NumberOfPlayers::TWO
      return 2 if actions_taken == 0
      return 1
    end
    return 1 if actions_taken == 1
    return 0
  end

  def action_taken
    return actions_remaining == 0
  end

  def work_contract_price
    # The assumption here is that the Work Contract price is 2 if we're in B or later and 
    # the building_cards list doesn't contain either the Whiskey Distillery or the Winery
    return 2 if [Age::B, Age::C, Age::D, Age::E].include?(self.age) && 
        !self.building_cards.any?{|bc| ['I21', 'F21'].include?(bc.key)}
    return 1
  end

  def grape_enters
    return 0 if variant == GameVariant::IRELAND || self.wheel_grape_position > 0
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
    return 0 if self.wheel_stone_position > 0
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
    when Age::E
      return 'E'
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
    when Phase::BONUS
      return 'Bonus'
    when Phase::ENDGAME
      return 'End of Game'
    when Phase::FINALACTION
      return 'Final Action'
    else
      return ''
    end
  end

  def map_resource(resource)
    case resource
    when Resource::WOOD
      return 'Wood'
    when Resource::PEAT
      return 'Peat'
    when Resource::GRAIN
      return 'Grain'
    when Resource::LIVESTOCK
      return 'Livestock'
    when Resource::CLAY
      return 'Clay'
    when Resource::COIN
      return 'Coin'
    when Resource::COINX5
      return '5 Coins'
    when Resource::STONE
      return 'Stone'
    when Resource::GRAPES
      return 'Grapes'
    when Resource::MALT
      return 'Malt'
    when Resource::FLOUR
      return 'Flour'
    when Resource::WHISKEY
      return 'Whiskey'
    when Resource::PEATCOAL
      return 'Peatcoal'
    when Resource::STRAW
      return 'Straw'
    when Resource::MEAT
      return 'Meat'
    when Resource::CERAMIC
      return 'Ceramic'
    when Resource::BOOK
      return 'Book'
    when Resource::RELIQUERY
      return 'Reliquery'
    when Resource::ORNAMENT
      return 'Ornament'
    when Resource::WINE
      return 'Wine'
    when Resource::BEER
      return 'Beer'
    when Resource::BREAD
      return 'Bread'
    when Resource::WONDER
      return 'Wonder'
    when Resource::FOOD
      return 'Food'
    when Resource::FUEL
      return 'Fuel'
    when Resource::VP
      return 'VP'
    else
      return 'huh?'
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

  def available_tokens(token_hash)
    tokens = []
    for resource, token in token_hash
      tokens << ["%s (%s)" % [map_resource(resource), get_production(token&(~Token::JOKER))], '%s:%s' % [resource, token&(~Token::JOKER)]] if token != Token::JOKER
      tokens << ["Joker (%s) (%s)" % [map_resource(resource), get_production(Token::JOKER)], '%s:%s' % [resource, token&Token::JOKER]] if token&Token::JOKER == Token::JOKER
    end

    return tokens
  end

  def get_production(token)
    case token
    when Token::WOOD
      wood_production
    when Token::PEAT
      peat_production
    when Token::GRAIN
      grain_production
    when Token::LIVESTOCK
      livestock_production
    when Token::CLAY
      clay_production
    when Token::COIN
      coin_production
    when Token::GRAPE
      grape_production
    when Token::STONE
      stone_production
    when Token::JOKER
      joker_production
    else
      -1
    end
  end

  def use_production_wheel(resource, token, seat)
    seat.add_resource(resource, get_production(token))
    seat.save_all
    if number_of_players.between?(3, 4) and is_short_game
      for s in seats
        s.add_resource(resource, 1)
        s.save_all
      end
    end
    reset_production_token(token)
    subturns << Subturn.new({
      :seat_id => seat.id, 
      :timestamp => Time.now, 
      :actioncode => SubturnActionCode::CHOOSE_PRODUCTION_TOKENS,
      :parameters => token.to_s})
    save
  end

  def reset_production_token(token)
    case token
    when Token::WOOD
      self.wheel_wood_position = wheel_position
    when Token::PEAT
      self.wheel_peat_position = wheel_position
    when Token::GRAIN
      self.wheel_grain_position = wheel_position
    when Token::LIVESTOCK
      self.wheel_livestock_position = wheel_position
    when Token::CLAY
      self.wheel_clay_position = wheel_position
    when Token::COIN
      self.wheel_coin_position = wheel_position
    when Token::GRAPE
      self.wheel_grape_position = wheel_position
    when Token::STONE
      self.wheel_stone_position = wheel_position
    else
      if token&Token::JOKER == Token::JOKER
        self.wheel_joker_position = wheel_position
      end
    end
    save
  end

  def next_turn()
    self.subturns.destroy_all
    case self.phase
    when Phase::NORMAL
      if card_players == NumberOfPlayers::TWO
        # In the 2-player short variant, each new "turn" is a new round
        self.next_round
      else
        if (self.turn <= self.number_of_players)
          self.turn += 1
        else
          self.turn = 1
          self.next_round
        end
      end
    when Phase::SETTLEMENT
      self.turn += 1
      if self.turn - 11 == self.number_of_players
        if self.age == Age::E
          self.turn = 0
          self.phase = Phase::ENDGAME
          self.action_seat = nil
          self.active = false
        else
          self.turn = 1
          self.phase = Phase::NORMAL
          seats.each do |seat|
            case self.age
            when Age::A
              seat.settlement4 = BuildingCard.where(:key => 'S05').first
            when Age::B
              seat.settlement5 = BuildingCard.where(:key => 'S06').first
            when Age::C
              seat.settlement6 = BuildingCard.where(:key => 'S07').first
            when Age::D
              seat.settlement7 = BuildingCard.where(:key => 'S08').first
            end
            seat.save_all
          end
          card_where_clause = {:age => self.age, :variant => self.variant, :nop => self.card_players}
          self.building_cards += BuildingCard.where(
            'age = :age AND is_base = false AND variant IN (0, :variant) AND (number_players & :nop) = :nop', 
            card_where_clause)
        end
      end
    when Phase::BONUS
      self.turn += 1
      if self.turn - 21 == self.number_of_players
        self.turn = 11
        self.phase = Phase::SETTLEMENT
      end
    when Phase::FINALACTION
      self.phase = Phase::ENDGAME
    end
    self.actions_taken = 0
    self.landscape_purchased = false
    if self.phase != Phase::ENDGAME
      self.action_seat = self.find_seat_by_number(self.current_seat_number)
    end
    self.save
  end

  def next_round()
    self.round += 1
    self.wheel_position += 1
    if self.number_of_players == 1
      self.wheel_wood_position = 0 if self.wheel_position - self.wheel_wood_position >= 13
      self.wheel_peat_position = 0 if self.wheel_position - self.wheel_peat_position >= 13
      self.wheel_grain_position = 0 if self.wheel_position - self.wheel_grain_position >= 13
      self.wheel_livestock_position = 0 if self.wheel_position - self.wheel_livestock_position >= 13
      self.wheel_clay_position = 0 if self.wheel_position - self.wheel_clay_position >= 13
      self.wheel_coin_position = 0 if self.wheel_position - self.wheel_coin_position >= 13
      self.wheel_joker_position = 0 if self.wheel_position - self.wheel_joker_position >= 13
      self.wheel_grape_position = 0 if self.wheel_grape_position > 0 and self.wheel_position - self.wheel_grape_position >= 13
      self.wheel_stone_position = 0 if self.wheel_stone_position > 0 and self.wheel_position - self.wheel_stone_position >= 13
    else
      self.wheel_wood_position += 1 if self.wheel_position - self.wheel_wood_position >= 13
      self.wheel_peat_position += 1 if self.wheel_position - self.wheel_peat_position >= 13
      self.wheel_grain_position += 1 if self.wheel_position - self.wheel_grain_position >= 13
      self.wheel_livestock_position += 1 if self.wheel_position - self.wheel_livestock_position >= 13
      self.wheel_clay_position += 1 if self.wheel_position - self.wheel_clay_position >= 13
      self.wheel_coin_position += 1 if self.wheel_position - self.wheel_coin_position >= 13
      self.wheel_joker_position += 1 if self.wheel_position - self.wheel_joker_position >= 13
      self.wheel_grape_position += 1 if self.wheel_grape_position > 0 and self.wheel_position - self.wheel_grape_position >= 13
      self.wheel_stone_position += 1 if self.wheel_stone_position > 0 and self.wheel_position - self.wheel_stone_position >= 13
    end
    if (self.grape_enters > 0 && self.wheel_position >= self.grape_enters)
      self.wheel_grape_position = self.wheel_position
    end
    if (self.stone_enters > 0 && self.wheel_position >= self.stone_enters)
      self.wheel_stone_position = self.wheel_position
    end

    if (self.wheel_house_position == self.wheel_position)
      self.age += 1
      case self.age
      when Age::A # A -> B
        self.phase = Phase::SETTLEMENT
        self.turn = 11
        case self.number_of_players
        when 1
          self.wheel_house_position = 17
        when 2
          self.wheel_house_position = 15
        when 3
          if self.is_short_game
            self.wheel_house_position = 6
          else
            self.wheel_house_position = 12
          end
        when 4
          if self.is_short_game
            self.wheel_house_position = 6
          else
            self.wheel_house_position = 11
          end
        end
      when Age::B # B -> C
        self.phase = Phase::SETTLEMENT
        self.turn = 11
        case self.number_of_players
        when 1
          self.wheel_house_position = 23
        when 2
          self.wheel_house_position = 22
        when 3
          if self.is_short_game
            self.wheel_house_position = 8
          else
            self.wheel_house_position = 16
          end
        when 4
          if self.is_short_game
            self.wheel_house_position = 8
          else
            self.wheel_house_position = 17
          end
        end
      when Age::C # C -> D
        self.phase = Phase::SETTLEMENT
        self.turn = 11
        case self.number_of_players
        when 1
          self.wheel_house_position = 27
        when 2
          self.wheel_house_position = 29
        when 3
          if self.is_short_game
            self.wheel_house_position = 10
          else
            self.wheel_house_position = 21
          end
        when 4
          if self.is_short_game
            self.wheel_house_position = 10
          else
            self.wheel_house_position = 20
          end
        end
      when Age::D # D -> E
        self.phase = Phase::SETTLEMENT
        self.turn = 11
        case self.number_of_players
        when 1
          self.wheel_house_position = 33
        when 2
          self.wheel_house_position = 0
        when 3
          if self.is_short_game
            self.wheel_house_position = 14
          else
            self.wheel_house_position = 26
          end
        when 4
          if self.is_short_game
            self.wheel_house_position = 14
          else
            self.wheel_house_position = 26
          end
        end
      when Age::E # Last age
        self.phase = Phase::BONUS
        self.turn = 21
      end
    end

    if card_players == NumberOfPlayers::TWO and age == Age::D and building_cards.length <= 1
      self.phase = Phase::FINALACTION
    end

    for seat in seats
      # In short games, every player gets 2 resources at the start of a new round
      if number_of_players.between?(3, 4) and is_short_game and res_short_game[round]
        seat.add_resource(res_short_game[round][0], 1)
        seat.add_resource(res_short_game[round][1], 1)
        seat.save_all
      end

      if (seat.prior_location_x != 0 && seat.clergy0_location_x != 0 && seat.clergy1_location_x != 0) || 
          self.phase == Phase::BONUS
        seat.prior_location_seat_id = nil
        seat.prior_location_x = seat.prior_location_y = 0
        if self.phase != Phase::BONUS
          seat.clergy0_location_x = seat.clergy0_location_y = 0
          seat.clergy1_location_x = seat.clergy1_location_y = 0 if seat.clergy1_location_x != nil
        end
        seat.save_all

        # TODO:
        # Game should log that this seat's clergy were returned
      end
    end
  end

  def card_players
    case number_of_players
    when 1
      NumberOfPlayers::ONE
    when 2
      if is_short_game
        NumberOfPlayers::TWO
      else
        NumberOfPlayers::TWO_LONG
      end
    when 3
      if is_short_game
        NumberOfPlayers::THREE_SHORT
      else
        NumberOfPlayers::THREE
      end
    when 4
      if is_short_game
        NumberOfPlayers::FOUR_SHORT
      else
        NumberOfPlayers::FOUR
      end
    end
  end

  def res_short_game
    {
      1 => [Resource::LIVESTOCK, Resource::GRAIN],
      2 => [Resource::CLAY, Resource::GRAIN],
      3 => [Resource::WOOD, Resource::GRAIN],
      4 => [Resource::STONE, Resource::GRAIN],
      5 => [Resource::STONE, Resource::PEAT],
      6 => [Resource::STONE, Resource::CLAY],
      7 => [Resource::STONE, Resource::WOOD],
      8 => [Resource::STONE, Resource::COINX5],
      9 => [Resource::STONE, Resource::MEAT],
      10 => [Resource::BOOK, Resource::GRAIN],
      11 => [Resource::CERAMIC, Resource::CLAY],
      12 => [Resource::ORNAMENT, Resource::WOOD]
    }
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
  E = 5
end

class Phase
  NORMAL = 0
  SETTLEMENT = 1
  BONUS = 2
  ENDGAME = 3
  FINALACTION = 4
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

class Resource
  WOOD = 1
  PEAT = 2
  GRAIN = 3
  LIVESTOCK = 4
  CLAY = 5
  COIN = 6
  COINX5 = 7
  STONE = 8
  GRAPES = 9
  MALT = 10
  FLOUR = 11
  WHISKEY = 12
  PEATCOAL = 13
  STRAW = 14
  MEAT = 15
  CERAMIC = 16
  BOOK = 17
  RELIQUERY = 18
  ORNAMENT = 19
  WINE = 20
  BEER = 21
  BREAD = 22
  WONDER = 23
  FUEL = 50
  FOOD = 51
  VP = 52
  CURRENCY = 53
end

class Token
  WOOD = 1
  PEAT = 2
  GRAIN = 4
  LIVESTOCK = 8
  CLAY = 16
  COIN = 32
  JOKER = 64
  GRAPE = 128
  STONE = 256
end