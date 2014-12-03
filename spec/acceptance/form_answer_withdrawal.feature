Feature: Form Answer withdrawal
  Background:
    Given I am admin user
    Given a form answer exists

  Scenario: I withdraw form answer
    When I withdraw form answer
    Then form answer should be withdrawn

  Scenario: I restore form answer
    Given a form answer is withdrawn
    When I restore form answer
    Then form answer should not be withdrawn
