Feature: Investigation index pages can be printed
  So I can take investigation data with me
  As a teacher
  I want to print the investigation index page

  Background:
    Given The default project and jnlp resources exist using factories
    And the data for test exists
    
    
  @pending
  Scenario: Teacher prints the listing of all investigations with usage counts
    When I am on the investigations page
    Then I should see "b Investigation"
    And I should see "a Investigation"
    And I should see "c Investigation"
    And I should see "printable view"
    And "printable-view" should have href like "printable_index"
    And the link to "printable-view" should have a target "_blank"
    When show usage count is enabled on the session
    And I am on the investigations printable index page
    Then I should see "Investigation"
    And I should see "Usage Count"
    And I should see "b Investigation"
    And I should see "a Investigation"
    And I should see "c Investigation"

  Scenario: Teacher prints the listing of all investigations
    When I am on the investigations page
    Then I should see "b Investigation"
    And I should see "a Investigation"
    And I should see "c Investigation"
    And I should see "printable view"
    And "printable-view" should have href like "printable_index"
    And the link to "printable-view" should have a target "_blank"
    When I am on the investigations printable index page
    Then I should see "Investigation"
    And I should see "b Investigation"
    And I should see "a Investigation"
    And I should see "c Investigation"

  Scenario: Teacher prints the listing of a subset of investigations
    When I am on the investigations like "New" page
    Then I should see "b Investigation"
    And I should not see "a Investigation"
    And I should not see "c Investigation"
    And I should see "printable view"
    And "printable-view" should have href like "printable_index" with params "name=New"
    And the link to "printable-view" should have a target "_blank"
    When I am on the investigations printable index page
    Then I should see "Investigations"
    And I should see "b Investigation"
    And I should not see "a Investigation"
    And I should not see "c Investigation"
