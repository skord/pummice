class GamesController < ApplicationController
  def index
  	@games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def join
  end

  def create
    @game = Game.new(params[:game])
    if @game.save
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
