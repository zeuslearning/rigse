Given /^the data for test exists$/ do
  step "the following teachers exist:", table(%{
      | login   | password | first_name | last_name |
      | teacher | teacher  | John       | Nash      |
      | albert  | albert   | Albert     | Fernandez |
      | robert  | robert   | Robert     | Fernandez |
      | peterson | teacher| peterson    | gaurav    |
      | teacher_with_no_class | teacher_with_no_class | teacher_with_no_class  | teacher_with_no_class  |
      })
  step "And the following users exist:",table(%{
     | login      | password   | roles    |
     | author     | author     | member, author |
     | myadmin    | myadmin    | admin          |
     | manager    | manager    | manager        |
     | mymanager  | mymanager  | manager        |
     | researcher | researcher | researcher     |
     | admin      | admin      | admin          |
     })
  step "the following classes exist:", table(%{
    | name     | teacher |
    | My Class | teacher |
    | Physics    | teacher |
    | Mathematics | teacher |
    | Chemistry   | teacher |
    | Biology     | teacher |
    | Geography   | teacher | 
    | Mechanics   | teacher |
    | Biology     | albert  |
    | class_with_no_assignment | peterson|
    | class_with_no_assignment | teacher |
    | class_with_no_students   | teacher |
    | class_with_no_students   | albert |
    | class_with_no_attempts   | teacher |
    })
  step "the following students exist:", table(%{
      | login     | password  |first_name  | last_name |
      | student   | student   |  Alfred    | Robert|
      | dave      | student   | Dave       | Doe       |
      | chuck     | student   | Chuck      | Smith     |
      | gaurav    | student   | Gaurav     | Donald    |
      | Mache     | student   | Mache      | Smith     |
      | shon      | student   | shon       | done      |
      | ankur     | student   | ankur      | gaurav    |
      | monty     | student   | Monty      | Donald    |
      | Switchuser| Switchuser| Joe        | Switchuser   |
      })
  step "the following multiple choice questions exists:",table(%{
      | prompt | answers | correct_answer |
      | a      | a,b,c,d | a              |
      | b      | a,b,c,d | a              |
      | c      | a,b,c,d | a              |
      | d      | a,b,c,d | a              |
      | e      | a,b,c,d | a              |
      | f      | a,b,c,d | a              |
      })
  step 'there is an image question with the prompt "image_q"'
  step "the following offerings exist", table(%{
      | name                       | class       |
      | Lumped circuit abstraction | Mathematics |
      | Static discipline          | Mathematics |
      | Non Linear Devices         | Mathematics |
      })
  step "the following empty investigations exist:", table(%{
        | name                    | user    | offerings_count | publication_status |
        | draft g                 | teacher | 5               | draft              |
        | b Investigation         | teacher | 5               | published          |        
        | a Investigation         | teacher | 5               | published          |
        | c Investigation         | teacher | 5               | published          |
        | d Investigation         | teacher | 5               | published          |
        | e Investigation         | teacher | 5               | published          |
        | f Investigation         | teacher | 5               | published          |
      })
  step "the following empty investigations exist:", table(%{
      | name    | user      | offerings_count | created_at                      | publication_status  |
      | NewestInv  | teacher   | 5               | Wed Jan 26 12:00:00 -0500 2011  | published           |
      | MediumInv  | teacher   | 10              | Wed Jan 23 12:00:00 -0500 2011  | published           |
      | OldestInv  | teacher   | 20              | Wed Jan 20 12:00:00 -0500 2011  | published           |
      })
  step "the following linked investigations exist:", table(%{
      | name         | user   | offerings_count | created_at                     | publication_status |
      | WithLinksInv | author | 5               | Wed Jan 25 12:00:00 -0500 2011 | published          |
      })
  step "the following simple investigations exist:", table(%{
      | name                   | user   | publication_status | description                                     |
      | Radioactivity          | author | published          | Nuclear Energy is a great subject               |
      | Set Theory             | author | published          | Set Theory is a great subject                   |
      | Mechanics              | author | published          | Mechanics is a great subject                    |
      | Geometry               | author | published          | Triangle is a great subject                     |
      | integral calculus      | author | published          | integral calculus is a great subject            |
      | differential calculus  | author | published          | differential calculus is a great subject        |
      | differential equations | author | published          | differential equations is a great subject       |
      | organic chemistry      | author | published          | organic chemistry is a great subject            |
      | inorganic chemistry    | author | published          | inorganic chemistry is a great subject          |
      | graph theory           | author | published          | graph theory is a great subject                 |
      | investigaion_not_assigned           | author | published          | investigaion_not_assigned is a great subject                 |
      | testing fast cars      | author | published          | how fast can cars go?                           |
      })
  step "the following investigations with multiple choices exist:", table(%{
      | investigation      | activity       | section   | page   | multiple_choices | image_questions | user      | activity_teacher_only |
      | Plant reproduction | Plant activity | section b | page 2 | b                | image_q         | teacher   | false                  |
      | Aerodynamics       | Air activity   | section c | page 3 | c                | image_q         | teacher   | false                  |
      | Aerodynamics       | Aeroplane      | section d | page 4 | d                | image_q         | teacher   | true                   |
      | Arithmatics        | Algebra        | section a | page 1 | a                | image_q         | teacher   | false                  |
      | Radioactivity      | Radio activity | section a | page 1 | a                | image_q         | teacher   | false                 |
      | Radioactivity      | Nuclear Energy | section b | page 2 | b                | image_q         | teacher   | false                 |
      | Electricity        | current        | section b | page 2 | b                | image_q         | teacher   | false                 |
      })
  step "the following activities for the above investigations exist:", table(%{
      | name                        | investigation | user    | publication_status | description                            |
      | Radioactive decay           | Radioactivity | author  | published          | Nuclear Energy is a great material     |
      | Gamma Rays                  | Radioactivity | author  | published          | Gamma Rays is a great material         |
      | Venn Diagram                | Set Theory    | author  | published          | Venn Diagram is a great material       |
      | operations on sets          | Set Theory    | author  | published          | operations on sets is a great material |
      | Fluid Mechanics             | Mechanics     | author  | published          | Fluid Mechanics is a great material    |
      | Circular Motion             | Mechanics     | author  | published          | Circular Motion is a great material    |
      | Geometry                    | Geometry      | author  | published          | Triangle is a great material           |
      | intersecting lines          | Geometry      | author  | published          | intersecting lines is a great material |
      | parallel lines              | Geometry      | author  | published          | parallel lines is a great material     |
      | graphs and lines            | Geometry      | author  | published          | parallel lines is a great material     |
      | circles                     | Geometry      | author  | published          | circles is a great material            |
      | boolean algebra             | Geometry      | author  | published          | boolean algebra is a great material    |
      | Quantum Mechanics           | Mechanics     | author  | published          | Quantum Mechanics is a great material  |
      | Atmosphere                  | Aerodynamics  | author  | published          | Atmosphere is a great material    |
      })
  step "the following activities with multiple choices exist:", table(%{
    | activity | section   | page   | multiple_choices | image_questions | user      | activity_teacher_only |
    | Algebra  | section a | page 6 | f                | image_q         | teacher   | false                 |
    })
  step "the following external activity exists:", table(%{
    | name        | user    | url               |
    | My Activity | teacher | /mock_html/test-exernal-activity.html |
    })
  step 'the student "student" belongs to class "My Class"'
  step 'the student "student" belongs to class "class_with_no_assignment"'
  step 'the student "student" belongs to class "class_with_no_attempts"'
  step 'the student "dave" belongs to class "My Class"'
  step 'the student "chuck" belongs to class "My Class"'
  step 'the student "gaurav" belongs to class "My Class"'
  step 'the student "Mache" belongs to class "Physics"'
  step 'the student "chuck" belongs to class "Physics"'
  step 'the student "chuck" belongs to class "Mechanics"'
  step 'the student "shon" belongs to class "Physics"'
  step 'the student "ankur" belongs to class "Physics"'
  step 'the student "gaurav" belongs to class "Mathematics"'
  
  step "the following assignments exist:", table(%{
      | type          | name                 | class       |
      | investigation | Aerodynamics         | My Class    |
      | investigation | Plant reproduction   | My Class    |
      | investigation | Radioactivity        | My Class    |
      | investigation | Electricity          | Physics     |
      | investigation | Plant reproduction   | Physics     |
      | investigation | Aerodynamics         | Physics     |
      | investigation | Radioactivity        | Physics     |
      | investigation | Aerodynamics         | Mechanics   |
      | investigation | Aerodynamics         | class_with_no_attempts |
      | investigation | Plant reproduction   | class_with_no_students |
      })
      
  step "the following assignments exist:", table(%{
      | type          | name                 | class       |
      | activity      | Algebra              | Physics     |
      | activity      | Algebra              | My Class    |
      })
  step 'the Investigation "Aerodynamics" is assigned to the class "class_with_no_students"'
  step "the following student answers:", table(%{
      | student   | class         | investigation       | question_prompt | answer |
      | dave      | My Class      | Radioactivity       | a               | a      |
      })
  step "the following student answers:", table(%{
      | student   | class         | activity             | question_prompt | answer |
      | gaurav    | My Class      | Algebra              | f               | a      |
      | chuck     | My Class      | Algebra              | f               | a      |
      })
end
