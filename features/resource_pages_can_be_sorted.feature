Feature: Resource Pages can be sorted
  So I can find a resource page more efficiently
  As a teacher
  I want to sort the resource pages list
  
  Background:
    Given The default project and jnlp resources exist using factories
    And I am logged in with the username teacher
        
  @javascript
  Scenario: The resource pages list can be sorted by name
    When I sort resource pages by "name ASC"
    Then "MediumResource" should appear before "NewestResource"
    And "NewestResource" should appear before "OldestResource"

  @javascript
  Scenario: The resource pages list can be sorted by date created
    When I sort resource pages by "created_at DESC"
    Then "NewestResource" should appear before "MediumResource"
    And "MediumResource" should appear before "OldestResource"

  @javascript
  Scenario: The resource pages list can be sorted by offerings count
    When I sort resource pages by "offerings_count DESC"
    Then "OldestResource" should appear before "MediumResource"
    And "MediumResource" should appear before "NewestResource"
