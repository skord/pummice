Feature: Edit profile
  In order to maintain updated-ness
  A user
  Should be able to modify their user settings

    Background:
      Given I exist as a user

    Scenario: User is not logged in
      Given I am not logged in
      When I go to the edit screen
      Then I should be on the sign-in page

    Scenario: User modifies fields validly
      Given I am logged in
      When I change my profile
      Then I should see an account edited message

    Scenario: User enters wrong current password
      Given I am logged in
      When I change my profile with incorrect password
      Then I should see an account saving error

    Scenario: User enters an existing firstname & lastname
      Given I am logged in
      When I change my profile to an existing user
      Then I should see an account saving error

    Scenario: User enters an existing email address
      Given I am logged in
      When I change my profile to an existing email address
      Then I should see an account saving error
