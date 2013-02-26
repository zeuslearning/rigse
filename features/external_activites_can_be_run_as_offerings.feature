Feature: External Activities can be run as offerings

  As a student
  I want to run an External Activity that has been assigned to me

  Background:
    Given The default project and jnlp resources exist using factories
    And the following external activity exists:
      | name        | user    | url               |
      | My Activity | teacher | /mock_html/test-exernal-activity.html |

  @javascript
  Scenario: External Activity offerings are runnable
    Given the student "student" belongs to class "My Class"
    And the external activity "My Activity" is assigned to the class "My Class"
    And I am logged in with the username student
    When I go to my home page
    And follow "Run by Myself"
    Then I should be on /mock_html/test-exernal-activity.html
