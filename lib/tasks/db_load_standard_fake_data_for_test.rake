namespace :db do
  desc "Load a standard set of fake data and have that be available at the start of every test."
  task :load_standard_fake_data => :environment do
    
    REST_AUTH_SITE_KEY = 'sitekeyforrunningtests'
    
    #load factories
    require 'factory_girl'
    Dir[File.dirname(__FILE__) + '/../../factories/*.rb'].each {|file| require file }
    require 'rspec/core/rake_task'
    require 'cucumber/rake/task'
    
    def polymorphic_assign(assignable_type, assignable_name, clazz_name)
      clazz = Portal::Clazz.find_by_name(clazz_name)
      assignable = assignable_type.gsub(/\s/, "_").classify.constantize.find_by_name(assignable_name)
      # check how can we use rspec matchers in rake file
      #assignable.should_not be_nil
      if assignable.nil?
        raise "expected: not nil\n     got: nil\n #{assignable.inspect}"
      end
      
      Factory.create(:portal_offering, {
        :runnable => assignable,
        :clazz => clazz
      })
    end
    
    def add_multichoice_answer(learner,question,answer_text)
      answer = question.choices.detect{ |c| c.choice == answer_text}
      new_answer = Saveable::MultipleChoice.create(
        :learner => learner,
        :offering => learner.offering,
        :multiple_choice => question
      ) 
      saveable_answer = Saveable::MultipleChoiceAnswer.create(
        #:bundle_contents => learner.bundle_contents,
        #:bundle_logger   => learner.bundle_logger,
        :choice          => answer
      )
      new_answer.answers << saveable_answer
    end
    
    def add_openresponse_answer(learner,question,answer_text)
      new_answer = Saveable::OpenResponse.create(
        :learner => learner,
        :offering => learner.offering,
        :open_repsonse => question
      ) 
      saveable_answer = Saveable::OpenResponseAnswer.create(
        :answer          => answer_text
      )
      new_answer.answers << saveable_answer
    end
    
    def add_image_question_answer(learner,question,answer_text)
      return nil if (answer_text.nil? || answer_text.strip.empty?)
      new_answer = Saveable::ImageQuestion.create(
        :learner => learner,
        :offering => learner.offering,
        :image_question => question
      ) 
      # TODO: Maybe slurp in some image and encode it for the blob?
      saveable_answer = Saveable::ImageQuestionAnswer.create(
        :blob => Dataservice::Blob.create(
          :content => answer_text,
          :token => answer_text
        )
      )
      new_answer.answers << saveable_answer
    end
    
    def add_response(learner,prompt_text,answer_text)
      prompts = {}
      Embeddable::MultipleChoice.all.each  { |q| prompts[q.prompt] = q}
      Embeddable::OpenResponse.all.each    { |q| prompts[q.prompt] = q}
      Embeddable::ImageQuestion.all.each   { |q| prompts[q.prompt] = q}
      Embeddable::MultipleChoice.all.each  { |q| prompts[q.prompt] = q}
      question = prompts[prompt_text]
      puts "No Question found for #{prompt_text}" if question.nil?
      return if question.nil?
      case question.class.name
      when "Embeddable::MultipleChoice" 
        return add_multichoice_answer(learner,question, answer_text)
      when "Embeddable::OpenResponse"
        return add_openresponse_answer(learner,question, answer_text)
      when "Embeddable::ImageQuestion"
        return add_image_question_answer(learner,question, answer_text)
      end
    end
    
    
    def find_or_create_offering(runnable,clazz)
      type = runnable.class.to_s
      create_hash = {:runnable_id => runnable.id, :runnable_type => type, :clazz_id => clazz.id}
      offering = Portal::Offering.find(:first, :conditions=> create_hash)
      unless offering
        offering = Portal::Offering.create(create_hash)
        offering.save
      end
      offering
    end
    
    def record_student_answer(data, assignable_type)
      assignable_class = assignable_type.gsub(/\s/, "_").classify.constantize
      first_date = DateTime.now - data.length
      data.each_with_index do |hash, index|
        student = User.find_by_login(hash['student']).portal_student
        clazz = Portal::Clazz.find_by_name(hash['class'])
        assignable = assignable_class.find_by_name(hash[assignable_type])
        offering = find_or_create_offering(assignable, clazz)
        learner = offering.find_or_create_learner(student)
        add_response(learner,hash['question_prompt'],hash['answer'])
        report_learner = learner.report_learner
        # need to make sure the last_run is sequencial inorder for some tests to work
        report_learner.last_run = first_date + index
        report_learner.update_fields
      end
    end
    
    #following semesters exist
    data = {
      :fall => {"name" => 'Fall', "start_time" => DateTime.new(2012, 12, 01, 00, 00, 00), "end_time" => DateTime.new(2012, 03, 01, 23, 59, 59) },
      :spring => {"name" => 'Spring', "start_time" => DateTime.new(2012, 10, 10, 23, 59, 59), "end_time" => DateTime.new(2013, 03, 31, 23, 59, 59) } 
    }
    
    data.each do |semester, semester_info|
     FactoryGirl.create(:portal_semester, semester_info)
    end
    

    #following teachers exist
    data = {
      :teacher_1 => {"login" => 'teacher', "password" => 'teacher', "first_name" => 'John', "last_name" =>'Nash', "email" => 'bademail@noplace.com'},
      :teacher_2 => {"login" => 'albert', "password" => 'albert', "first_name" => 'Albert', "last_name" =>'Fernandez', "email" => 'bademail@noplace2.com'},
      :teacher_3 => {"login" => 'robert', "password" => 'robert', "first_name" => 'Robert', "last_name" =>'Fernandez', "email" => 'bademail@noplace3.com'},
      :teacher_4 => {"login" => 'peterson', "password" => 'teacher', "first_name" => 'peterson', "last_name" =>'taylor', "email" => 'bademail@noplace4.com'},
      :teacher_5 => {"login" => 'teacher_with_no_class', "password" => 'teacher_with_no_class', "first_name"=> 'teacher_with_no_class', "last_name" =>'teacher_with_no_class', "email" => 'bademail@noplace5.com'}
    }
    
    semester = Portal::Semester.first
    school = Factory.create(:portal_school, :semesters => [semester])
    course = Factory.create(:portal_course, :school => school)
    clazz = Factory.create(:portal_clazz, :course => course)
    User.anonymous(true)
    data.each do |teacher, teacher_info|
      begin
        cohorts = teacher_info.delete("cohort_list")
        user = Factory(:user, teacher_info)
        user.add_role("member")
        user.register
        user.activate
        user.save!
        
        portal_teacher = Portal::Teacher.create(:user_id => user.id)
        portal_teacher.schools = [school]
        portal_teacher.clazzes = [clazz]
        portal_teacher.cohort_list = cohorts if cohorts
        portal_teacher.save!
        
      rescue ActiveRecord::RecordInvalid
        # assume this user is already created...
      end
    end
    
 
    #following users exist
    data = {
      :user_1 => {"login" => "author", "password" => "author", "roles" => "member, author"},
      :user_2 => {"login" => "myadmin", "password" => "myadmin", "roles" => "admin"},
      :user_3 => {"login" => "manager", "password" => "manager", "roles" => "manager"},
      :user_4 => {"login" => "mymanager", "password" => "mymanager", "roles" => "manager"},
      :user_5 => {"login" => "researcher", "password" => "researcher", "roles" => "researcher"},
      :user_6 => {"login" => "admin", "password" => "admin", "roles" => "admin"},
    }
    
    User.anonymous(true)
    data.each do |user, user_info|
      roles = user_info.delete('roles')
      if roles
        roles = roles ? roles.split(/,\s*/) : nil
      else
        roles =  []
      end
      begin
        user = Factory(:user, user_info)
        roles.each do |role|
          user.add_role(role)
        end
        user.register
        user.activate
        user.save!
      rescue ActiveRecord::RecordInvalid
        # assume this user is already created...
      end
    end


    #following classes exist:
    data = {
      :clazz_1 => {"name" => "My Class", "teacher" => "teacher", "class_word" => "My Class"},
      :clazz_2 => {"name" => "Physics", "teacher" => "teacher", "class_word" => "phy"},
      :clazz_3 => {"name" => "Mathematics", "teacher" => "teacher", "class_word" => "math"},
      :clazz_4 => {"name" => "Chemistry", "teacher" => "teacher", "class_word" => "chem"},
      :clazz_5 => {"name" => "Biology", "teacher" => "teacher", "class_word" => "bio"},
      :clazz_6 => {"name" => "Geography", "teacher" => "teacher", "class_word" => "geo"},
      :clazz_7 => {"name" => "Mechanics", "teacher" => "teacher", "class_word" => "Mec"},
      :clazz_8 => {"name" => "class_with_no_assignment", "teacher" => "teacher", "class_word" => "class_with_no_assignment"},
      :clazz_9 => {"name" => "class_with_no_students", "teacher" => "teacher", "class_word" => "class_with_no_students"},
      :clazz_10 => {"name" => "class_with_no_attempts", "teacher" => "teacher", "class_word" => "class_with_no_attempts"},
    }
    
    data.each do |claz, clazz_info|
      user = User.find_by_login clazz_info['teacher']
      teacher = user.portal_teacher
      clazz_info.merge!('teacher' => teacher)
      clazz_info.merge!('course' => course)
      
      clazz = Portal::Clazz.find_by_name(clazz_info['name'])
      if clazz
        clazz.add_teacher(teacher)
      else
      Factory.create(:portal_clazz, clazz_info)
      end
    end
    
    
    #following teacher and class mapping exists:
  data = {
        "albert" => ["Biology", "class_with_no_assignment"],
        "peterson" =>["class_with_no_assignment", "My Class"]
    }
    data.each do |teacher, clazzes_name|
      user = User.find_by_login(teacher)
      portal_teacher = Portal::Teacher.find_by_user_id(user.id)
      clazzes_name.each do |clazz_name|
        portal_clazz = Portal::Clazz.find_by_name(clazz_name)
        teacher_clazz = Portal::TeacherClazz.new()
        teacher_clazz.clazz_id = portal_clazz.id
        teacher_clazz.teacher_id = portal_teacher.id
        save_result = teacher_clazz.save
        if (save_result == false)
          return save_result
        end
      end
    end
    
    
    #following students exist:
    data = {
      :student_1 =>{"login" => "student" ,"password" => "student" ,"first_name" => "Alfred" ,"last_name" => "Robert" ,"email" => "student@mailinator.com" },
      :student_2 =>{"login" => "dave" ,"password" => "student" ,"first_name" => "Dave" ,"last_name" => "Doe" ,"email" => "student@mailinator1.com" },
      :student_3 =>{"login" => "chuck" ,"password" => "student" ,"first_name" => "Chuck" ,"last_name" => "Smith" ,"email" => "student@mailinator2.com" },
      :student_4 =>{"login" => "taylor" ,"password" => "student" ,"first_name" => "taylor" ,"last_name" => "Donald" ,"email" => "student@mailinator3.com" },
      :student_5 =>{"login" => "Mache" ,"password" => "student" ,"first_name" => "Mache" ,"last_name" => "Smith" ,"email" => "student@mailinator4.com" },
      :student_6 =>{"login" => "shon" ,"password" => "student" ,"first_name" => "shon" ,"last_name" => "done" ,"email" => "student@mailinator5.com" },
      :student_7 =>{"login" => "ross" ,"password" => "student" ,"first_name" => "ross" ,"last_name" => "taylor" ,"email" => "student@mailinator6.com" },
      :student_8 =>{"login" => "monty" ,"password" => "student" ,"first_name" => "Monty" ,"last_name" => "Donald" ,"email" => "student@mailinator7.com" },
      :student_9 =>{"login" => "Switchuser" ,"password" => "Switchuser" ,"first_name" => "Joe" ,"last_name" => "Switchuser" ,"email" => "student@mailinator8.com" },
    }
    User.anonymous(true)
    portal_grade = Factory.create(:portal_grade)
    portal_grade_level = Factory.create(:portal_grade_level, {:grade => portal_grade})
    data.each do |student, student_info|
      begin
        clazz = Portal::Clazz.find_by_name(student_info.delete('class'))
        user = Factory(:user, student_info)
        user.add_role("member")
        user.register
        user.activate
        user.save!
  
        portal_student = Factory(:full_portal_student, { :user => user, :grade_level =>  portal_grade_level})
        portal_student.save!
        if (clazz)
          portal_student.add_clazz(clazz)
        end
      rescue ActiveRecord::RecordInvalid
        # assume this user is already created...
      end
    end
    
    
    #following multiple choice questions exists:
    data = {
      :mult_cho_questions1 => {"prompt" => "a" , "answers" => "a,b,c,d","correct_answer" => "a"},
      :mult_cho_questions2 => {"prompt" => "b" , "answers" => "a,b,c,d","correct_answer" => "a"},
      :mult_cho_questions3 => {"prompt" => "c" , "answers" => "a,b,c,d","correct_answer" => "a"},
      :mult_cho_questions4 => {"prompt" => "d" , "answers" => "a,b,c,d","correct_answer" => "a"},
      :mult_cho_questions5 => {"prompt" => "e" , "answers" => "a,b,c,d","correct_answer" => "a"},
      :mult_cho_questions6 => {"prompt" => "f" , "answers" => "a,b,c,d","correct_answer" => "a"}
    }
    
    data.each do |mult_cho_question, question_info|
      prompt = question_info['prompt']
      choices = question_info['answers'].split(",")
      choices.map!{|c| c.strip}
      correct = question_info['correct_answer']
      multi = Embeddable::MultipleChoice.find_or_create_by_prompt(prompt)
      choices.map! { |c| Embeddable::MultipleChoiceChoice.create(
        :choice => c, 
        :multiple_choice => multi, 
        :is_correct => (c == correct)
      )}
      multi.choices = choices
    end
    
    
    #there is an image question with the prompt "image_q"
    data = {"prompt" => "image_q"}
    image_question = Embeddable::ImageQuestion.find_or_create_by_prompt(data["prompt"])
    
    
    #following empty investigations exist:
    data = {
      :investigation1 => {"name" => "draft g" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "draft"},
      :investigation2 => {"name" => "b Investigation" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "published"},
      :investigation3 => {"name" => "a Investigation" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "published"},
      :investigation4 => {"name" => "c Investigation" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "published"},
      :investigation5 => {"name" => "d Investigation" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "published"},
      :investigation6 => {"name" => "e Investigation" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "published"},
      :investigation7 => {"name" => "f Investigation" , "user" => "teacher" , "offerings_count" => "5" , "publication_status" => "published"}
    }
    
    data.each do |investigation, investigation_info|
      user = User.find_by_login investigation_info['user']
      Factory.create(:investigation, investigation_info.merge('user' => user))
    end
    
    
    #following resource pages exist:
    data = {
      :resource_page1 => {"name" => "NewestResource","user" => "teacher","offerings_count" => "6","created_at" => "Wed Jan 26 12:00:00 -0500 2011","publication_status" => "published"},
      :resource_page2 => {"name" => "MediumResource","user" => "teacher","offerings_count" => "11","created_at" => "Wed Jan 23 12:00:00 -0500 2011","publication_status" => "published"},
      :resource_page3 => {"name" => "OldestResource","user" => "teacher","offerings_count" => "21","created_at" => "Wed Jan 20 12:00:00 -0500 2011","publication_status" => "published"}
    }
    
    data.each do |resource_page, resource_page_info|
      user_name = resource_page_info.delete('user')
      user = User.first(:conditions => { :login => user_name })
      next if user.blank?
  
      resource_page_info['user'] = user
      resource_page = Factory(:resource_page, resource_page_info)
      resource_page.save!
    end
    
    
    #following page exists:
     data = {
       :page => { "name" => "My Page","user" => "teacher","publication_status" => "published"}
     }
     data.each do |page, page_info|
       user_name = page_info.delete('user')
       user = User.find_by_login user_name
       page_info['user'] = user
       Factory :page, page_info
     end
     
     
     #following empty investigations exist:
     data = {
       :empty_investigation1 => { "name" => "NewestInv","user" => "teacher","offerings_count" => "5","created_at" => "Wed Jan 26 12:00:00 -0500 2111","publication_status" => "published"},
       :empty_investigation2 => { "name" => "MediumInv","user" => "teacher","offerings_count" => "10","created_at" => "Wed Jan 23 12:00:00 -0500 2111","publication_status" => "published"},
       :empty_investigation3 => { "name" => "OldestInv","user" => "teacher","offerings_count" => "20","created_at" => "Wed Jan 20 12:00:00 -0500 2111","publication_status" => "published"}
     }
     data.each do |investigation, investigation_info|
       user = User.find_by_login investigation_info['user']
       Factory.create(:investigation, investigation_info.merge('user' => user))
     end
     
     
     #following linked investigations exist
     data = {
       :linked_investigation1 => { "name" => "WithLinksInv","user" => "author","offerings_count" => "5","created_at" => "Wed Jan 25 12:00:00 -0500 2011","publication_status" => "published"}
     }
     data.each do |linked_investigation, inv_info|
      user = User.find_by_login inv_info['user']
      inv = Factory.create(:investigation, inv_info.merge('user' => user))
        inv.activities << (Factory :activity, { :user => user })
        inv.activities[0].sections << (Factory :section, {:user => user})
        inv.activities[0].sections[0].pages << (Factory :page, {:user => user})
        open_response = (Factory :open_response, {:user => user})
        open_response.pages << inv.activities[0].sections[0].pages[0]
        draw_tool = (Factory :drawing_tool, {:user => user, :background_image_url => "https://lh4.googleusercontent.com/-xcAHK6vd6Pc/Tw24Oful6sI/AAAAAAAAB3Y/iJBgijBzi10/s800/4757765621_6f5be93743_b.jpg"})
        draw_tool.pages << inv.activities[0].sections[0].pages[0]
        snapshot_button = (Factory :lab_book_snapshot, {:user => user, :target_element => draw_tool})
        snapshot_button.pages << inv.activities[0].sections[0].pages[0]
        prediction_graph = (Factory :data_collector, {:user => user})
        prediction_graph.pages << inv.activities[0].sections[0].pages[0]
        displaying_graph = (Factory :data_collector, {:user => user, :prediction_graph_source => prediction_graph})
        displaying_graph.pages << inv.activities[0].sections[0].pages[0]
        inv.reload
    end
    
    
    #following simple investigations exist:
    data = {
      :simple_investigation1 => { "name" => "Radioactivity","user" => "author","publication_status" => "published","description" => "Nuclear Energy is a great subject"},
      :simple_investigation2 => { "name" => "Set Theory","user" => "author","publication_status" => "published","description" => "Set Theory is a great subject"},
      :simple_investigation3 => { "name" => "Mechanics","user" => "author","publication_status" => "published","description" => "Mechanics is a great subject"},
      :simple_investigation4 => { "name" => "Geometry","user" => "author","publication_status" => "published","description" => "Triangle is a great subject"},
      :simple_investigation5 => { "name" => "integral calculus","user" => "author","publication_status" => "published","description" => "integral calculus is a great subject"},
      :simple_investigation6 => { "name" => "differential calculus","user" => "author","publication_status" => "published","description" => "differential calculus is a great subject"},
      :simple_investigation7 => { "name" => "differential equations","user" => "author","publication_status" => "published","description" => "differential equations is a great subject"},
      :simple_investigation8 => { "name" => "organic chemistry","user" => "author","publication_status" => "published","description" => "organic chemistry is a great subject"},
      :simple_investigation9 => { "name" => "inorganic chemistry","user" => "author","publication_status" => "published","description" => "inorganic chemistry is a great subject"},
      :simple_investigation10 => { "name" => "graph theory","user" => "author","publication_status" => "published","description" => "graph theory is a great subject"},
      :simple_investigation11 => { "name" => "investigaion_not_assigned","user" => "author","publication_status" => "published","description" => "investigaion_not_assigned is a great subject"},
      :simple_investigation12 => { "name" => "testing fast cars","user" => "author","publication_status" => "published","description" => "how fast can cars go?"},
      :simple_investigation13 => { "name" => "Lumped circuit abstraction","user" => "author","publication_status" => "published","description" => "LCA is a great subject"},
      :simple_investigation14 => { "name" => "Static discipline","user" => "author","publication_status" => "published","description" => "SD is a great subject"},
      :simple_investigation15 => { "name" => "Non Linear Devices","user" => "author","publication_status" => "published","description" => "NLD is a great subject"}
    }
    data.each do |simple_investigation, inv_info|
      user = User.first(:conditions => { :login => inv_info.delete('user') })
      inv_info[:user_id] = user.id
      investigation = Investigation.create(inv_info)
      activity = Activity.create(inv_info)
      section = Section.create(inv_info)
      page = Page.create(inv_info)
      section.pages << page
      activity.sections << section
      investigation.activities << activity
      investigation.save
    end
    
    
    
    #following investigations with multiple choices exist:
    data = {
      "Plant reproduction"  =>  [
                                  {"activity" => "Plant activity","section" => "section b","page" => "page 2","multiple_choices" => "b","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"}
                                ],
      "Aerodynamics"  =>  [
                            {"activity" => "Air activity","section" => "section c","page" => "page 3","multiple_choices" => "c","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"},
                            {"activity" => "Aeroplane","section" => "section d","page" => "page 4","multiple_choices" => "d","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "true"}
                          ],
      "Arithmatics" =>  [
                          {"activity" => "Algebra","section" => "section a","page" => "page 1","multiple_choices" => "a","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"}
                        ],
      "Radioactivity" =>  [
                            {"activity" => "Radio activity","section" => "section a","page" => "page 1","multiple_choices" => "a","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"},
                            {"activity" => "Nuclear Energy","section" => "section b","page" => "page 2","multiple_choices" => "b","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"}
                          ],
      "Electricity" =>  [
                          {"activity" => "current","section" => "section b","page" => "page 2","multiple_choices" => "b","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"}
                        ]
    }
    data.each do |investigation, questions|
      investigation = Investigation.find_or_create_by_name(investigation)
      investigation.user = Factory(:user)
      investigation.save
      # ITSISU requires descriptions on activities
      questions.each do |question|
        activity = Activity.find_or_create_by_name(question['activity'], :description => question['activity'])
        activity.user = investigation.user
        if question['activity_teacher_only']
          # Create a teacher only activity if specified
          activity.teacher_only = (question['activity_teacher_only'] == 'true')
          activity.save
        end
      
        section = Section.find_or_create_by_name(question['section'])
        page = Page.find_or_create_by_name(question['page'])
        mcs = question['multiple_choices'].split(",").map{ |q| Embeddable::MultipleChoice.find_by_prompt(q.strip) }
        mcs.each do |q|
          q.pages << page
        end
        imgqs = question['image_questions'].split(",").map{ |q| Embeddable::ImageQuestion.find_by_prompt(q.strip) }
        imgqs.each do |q|
          q.pages << page
        end
        page.save
        section.pages << page
        activity.sections << section
        investigation.activities << activity
      end
    end
  
    
    #following activities for the above investigations exist:
    data = {
      "Radioactivity" => [
                            { "name" => "Radioactive decay", "user" => "author", "publication_status" => "published", "description" => "Nuclear Energy is a great material"},
                            { "name" => "Gamma Rays" ,"user" => "author","publication_status" => "published", "description" => "Gamma Rays is a great material"}
                         ],
      "Set Theory" => [
                        { "name" => "Venn Diagram", "user" => "author", "publication_status" => "published","description" => "Venn Diagram is a great material"},
                        { "name" => "operations on sets", "user" => "author","publication_status" => "published","description" => "operations on sets is a great material"}
                      ],
      "Mechanics" => [
                        { "name" => "Fluid Mechanics", "user" => "author", "publication_status" => "published","description" => "Fluid Mechanics is a great material"},
                        { "name" => "Circular Motion", "user" => "author", "publication_status" => "published","description" => "Circular Motion is a great material"},
                        { "name" => "Quantum Mechanics", "user" => "author","publication_status" => "published","description" => "Quantum Mechanics is a great material"}
                    ],
      "Geometry"  => [
                        { "name" => "Geometry", "user" => "author","publication_status" => "published","description" => "Triangle is a great material"},
                        { "name" => "intersecting lines", "user" => "author","publication_status" => "published","description" => "intersecting lines is a great material"},
                        { "name" => "parallel lines", "user" => "author","publication_status" => "published","description" => "parallel lines is a great material"},
                        { "name" => "graphs and lines", "user" => "author","publication_status" => "published","description" => "parallel lines is a great material"},
                        { "name" => "circles", "user" => "author","publication_status" => "published","description" => "circles is a great material"},
                        { "name" => "boolean algebra", "user" => "author","publication_status" => "published","description" => "boolean algebra is a great material"},
                     ],
      "Aerodynamics" => [
                          { "name" => "Atmosphere", "user" => "author","publication_status" => "published","description" => "Atmosphere is a great material"}
                        ]
    }
  
    data.each do |investigation_name, activities|
        investigation = Investigation.find_by_name(investigation_name)
        activities.each do |act_info|
          act_info[:investigation_id] = investigation.id
          act_info[:user] = User.find_by_login(act_info['user'])
          activity = Activity.create(act_info)
        end
    end
    
    #following activities with multiple choices exist
    data = {
     :activities_with_multiple_choices => { "activity" => "Algebra","section" => "section a","page" => "page 6","multiple_choices" => "f","image_questions" => "image_q","user" => "teacher","activity_teacher_only" => "false"}
    }
    
    data.each do |activities, act_info|
      activity = Activity.find_or_create_by_name(act_info['activity'], :description => act_info['activity'])
      activity.user = Factory(:user)
      activity.save!#.should be_true
      section = Section.find_or_create_by_name(act_info['section'])
      page = Page.find_or_create_by_name(act_info['page'])
      mcs = act_info['multiple_choices'].split(",").map{ |q| Embeddable::MultipleChoice.find_by_prompt(q.strip) }
      mcs.each do |q|
        q.pages << page
      end
      imgqs = act_info['image_questions'].split(",").map{ |q| Embeddable::ImageQuestion.find_by_prompt(q.strip) }
      imgqs.each do |q|
        q.pages << page
      end
      page.save
      section.pages << page
      activity.sections << section
    end
    
    
    #following external activity exists:
    data = {
      :external_activity => { "name" => "My Activity","user" => "teacher","url" => "/mock_html/test-exernal-activity.html"}
    }
    data.each do |external_activity, act_info|
      user = User.first(:conditions => { :login => act_info.delete('user') })
      act_info[:user_id] = user.id
      activity = Factory :external_activity, act_info
      activity.publish
      activity.save
    end
  
  
    #'the teachers "teacher , albert" are in a school named "VJTI"'
    teachers = "teacher , albert"
    school_name = "VJTI"
    semester = Portal::Semester.first
    school = Portal::School.find_by_name(school_name)
    if (school.nil?) then
      school = Factory(:portal_school, {:name=>school_name, :semesters => [semester]})
    end
    teachers = teachers.split(",").map { |t| t.strip }
    teachers.map! {|t| User.find_by_login(t)}
    teachers.map! {|u| u.portal_teacher }
    teachers.each {|t| t.schools = [ school ]; t.save!; t.reload}
    
    
    #And following student clazz mapping exist
    data = {
      "student" => "My Class, class_with_no_assignment, class_with_no_attempts",
      "dave" => "My Class",
      "chuck" => "My Class, Physics, Mechanics",
      "taylor" => "My Class, Mathematics",
      "Mache" => "Physics",
      "shon" => "Physics",
      "ross" => "Physics"
      
    }
    data.each do |student_name, clazzes|
      student = User.find_by_login(student_name).portal_student
      clazzes = clazzes.split(",").map{|c| c.strip }
      clazzes.map!{|c| Portal::Clazz.find_by_name(c)}
      clazzes.each do |each_clazz|
        Factory.create :portal_student_clazz, :student => student, :clazz => each_clazz
      end
    end
    
    
    #following assignments exist
    data = {
      "My Class" => [
                      {"type" => "investigation", "name" => "Aerodynamics"},
                      {"type" => "investigation", "name" => "Plant reproduction"},
                      {"type" => "investigation", "name" => "Radioactivity"},
                      {"type" => "activity", "name" => "Algebra"}
                    ],
      "Physics" => [
                      {"type" => "investigation", "name" => "Electricity"},
                      {"type" => "investigation", "name" => "Plant reproduction"},
                      {"type" => "investigation", "name" => "Aerodynamics"},
                      {"type" => "investigation", "name" => "Radioactivity"},
                      {"type" => "activity", "name" => "Algebra"}
                   ],
      "Mechanics" => [
                        {"type" => "investigation", "name" => "Aerodynamics"}
                     ],
      
      "class_with_no_attempts" => [
                                    {"type" => "investigation", "name" => "Aerodynamics"}
                                  ],
      
      "class_with_no_students" => [
                                    {"type" => "investigation", "name" => "Plant reproduction"}
                                  ],
      
      "Mathematics" => [
                          {"type" => "investigation", "name" => "Lumped circuit abstraction"},
                          {"type" => "investigation", "name" => "Static discipline"},
                          {"type" => "investigation", "name" => "Non Linear Devices"}
                       ]
  
         
    }

    data.each do |clazz_name, assignment_info|
      assignment_info.each do |assignment|
        type = assignment['type']
        name = assignment['name']
        polymorphic_assign(type, name, clazz_name)
      end
    end
    
    
    #following assignable and clazz mapping exist
    data = {
      {:assignable_type => "Investigation", :assignable_name => "Aerodynamics"} => "class_with_no_students"
    }
    data.each do |assignable_info, clazzes|
      clazzes = clazzes.split(",").map{|c| c.strip }
      clazzes.map!{|c| Portal::Clazz.find_by_name(c)}
      clazzes.each do |each_clazz|
        polymorphic_assign(assignable_info[:assignable_type], assignable_info[:assignable_name], each_clazz)  
      end
    end
    
    
    #following student answers (Investigations):
    data = [
      {"student" => "dave", "class" => "My Class", "investigation" => "Radioactivity", "question_prompt" => "a", "answer" => "a"}
    ]
    
    record_student_answer(data, 'investigation')
    
    
    #following student answers (Activity):
    
    data = [
      {"student" => "taylor", "class" => "My Class", "activity" => "Algebra", "question_prompt" => "f", "answer" => "a"},
      {"student" => "chuck", "class" => "My Class", "activity" => "Algebra", "question_prompt" => "f", "answer" => "a"}
    ]
    
    record_student_answer(data, 'activity')
  end
end
