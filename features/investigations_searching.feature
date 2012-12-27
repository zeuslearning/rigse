Feature: Investigations can be searched
  So I can find an investigation more efficiently
  As a teacher
  I want to sort the investigations list

  Background:
    Given The default project and jnlp resources exist using factories
    And the data for test exists
    Given I am logged in with the username teacher
    
    
  @javascript 
  Scenario: Default display of public investigations is name ASC
    When I browse public investigations
    Then There should be 20 investigations displayed
    And  "testing fast cars" should not be displayed in the investigations list
    And  "a Investigation" should appear before "b Investigation"
    
  @javascript
  Scenario: Changing the sort order
    When I sort investigations by "name DESC"
    Then There should be 20 investigations displayed
    And  "testing fast cars" should appear before "Radioactivity"
    
  @javascript
  Scenario: Searching public investigations
    When I sort investigations by "name ASC"
    And I click on the next page of results
    Then There should be 2 investigations displayed
    And  "a Investigation" should not be displayed in the investigations list
    And  "testing fast cars" should appear before "WithLinksInv"
    
  @javascript
  Scenario:  browsing unpublished investigations
    When I browse draft investigations
    And I click on the next page of results
    Then There should be 10 investigations displayed
    And "testing fast cars" should be displayed in the investigations list
    
  @javascript
  Scenario: searching unpublished investigations
    When I browse draft investigations
    And I enter "draft" in the search box
    And I wait for all pending requests to complete
    Then every investigation should contain "draft"
    