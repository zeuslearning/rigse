Given /^the data for test exists$/ do
  step "the following semesters exist:", table(%{
      | name     | start_time          | end_time            |
      | Fall     | 2012-12-01 00:00:00 | 2012-03-01 23:59:59 |
      | Spring   | 2012-10-10 23:59:59 | 2013-03-31 23:59:59 |
      })
  step "the following teachers exist:", table(%{
      | login   | password | first_name | last_name |email               |
      | teacher | teacher  | John       | Nash      |bademail@noplace.com|
      | albert  | albert   | Albert     | Fernandez |bademail@noplace2.com|
      | robert  | robert   | Robert     | Fernandez |bademail@noplace3.com|
      | jonson   | teacher  | Jonson    | Jackson  |bademail@noplace3.com|
      | peterson | teacher| peterson    | taylor    |bademail@noplace4.com|
      | teacher_with_no_class | teacher_with_no_class | teacher_with_no_class  | teacher_with_no_class  |bademail@noplace5.com|
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
    | name     | teacher | class_word |
    | My Class | teacher | My Class|
    | Physics    | teacher | phy|
    | Mathematics | teacher |math |
    | Chemistry   | teacher |chem|
    | Biology     | teacher |bio|
    | Geography   | teacher |geo|
    | Mechanics   | teacher |Mec|
    | class_with_no_assignment | teacher |class_with_no_assignment|
    | class_with_no_students   | teacher |class_with_no_students|
    | class_with_no_attempts   | teacher |class_with_no_attempts|
    })
    step "the following teacher and class mapping exists:", table(%{
      | class_name  | teacher  |
      | Biology     | albert   |
      | class_with_no_assignment     | peterson |
      | class_with_no_students       | albert |
      | My Class       | peterson |
      
      })
  step "the following students exist:", table(%{
      | login     | password  |first_name  | last_name    |email                   |
      | student   | student   |  Alfred    | Robert       |student@mailinator.com  |
      | dave      | student   | Dave       | Doe          |student@mailinator1.com |
      | chuck     | student   | Chuck      | Smith        |student@mailinator2.com |
      | taylor    | student   | taylor     | Donald       |student@mailinator3.com |
      | Mache     | student   | Mache      | Smith        |student@mailinator4.com |
      | shon      | student   | shon       | done         |student@mailinator5.com |
      | ross      | student   | ross       | taylor       |student@mailinator6.com |
      | monty     | student   | Monty      | Donald       |student@mailinator7.com |
      | Switchuser| Switchuser| Joe        | Switchuser   |student@mailinator8.com |
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
  step "the following resource pages exist:",table(%{
      | name            | user      | offerings_count | created_at                      | publication_status  |
      | NewestResource  | teacher   | 6               | Wed Jan 26 12:00:00 -0500 2011  | published           |
      | MediumResource  | teacher   | 11              | Wed Jan 23 12:00:00 -0500 2011  | published           |
      | OldestResource  | teacher   | 21              | Wed Jan 20 12:00:00 -0500 2011  | published           |
      })
  step "the following page exists:", table(%{
      | name    | user    | publication_status |
      | My Page | teacher | published          |
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
  step 'the teachers "teacher , albert" are in a school named "VJTI"'
  step 'the student "student" belongs to class "My Class"'
  step 'the student "student" belongs to class "class_with_no_assignment"'
  step 'the student "student" belongs to class "class_with_no_attempts"'
  step 'the student "dave" belongs to class "My Class"'
  step 'the student "chuck" belongs to class "My Class"'
  step 'the student "taylor" belongs to class "My Class"'
  step 'the student "Mache" belongs to class "Physics"'
  step 'the student "chuck" belongs to class "Physics"'
  step 'the student "chuck" belongs to class "Mechanics"'
  step 'the student "shon" belongs to class "Physics"'
  step 'the student "ross" belongs to class "Physics"'
  step 'the student "taylor" belongs to class "Mathematics"'
  
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
      | taylor    | My Class      | Algebra              | f               | a      |
      | chuck     | My Class      | Algebra              | f               | a      |
      })
end
