require 'spec_helper'

describe Game do

  context "relationships" do
    it "should accept new users" do
      @user = FactoryGirl.create(:user)
      @game = FactoryGirl.create(:game)
      @game.users << @user
      @game.users.should eq [@user]
    end
    it "should accept no more than four users" do
      @game = FactoryGirl.create(:game)
      5.times do
        @game.users << FactoryGirl.create(:user)
      end
      @game.should_not be_valid
    end
  end
end
