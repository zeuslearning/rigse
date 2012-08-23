When /^the following activities for the above investigations exist:$/ do |activity_table|
  activity_table.hashes.each do |hash|
    investigation_name = hash.delete('investigation')
    investigation = Investigation.find_by_name(investigation_name)
    hash[:investigation_id] = investigation.id
    hash[:user] = User.find_by_login(hash[:user])
    activity = Activity.create(hash)
  end
end

When /^(?:|I )enter search text "(.+)" on the search instructional materials page$/ do |search_text|
  step_text = "I fill in \"search_term\" with \"#{search_text}\""
  step step_text
end

When /^(?:|I )should see search suggestions for "(.+)" on the search instructional materials page$/ do |search_text|
  step_text = "I should see \"#{search_text}\" within suggestion box"
  step step_text
end

When /^(?:|I )search study material "(.+)" on the search instructional materials page$/ do |search_text|
  step_text = "I fill in \"search_term\" with \"#{search_text}\""
  step step_text
  step 'I press "GO"'
end

When /^(?:|I )should see search results for "(.+)" on the search instructional materials page$/ do|search_text|
  step_text = "I should see \"#{search_text}\" within result box"
  step step_text
end

When /^(?:|I )should be able to sort search and filter results on the search instructional materials page$/ do
  
  # Check sorting & filtering for activities
  
  # Enter a search term
  step 'I fill in "search_term" with "lines"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
  
  # Sort order Alphabetical
  find(:xpath, "//label[@for = 'sort_order_name_ASC']").click
  step 'I should wait 2 seconds'
  step '"graphs and lines" should appear before "intersecting lines"'
  step '"intersecting lines" should appear before "parallel lines"'
  
  created_at = Date.today
  ['intersecting lines', 'parallel lines', 'graphs and lines'].each do |activity|
    act = Activity.find_by_name(activity)
    created_at = created_at - 1
    act.created_at = created_at
    act.updated_at = created_at
    act.save!
  end
  
  #sort order oldest
  find(:xpath, "//label[@for = 'sort_order_created_at_ASC']").click
  step 'I should wait 2 seconds'
  step '"graphs and lines" should appear before "parallel lines"'
  step '"parallel lines" should appear before "intersecting lines"'
  
  #sort order newest
  find(:xpath, "//label[@for = 'sort_order_created_at_DESC']").click
  step 'I should wait 2 seconds'
  step '"intersecting lines" should appear before "parallel lines"'
  step '"parallel lines" should appear before "graphs and lines"'
  
  #assign activity to class to test popularity
  step 'the Activity "intersecting lines" is assigned to the class "Physics"'
  step 'the Activity "intersecting lines" is assigned to the class "Geography"'
  step 'the Activity "intersecting lines" is assigned to the class "Mathematics"'
  step 'the Activity "parallel lines" is assigned to the class "Mathematics"'
  step 'the Activity "parallel lines" is assigned to the class "Geography"'
  
  #sort order by popularity
  find(:xpath, "//label[@for = 'sort_order_offerings_count_DESC']").click
  step 'I should wait 2 seconds'
  step '"intersecting lines" should appear before "parallel lines"'
  step '"parallel lines" should appear before "graphs and lines"'
  
  
  # Check sorting & filtering for investigations
  
  step 'I am on the search instructional materials page'
  
  # Enter a search term for investigation
  step 'I fill in "search_term" with "calculus"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
  
  # Sort order Alphabetical
  find(:xpath, "//label[@for = 'sort_order_name_ASC']").click
  step 'I should wait 2 seconds'
  step '"differential calculus" should appear before "integration calculus"'
  
  created_at = Date.today
  ['differential calculus', 'integration calculus'].each do |investigation|
    inv = Investigation.find_by_name(investigation)
    created_at = created_at - 1
    inv.created_at = created_at
    inv.updated_at = created_at
    inv.save!
  end
  
  # Sort order Oldest
  find(:xpath, "//label[@for = 'sort_order_created_at_ASC']").click
  step 'I should wait 2 seconds'
  step '"integration calculus" should appear before "differential calculus"'
  
  # Sort order Newest
  find(:xpath, "//label[@for = 'sort_order_created_at_DESC']").click
  step 'I should wait 2 seconds'
  step '"differential calculus" should appear before "integration calculus"'
  
  
  #assign investigations to classes to test popularity
  step 'the Investigation "differential calculus" is assigned to the class "Physics"'
  step 'the Investigation "differential calculus" is assigned to the class "Geography"'
  step 'the Investigation "differential calculus" is assigned to the class "Mathematics"'
  step 'the Investigation "integration calculus" is assigned to the class "Mathematics"'
  step 'the Investigation "integration calculus" is assigned to the class "Geography"'
  #sort order by popularity
  find(:xpath, "//label[@for = 'sort_order_offerings_count_DESC']").click
  step 'I should wait 2 seconds'
  step '"differential calculus" should appear before "integration calculus"'
  
end

When /^(?:|I )should be able to see grouped search results on the search instructional materials page$/ do
  #grouping
  #Activity
  step 'I fill in "search_term" with "Geometry"'
  step 'I uncheck "Investigation"'
  step 'I check "Activity"'
  step 'I press "GO"'
  step 'I should see "Geometry"'
  step 'I should see "Triangle is a great subject"'
  step 'I should see "Triangle is a great material"'
  step 'I should not see "Radioactivity"'
  #Investigation
  step 'I fill in "search_term" with "Radioactivity"'
  step 'I check "Investigation"'
  step 'I uncheck "Activity"'
  step 'I press "GO"'
  step 'I should see "Radioactivity"'
  step 'I should see "Nuclear Energy is a great subject"'
  step 'I should not see "Nuclear Energy is a great material"'
  step 'I should not see "Geometry"'

end

When /^the count of a search result is greater than the page size on the search instructional materials page$/ do
  step 'I fill in "search_term" with "is a great material"'
end

Then /^the search results should be paginated on the search instructional materials page$/ do
  #pagination for investigations
  within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][1]") do
    if page.respond_to? :should
      page.should have_link("Next")
    else
      assert page.has_link?("Next")
    end
    
    page.should have_content("Previous")
    
    step 'I follow "Next"'
    
    if page.respond_to? :should
      page.should have_link("Previous")
    else
      assert page.has_link?("Previous")
    end
    
    page.should have_content("Next")
  end
  
  #pagination for activity
  within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][2]") do
    if page.respond_to? :should
      page.should have_link("Next")
    else
      assert page.has_link?("Next")
    end
    
    page.should have_content("Previous")
    
    step 'I follow "Next"'
    
    if page.respond_to? :should
      page.should have_link("Previous")
    else
      assert page.has_link?("Previous")
    end
    
    page.should have_content("Next")
  end
end

Then /^(?:|I )can assign investigations and activities to a class on the search instructional materials page$/ do
  #assigning investigations
  #before search
  investigation_name = 'Geometry'
  within(:xpath,"//div[@class='material_list_item' and contains(., '#{investigation_name}')]") do
    step 'I follow "Assign to a Class"'
  end
  step 'I check "Mathematics"'
  step 'I follow "Save"'
  step 'I go to the class page for "Mathematics"'
  step 'I should see "Geometry"'
  #After search
  step 'I am on the search instructional materials page'
  step 'I fill in "search_term" with "graph theory"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
  step 'I check "Investigation"'
  step 'I should wait 2 seconds'
  step 'I uncheck "Activity"'
  step 'I should wait 2 seconds'
  within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][1]") do
    step 'I follow "Assign to a Class"'
  end
  step 'I check "Mathematics"'
  step 'I follow "Save"'
  step 'I go to the class page for "Mathematics"'
  step 'I should see "graph theory"'
  #assigning activity
  #Before Search
  step 'I am on the search instructional materials page'
  step 'I uncheck "Investigation"'
  step 'I should wait 2 seconds'
  step 'I check "Activity"'
  step 'I should wait 2 seconds'
  activity_name = 'Fluid Mechanics'
  within(:xpath,"//div[@class='material_list_item' and contains(., '#{activity_name}')]") do
    step 'I follow "Assign to a Class"'
  end
  step 'I check "Physics"'
  step 'I follow "Save"'
  step 'I go to the class page for "Physics"'
  step 'I should see "Fluid Mechanics"'
  #After search
  step 'I am on the search instructional materials page'
  step 'I fill in "search_term" with "Circular Motion"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
  step 'I uncheck "Investigation"'
  step 'I should wait 2 seconds'
  step 'I check "Activity"'
  step 'I should wait 2 seconds'
  step 'I follow "Assign to a Class"'
  step 'I check "Physics"'
  step 'I follow "Save"'
  step 'I go to the Instructional Materials page for "Physics"'
  step 'I should see "Circular Motion"'
end

Then /^(?:|I )can preview investigations on the search instructional materials page$/ do
    #Preview investigations
    investigation_id = Investigation.find_by_name('Geometry').id
    within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
      step 'I follow "Preview"'
    end
    step 'I receive a file for download with a filename like "_investigation_"'
end


Then /^(?:|I )can preview activities on the search instructional materials page$/ do
    #Preview activities
    within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][2]//div[@class='material_list_item']") do
      step 'I follow "Preview"'
    end
    step 'I receive a file for download with a filename like "_activity_"'
end


And /^(?:|I )should not be able to assign materials on the search instructional materials page$/ do
  #investigation
  investigation_id = Investigation.find_by_name('Geometry').id
  within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
    step 'I follow "Assign to a Class"'
  end
  
  step 'I should be on the home page'
  step 'I should see "Please login or register as a teacher"'
  
  
  step 'I go to the search instructional materials page'
  step 'I am on the search instructional materials page'
  
  #activity
  activity_id = Activity.find_by_name('Fluid Mechanics').id
  within(:xpath,"//div[@id = 'search_activity_#{activity_id}']") do
    step 'I follow "Assign to a Class"'
  end
  
  step 'I should be on the home page'
  step 'I should see "Please login or register as a teacher"'
end

And /^(?:|I )preview materials on the search instructional materials page$/ do
  #investigation
  investigation_id = Investigation.find_by_name('Geometry').id
  within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
    step 'I follow "Preview"'
  end
  step 'I receive a file for download with a filename like "_investigation_"'
  
  activity_id = Activity.find_by_name('Fluid Mechanics').id
  step 'I go to the search instructional materials page'
  within(:xpath,"//div[@id = 'search_activity_#{activity_id}']") do
    step 'I follow "Preview"'
  end
  step 'I receive a file for download with a filename like "_activity_"'
end

When /^(?:|I )should be able to filter the search results on the basis of domains and grades on the search instructional materials page$/ do
  
  step 'the project settings enables use of Grade Span Expectation'
  
  #domain
  step 'I check "Biological Science"'
  step 'I should see "Digestive System"'
  
  #grades
  step 'I am on the search instructional materials page'
  step 'I uncheck "All Grades"'
  step 'I should wait 2 seconds'
  step 'I check "5-6"'
  step 'I should wait 2 seconds'
  step 'I should not see "Digestive System"'
  step 'I should not see "Bile Juice"'
  step 'I check "10-11"'
  step 'I should wait 2 seconds'
  step 'I should see "Digestive System"'
  step 'I should see "Bile Juice"'
  step 'I check "All Grades"'
  step 'I should see "Digestive System"'
  step 'I should see "Bile Juice"'
  
  step 'the project setting for Grade Span Expectation is restored'
end

When /^(?:|I )should be able to filter the search results on the basis of probes on the search instructional materials page$/ do
  
  step 'the project settings enables use of Grade Span Expectation'
  
  step 'I check "random domain"'
  step 'I should wait 2 seconds'
  
  step 'I check "All Grades"'
  step 'I should wait 2 seconds'
  
  #probes
  step 'I check "UVA Intensity"'
  step 'I should wait 2 seconds'
  step 'I should not see "A Weather Underground"'
  step 'I should not see "A heat spontaneously"'
  step 'I check "Temperature"'
  step 'I should wait 2 seconds'
  step 'I should see "A Weather Underground"'
  step 'I should see "A heat spontaneously"'
  step 'I should see "Required equipment"'
  step 'I follow "All"'
  step 'I should wait 2 seconds'
  step 'I should see "A Weather Underground"'
  step 'I should see "A heat spontaneously"'
  step 'I follow "None"'
  step 'I should wait 2 seconds'
  step 'I should see "A Weather Underground"'
  step 'I should see "A heat spontaneously"'
  step 'I check "No Probes Required"'
  step 'I should not see "A Weather Underground"'
  step 'I should not see "A heat spontaneously"'
  
  step 'the project setting for Grade Span Expectation is restored'
end
When /^(?:|I )should be able to see number classes to which instructional materials are assigned on the search instructional materials page$/ do
  #investigation
  step 'the Investigation "differential calculus" is assigned to the class "Physics"'
  step 'the Investigation "differential calculus" is assigned to the class "Geography"'
  step 'the Investigation "differential calculus" is assigned to the class "Mathematics"'
  step 'I am on the search instructional materials page'
  within(:xpath,"//div[@class='material_list_item' and contains(., 'differential calculus')][1]") do
    step 'I should see "Used in 3 classes."'
  end
  #activity
  step 'the Activity "Geometry" is assigned to the class "Physics"'
  step 'the Activity "Geometry" is assigned to the class "Geography"'
  step 'the Activity "Geometry" is assigned to the class "Mathematics"'
  step 'I am on the search instructional materials page'
  within(:xpath,"//div[@class='material_list_item' and contains(., 'Geometry')][3]") do
    step 'I should see "Used in 3 classes."'
  end
end