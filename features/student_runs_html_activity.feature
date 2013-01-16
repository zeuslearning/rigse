Feature: Student runs html activity
  In order to use an html activity
  As a student
  I want to "run" the activity

  Background:
    Given the most basic default project
    And a simple activity with a multiple choice exists
    And the student "student" belongs to class "My Class"
    And the activity "simple activity" is assigned to the class "My Class"
  
  @lightweight
  Scenario: Student runs html
    And I login with username: student
    When I follow "run simple activity"
    And I press "Submit"

  @javascript @lightweight
  Scenario: Student runs html and teacher sees recent activity
    And I login with username: student
    When I follow "run simple activity"
    And I choose "Choice 1"
    And I press "Submit"
    And I login with username: teacher
    And I follow "Recent Activity"

