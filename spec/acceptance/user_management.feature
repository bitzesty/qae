Feature:  User management
  Scenario: I create user as admin
    Given I am admin user
    When I create new user
    Then I should see user in the list

  Scenario: I edit user as admin
    Given I am admin user
    And a user exists
    When I edit user
    Then I should see user in the list

  Scenario: I delete user as admin
    Given I am admin user
    And a user exists
    When I delete user
    Then I should not see user in the list

  Scenario: I create user as account admin
    Given I am account admin user
    When I create new user
    Then I should see user in the list

  Scenario: I edit user as account admin
    Given I am account admin user
    And an account user exists
    When I edit user
    Then I should see user in the list

  Scenario: I delete user as account admin
    Given I am account admin user
    And an account user exists
    When I delete user
    Then I should not see user in the list
