Feature: An copies and pastes embeddables
  As a Investigations author
  I want to copy and paste embeddables
  So that I can create investigations more quickly

  Background:
    Given The default project and jnlp resources exist using factories
    And the data for test exists

  @dialog
  @javascript
  Scenario: The author copies and pastes an embeddable by clicking on the embeddable content
    And I am logged in with the username author
    When I go to the first page of the "Set Theory" investigation
    And I add a "Text" to the page
    Then I should see "content goes here ..."
    When I copy the embeddable "Text: content goes here ..." by clicking on the content
    Then I should see "paste Text: content goes here ..."
    When I paste the embeddable "Text: content goes here ..."
    And I wait 1 second
    Then I should see "Text: content goes here ..." 2 times

  @dialog
  @javascript
  Scenario: The author copies and pastes an embeddable by clicking on the embeddable title
    And I am logged in with the username author
    When I go to the first page of the "Set Theory" investigation
    And I add a "Text" to the page
    Then I should see "content goes here ..."
    When I copy the embeddable "Text: content goes here ..." by clicking on the title
    Then I should see "paste Text: content goes here ..."
    When I paste the embeddable "Text: content goes here ..."
    And I wait 1 second
    Then I should see "Text: content goes here ..." 2 times
