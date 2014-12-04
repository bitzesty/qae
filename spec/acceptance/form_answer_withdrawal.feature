Feature: Form Answer withdrawal
  Background:
    Given I am admin user

  Scenario: I withdraw form answer
    Given a form answer exists
    When I withdraw form answer
    Then form answer should be withdrawn

  Scenario: I restore form answer
    Given a withdrawn form answer exists
    When I restore form answer
    Then form answer should not be withdrawn
