### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :email => "example@example.com",
    :lastname => "example", :firstname => "me",
    :password => "please", :password_confirmation => "please", :current_password => "please",
    :timezone => "(GMT+00:00) UTC" }
end

def create_site_user
  @site_user ||= User.create({email: 'me@my.net', lastname: "my", first: "me", password: 'password', password_confirmation: 'password', timezone: "UTC"})
end

def find_site_user
  @site_user ||= User.where(email: @site_user[:email]).first
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/users/sign_out'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user,
                             firstname: @visitor[:firstname],
                             lastname: @visitor[:lastname],
                             email: @visitor[:email],
                             timezone: @visitor[:timezone][12..-1],
                             last_sign_in_ip: "127.0.0.1")
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def create_visitor2
  @visitor2 ||= { :email => "example2@example.com",
    :lastname => "example2", :firstname => "me2",
    :password => "please2", :password_confirmation => "please2", :current_password => "please2",
    :timezone => "(GMT+00:00) UTC" }
end

def create_user2
  create_visitor2
  delete_user2
  @user2 = FactoryGirl.create(:user,
                             firstname: @visitor2[:firstname],
                             lastname: @visitor2[:lastname],
                             email: @visitor2[:email],
                             timezone: @visitor2[:timezone][12..-1],
                             last_sign_in_ip: "127.0.0.1")
end

def delete_user2
  @user2 ||= User.where(:email => @visitor2[:email]).first
  @user2.destroy unless @user2.nil?
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Lastname", :with => @visitor[:lastname]
  fill_in "Firstname", :with => @visitor[:firstname]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  select @visitor[:timezone], :from => "Timezone"
  click_button "Sign up"
  find_user
end

def sign_in
  visit '/users/sign_in'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign in"
end

def edit_user
  visit '/users/edit'
  fill_in "Email", :with => @visitor[:email]
  fill_in "Lastname", :with => @visitor[:lastname]
  fill_in "Firstname", :with => @visitor[:firstname]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  select @visitor[:timezone], :from => "Timezone"
  fill_in "user_current_password", :with => @visitor[:current_password]
  click_button "Update"
  find_user
end

### GIVEN ###
Given /^I click "(.*?)"$/ do |text|
  click_link text
end

Given /^I am on the root page$/ do
  visit "/"
end

Given /^I am not logged in$/ do
  visit '/users/sign_out'
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^Another user exists$/ do
  create_user2
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^a user$/ do
  @user = create_user
end

Given /^another user$/ do
  @user = create_user2
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "please123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I go to the edit screen$/ do
  visit '/users/edit'
end

When /^I change my profile$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "yser@email.com", 
                            :lastname => "Email", 
                            :firstname => "User", 
                            :password => "sdaf666", 
                            :password_confirmation => "sdaf666", 
                            :timezone => "(GMT+00:00) UTC")
  edit_user
end

When /^I change my profile with incorrect password$/ do
  create_visitor
  @visitor = @visitor.merge(:current_password => "wrongpass")
  edit_user
end

When /^I change my profile to an existing user$/ do
  create_user2
  create_visitor
  create_visitor2
  @visitor = @visitor.merge(:firstname => @visitor2[:firstname], :lastname => @visitor2[:lastname])
  edit_user
end

When /^I change my profile to an existing email address$/ do
  create_user2
  create_visitor
  create_visitor2
  @visitor = @visitor.merge(:email => @visitor2[:email])
  edit_user
end

### THEN ###

Then /^I should be signed in$/ do
  page.should have_content "Sign out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Sign in"
  page.should_not have_content "Sign out"
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see an account saving error$/ do
  page.should have_content "prohibited this user from being saved:"
end

Then /^I should be on the root page$/ do
  page.current_path.should == "/"
end

Then /^I should be on the sign\-in page$/ do
  page.current_path.should eq new_user_session_path
end

Then /^I should be on the user page$/ do
  page.current_path.should eq user_path(@user)
end