Feature: Admin Sign in
  Background:
    Given Admin user exists

  Scenario: I'm able to sign in
    When I sign in as admin
    Then I should see sign out link
