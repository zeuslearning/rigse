Feature: Teacher reorders materials assigned to the class
  In order to present materials in a logical order to students
  the teacher
  should be able reorder them 

  Background:
    Given The default project and jnlp resources exist using factories
    And the data for test exists
    And  the teachers "teacher , albert" are in a school named "VJTI"
    And the classes "class_with_no_students" are in a school named "VJTI"
    And the student "student" belongs to class "class_with_no_students"

  @javascript
  Scenario: Teacher reorders materials and students sees them in the correct order
    Given the following assignments exist:
      | type          | name                       | class                     |
      | investigation | Lumped circuit abstraction | class_with_no_students    |
      | investigation | Static discipline          | class_with_no_students    |
      | investigation | Non Linear Devices         | class_with_no_students    |
    When I am logged in with the username teacher
    And I am on the class edit page for "class_with_no_students"
    And I move investigation named "Non Linear Devices" to the top of the list
    And I press "Save"
    When I login with username: student
    And I follow "class_with_no_students"
    And I should see "Lumped circuit abstraction"
    And I should see "Non Linear Devices"
    And I should see "Static discipline"
    And the first investigation in the list should be "Non Linear Devices"

  @javascript
  Scenario: Teacher reorders materials with the default class feature enabled
    Given the default class is created
    And the following assignments exist:
      | type          | name                       | class                     |
      | investigation | Lumped circuit abstraction | class_with_no_students    |
      | investigation | Static discipline          | class_with_no_students    |
      | investigation | Non Linear Devices         | class_with_no_students    |
    And I am logged in with the username teacher
    When I am on the class page for "class_with_no_students"
    And the Investigation "Lumped circuit abstraction" is assigned to the class "class_with_no_students"
    And the Investigation "Static discipline" is assigned to the class "class_with_no_students"
    And the Investigation "Non Linear Devices" is assigned to the class "class_with_no_students"
    And I am on the class edit page for "class_with_no_students"
    And I move investigation named "Non Linear Devices" to the top of the list
    And I press "Save"
    When I login with username: student
    And I follow "class_with_no_students"
    And I should see "Lumped circuit abstraction"
    And I should see "Non Linear Devices"
    And I should see "Static discipline"
    And the first investigation in the list should be "Non Linear Devices"
