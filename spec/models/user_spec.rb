require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user)}
  let(:game) { FactoryGirl.create(:game)}
  context "validations" do
    it "should require a first name" do
      user.firstname = nil
      user.should_not be_valid
    end
    it "should require a last name" do
      user.lastname = nil
      user.should_not be_valid
    end
    it "should require a unique first and last name combination" do
      user.firstname = 'joe'
      user.lastname = 'blow'
      user.save
      user2 = FactoryGirl.build(:user, firstname: 'joe', lastname: 'blow')
      user2.should_not be_valid
    end

  end
  context "associations" do
    it "should know about its games" do
      user.games << game
      user.games.should eq [game]
    end
  end
end
