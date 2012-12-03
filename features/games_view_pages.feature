Feature: View pages
  In order to verify that different users can see the correct pages
  An un-signed-in user
  Should be able to see certain pages

  Scenario: Signed out user tries to create a new game
    Given I am not logged in
    When I visit the games/new page
    Then I should see the sign in page

  Scenario: Signed out user tries to join a game
    Given I am not logged in
    When I visit the games/join page
    Then I should see the sign in page

  Scenario: Signed in user creates a new game successfully
    Given I am logged in
    When I visit the games/new page
    Then I should see the new game page
    When I create a new game
    Then I should see the game page

  Scenario: Signed in user joins a game successfully
    Given I am logged in
    When I visit the games/join page
    Then I should see the join game page