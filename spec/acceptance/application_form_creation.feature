Feature: Creating application forms
  Background:
    Given I am eligible user

  Scenario: I see application links on dashboard
    When I go to dashboard
    Then I should see innovation application link 
    And I should see international trade application link 
    And I should see sustainable development application link 

  Scenario: I'm able to create innovation form
    When I create innovation form
    Then I should see qae form
    And I should see application edit link on dashboard

  Scenario: I'm able to create international trade form
    When I create international trade form
    Then I should see qae form
    And I should see application edit link on dashboard

  Scenario: I'm able to create sustainable development form
    When I create sustainable development form
    Then I should see qae form
    And I should see application edit link on dashboard
