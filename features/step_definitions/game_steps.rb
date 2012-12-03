### UTILITY METHODS ###

def create_visitor_game
  @visitor_game ||= { :name => "My game" }
end

def create_new_game
  visit '/games/new'
  fill_in "Name", :with => @visitor_game[:name]
  click_button "Create Game"
  find_game
end

def find_game
  @game ||= Game.where(:name => @visitor_game[:name]).first
end

### WHEN ###
When /^I visit the games\/new page$/ do
  visit '/games/new'
end

When /^I visit the games\/join page$/ do
  visit '/games/join'
end

When /^I create a new game$/ do
  create_visitor_game
  create_new_game
end

### THEN ###

Then /^I should see the sign in page$/ do
  page.should have_content "Sign up"
  page.should have_content "Sign in"
  page.should_not have_content "Sign out"
  page.should_not have_content "Create new game"
end

Then /^I should see the new game page$/ do
  page.should have_content "Sign out"
  page.should have_content "Create new game"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end

Then /^I should see the join game page$/ do
  page.should have_content "Sign out"
  page.should have_content "Joined game"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end

Then /^I should see the game page$/ do
  page.should have_content @visitor_game[:name]
  page.should have_content "All Games"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end
