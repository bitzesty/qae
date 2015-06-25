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

  Scenario: I do resend confirmation instructions for user as admin
    Given I am admin user
    And a user exists
    And a not confirmed user exists
    When I am on confirmed user page
    Then I dont see resend confirmation link
    When I am on not confirmed user page
    Then I see resend confirmation link
    When I do resend confirmation instructions
    And I should see flash message about confirmation email sending
