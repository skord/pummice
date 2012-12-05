require 'spec_helper'

describe GamesController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      @game = FactoryGirl.create(:game)
      get 'show', :id => @game.id
      response.should be_success
    end
  end

  describe "POST 'join'" do
    it "returns http success" do
      game = FactoryGirl.create(:game)
      post 'join', :id => game.id
      game.users.include?(@user).should be_true
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

end
