class GamesController < ApplicationController

  # This section tells Devise that these actions require a user to be authenticated first
  # Viewing all games and viewing a particular game do not require a user to be signed in
  before_filter :authenticate_user!, :only => [:create, :join, :new]

  def index
  	@games = Game.all
    @current_user = current_user
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
