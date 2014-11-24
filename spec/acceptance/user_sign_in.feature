Feature: User Sign in
  Background:
    Given a user exists

  Scenario: I'm able to sign in
    When I sign in as user
    Then I should see sign out link
