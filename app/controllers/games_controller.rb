class GamesController < ApplicationController

  # This section tells Devise that these actions require a user to be authenticated first
  # Viewing all games and viewing a particular game do not require a user to be signed in
  before_filter :authenticate_user!, :only => [:create, :join, :new]

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

      # This is just temporary until the Start verb gets completed.
      # The Start verb should set up each Seat's Heartland along with the
      # Game's setup of Plots, Districts, etc.
      @current_user_seat = @game.seats.first
      @current_user_seat.tile00 = BuildingCard.where("key = 'R02'")[0]
      @current_user_seat.tile10 = BuildingCard.where("key = 'R02'")[0]
      @current_user_seat.tile01 = BuildingCard.where("key = 'R01'")[0]
      @current_user_seat.tile11 = BuildingCard.where("key = 'R01'")[0]
      @current_user_seat.tile02 = BuildingCard.where("key = 'R01'")[0]
      @current_user_seat.tile12 = BuildingCard.where("key = 'H02'")[0]
      @current_user_seat.tile04 = BuildingCard.where("key = 'H01'")[0]
      @current_user_seat.tile14 = BuildingCard.where("key = 'H03'")[0]
      @current_user_seat.save

      redirect_to game_path(@game)
    else
      flash[:notice] = "We couldn't create your game because you suck"
      render :new
    end
  end

  def new
  	@game = Game.new
  end
end
