Feature: User management
  Background:
    Given I am admin user

  Scenario: I create user
    When I create new user
    Then I should see user in the list

  Scenario: I edit user
    Given a user exists
    When I edit user
    Then I should see user in the list

  Scenario: I delete user
    Given a user exists
    When I delete user
    Then I should not see user in the list
