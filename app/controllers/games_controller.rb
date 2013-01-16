class GamesController < ApplicationController

  # This section tells Devise that these actions require a user to be authenticated first
  # Viewing all games and viewing a particular game do not require a user to be signed in
  before_filter :authenticate_user!, :only => [:create, :join, :new, :update]

  helper_method :start_game

  def index
    @current_user = current_user
  	@games = Game.all
    if params[:mine] == 'y'
      @games = @games.delete_if {|game| !game.users.include? current_user}
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def join
    @game = Game.find(params[:id])
    @game.users << current_user
  end

  def update
    @game = Game.find(params[:id])

    # This indicates the current user isn't in the game and is joining it
    if !@game.users.include?(current_user)
      @game.users << current_user
      if @game.users.count == @game.number_of_players
        start_game
        redirect_to game_path(@game)
      end
    end

  end

  def create
    if params[:game][:variant] == GameVariant::IRELAND and params[:game][:use_loamy_landscape]
      params[:game][:use_loamy_landscape] = false
    end

    if params[:game][:number_of_players] == 1
      params[:game][:is_short_game] = false
    end

    @game = Game.new(params[:game])
    if @game.save
      @game.users << current_user

      if @game.users.count == @game.number_of_players
        start_game
      end

      redirect_to game_path(@game)
    else
      flash[:notice] = "We couldn't create your game because you suck"
      render :new
    end
  end

  def new
  	@game = Game.new
  end

  def start_game
    # Game's setup of Plots, Districts, etc.
    district_costs = [2, 3, 4, 4, 5, 5, 6, 7, 8]
    plot_costs = [3, 4, 4, 5, 5, 5, 6, 6, 7]

    @game.age = Age::START
    @game.phase = Phase::NORMAL
    @game.round = 1  # When 'round' is > 0, that means the game has started
    @game.turn = 1

    @game.wheel_position = 1
    @game.wheel_wood_position = 1
    @game.wheel_peat_position = 1
    @game.wheel_grain_position = 1
    @game.wheel_livestock_position = 1
    @game.wheel_clay_position = 1
    @game.wheel_coin_position = 1
    @game.wheel_joker_position = 1

    card_where_clause = {:age => Age::START, :variant => @game.variant}
    case @game.number_of_players
    when 1
      district_costs.reverse!
      plot_costs.reverse!
      @game.wheel_type = WheelType::ONE_TWO_PLAYER
      @game.wheel_house_position = 13
      card_where_clause[:nop] = NumberOfPlayers::ONE
    when 2
      if @game.is_short_game
        @game.wheel_type = WheelType::ONE_TWO_PLAYER
        card_where_clause[:nop] = NumberOfPlayers::TWO
      else
        @game.wheel_type = WheelType::TWO_PLAYER_LONG
        card_where_clause[:nop] = NumberOfPlayers::TWO_LONG
      end
      @game.wheel_house_position = 8
    when 3
      if @game.is_short_game
        @game.wheel_type = WheelType::THREE_FOUR_PLAYER_SHORT
        @game.wheel_house_position = 4
        card_where_clause[:nop] = NumberOfPlayers::THREE_SHORT
      else
        @game.wheel_type = WheelType::THREE_PLAYER
        @game.wheel_house_position = 7
        card_where_clause[:nop] = NumberOfPlayers::THREE
      end
    when 4
      if @game.is_short_game
        @game.wheel_type = WheelType::THREE_FOUR_PLAYER_SHORT
        @game.wheel_house_position = 4
        card_where_clause[:nop] = NumberOfPlayers::FOUR_SHORT
      else
        @game.wheel_type = WheelType::FOUR_PLAYER
        @game.wheel_house_position = 8
        card_where_clause[:nop] = NumberOfPlayers::FOUR
      end
    end
    @game.building_cards = BuildingCard.where(
      'age = :age AND is_base = false AND variant IN (0, :variant) AND (number_players & :nop) = :nop', 
      card_where_clause)

    district_costs.each do |district_cost|
      @game.districts << District.new({:cost => district_cost})
    end

    plot_costs.each do |plot_cost|
      @game.plots << Plot.new({:cost => plot_cost})
    end

    # TODO :: In the single player game, there is a dummy/neutral player
    # that gets set up as well with different stuff.  This needs to be
    # done some way.

    # Set up initial board & resource stuff for the players
    seating = 1.step(@game.number_of_players).to_a.shuffle
    @game.seats.each do |seat|
      seat.number = seating[@game.seats.index(seat)]

      if @game.number_of_players.between?(3, 4) and @game.is_short_game
        seat.tile00 = BuildingCard.where(:key => 'R02').first
        seat.tile01 = BuildingCard.where(:key => 'R01').first
      end

      seat.tile02 = BuildingCard.where(:key => 'R01').first
      seat.tile04 = BuildingCard.where(:key => 'H01').first
      seat.tile10 = BuildingCard.where(:key => 'R02').first
      seat.tile11 = BuildingCard.where(:key => 'R01').first
      seat.tile12 = BuildingCard.where(:key => 'H02').first
      seat.tile14 = BuildingCard.where(:key => 'H03').first

      seat.settlement0 = BuildingCard.where(:key => 'S01').first
      seat.settlement1 = BuildingCard.where(:key => 'S02').first
      seat.settlement2 = BuildingCard.where(:key => 'S03').first
      seat.settlement3 = BuildingCard.where(:key => 'S04').first

      if @game.number_of_players != 1
        seat.res_peat = 1
        seat.res_livestock = 1
        seat.res_grain = 1
        seat.res_wood = 1
        seat.res_clay = 1
        seat.res_coin = 1
      end

      seat.save
    end

    @game.save
  end
end
