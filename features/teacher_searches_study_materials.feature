Feature: Teacher can search study materials

  As a teacher
  I should be able to search study materials
  In order to find suitable study materials for the class
  
  Background:
    Given The default project and jnlp resources exist using factories
    And the following teachers exist:
      | login    | password | first_name   | last_name |
      | teacher  | teacher  | John         | Nash      |
    And the following users exist:
      | login  | password | roles          |
      | author | author   | member, author |
    And the following classes exist:
      | name        | teacher    | class_word |
      | Physics     | teacher    | phy        |
      | Chemistry   | teacher    | chem       |
      | Mathematics | teacher    | math       |
      | Biology     | teacher    | bio        |
      | Geography   | teacher    | geo        |
    And the search data exists
    And I login with username: teacher password: teacher
    And I am on the search instructional materials page"
    
    
  @javascript
  Scenario: Teacher can filter search results
    Then I should be able to filter the search results on the basis of domains and grades on the search instructional materials page
    And I should be able to filter the search results on the basis of probes on the search instructional materials page
    
    
  Scenario: Anonymous user can not assign study materials to the class
    When I log out
    And I go to the search instructional materials page
    Then I should not be able to assign materials on the search instructional materials page
    
    
  Scenario: Anonymous user can preview
    When I log out
    And I go to the search instructional materials page
    Then I preview materials on the search instructional materials page
    
    
  @javascript
  Scenario: Teacher can sort search/filter results
    Then I should be able to sort search and filter results on the search instructional materials page
    
    
  @javascript
  Scenario: Teacher can see search suggestions
    When I enter search text "Radioactivity" on the search instructional materials page
    Then I should see search suggestions for "Radioactivity" on the search instructional materials page
    
    
  @javascript
  Scenario: Teacher can search study materials
    When I search study material "Venn Diagram" on the search instructional materials page
    Then I should see search results for "Venn Diagram" on the search instructional materials page
    
    
  @javascript
  Scenario: Teacher can group search study materials
    Then I should be able to see grouped search results on the search instructional materials page
    
    
  @javascript
  Scenario: Search results should be paginated
    When the count of a search result is greater than the page size on the search instructional materials page
    Then the search results should be paginated on the search instructional materials page
    
    
  @javascript
  Scenario: Teacher can assign investigations and activites to a class
    Then I can assign investigations and activities to a class on the search instructional materials page
    
    
  Scenario: Teacher can preview investigations
    Then I can preview investigations on the search instructional materials page
    
    
  Scenario: Teacher can preview activities
    Then I can preview activities on the search instructional materials page
    
    
  @javascript
  Scenario: Teacher can see number classes to which instructional materials are assigned
    Then I should be able to see number classes to which instructional materials are assigned on the search instructional materials page
    
    