When /^the following activities for the above investigations exist:$/ do |activity_table|
  activity_table.hashes.each do |hash|
    investigation_name = hash.delete('investigation')
    investigation = Investigation.find_by_name(investigation_name)
    hash[:investigation_id] = investigation.id
    hash[:user] = User.find_by_login(hash[:user])
    activity = Activity.create(hash)
    investigation.activities << activity
  end
end

When /^I enter search text "(.+)" on search instruction material page$/ do |search_text|
  step_text =  'I fill in "search_term" with "'+search_text+'"'
  step step_text
end

When /^I should see search suggestions for "(.+)" on search instruction material page$/ do|search_text|
  step_text =  'I should see "'+search_text+'" within suggestion box'
  step step_text
end

When /^I search study material "(.+)" on search instruction material page$/ do|search_text|
  step 'I fill in "search_term" with "'+search_text+'"'
  step 'I press "GO"'
end

When /^I should see search results for "(.+)" on search instruction material page$/ do|search_text|
  step 'I should see "'+search_text+'" within result box'
end

When /^I should be able to sort search and filter results on search instruction material page$/ do
  #sort order Alphabetical
  step 'I fill in "search_term" with "lines"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
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
  
  #assign activity to class
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
  
  
end

When /^I should be able to filter the search results on search instruction material page$/ do
  #grouping
  #Activity
  step 'I fill in "search_term" with "Geometry"'
  step 'I check "Activity"'
  step 'I press "GO"'
  step 'I should see /2 activities matching search term "Geometry" and selected criteria/'
  step 'I should see /Displaying all 2 activities/'
  step 'I should see "Geometry"'
  #Investigation
  step 'I fill in "search_term" with "Radioactivity"'
  step 'I check "Investigation"'
  step 'I press "GO"'
  step 'I should see /1 investigation matching search term "Radioactivity" and selected criteria/'
  step 'I should see /Displaying 1 investigation/'
  step 'I should see "Radioactivity"'

end

When /^the count of a search result is greater than the page size on search instruction material page$/ do
  step 'I fill in "search_term" with "is a great material"'
end

Then /the search results should be paginated on search instruction material page$/ do
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

Then /^I can assign investigations and activites to the class on search instruction material page$/ do
  #assigning investigations
  #before search
  investigation_id = Investigation.find_by_name('Geometry').id
  within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
    step 'I follow "Assign to a Class"'
  end
  step 'I check "Mathematics"'
  step 'I follow "Save"'
  step 'I go to the class page for "Mathematics"'
  step 'I should see "Geometry"'
  #After search
  step 'I am on the search instruction material page'
  step 'I fill in "search_term" with "graph theory"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
  #step 'I check "Investigation"'
  #step 'I should wait 2 seconds'
  within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][1]") do
    step 'I follow "Assign to a Class"'
  end
  step 'I check "Mathematics"'
  step 'I follow "Save"'
  step 'I go to the class page for "Mathematics"'
  step 'I should see "graph theory"'
  #assigning activity
  #Before Search
  activity_id = Activity.find_by_name('Fluid Mechanics').id
  step 'I am on the search instruction material page'
  within(:xpath,"//div[@id = 'search_activity_#{activity_id}']") do
    step 'I follow "Assign to a Class"'
  end
  step 'I check "Physics"'
  step 'I follow "Save"'
  step 'I go to the class page for "Physics"'
  step 'I should see "Fluid Mechanics"'
  #After search
  step 'I am on the search instruction material page'
  step 'I fill in "search_term" with "Circular Motion"'
  step 'I press "GO"'
  step 'I should wait 2 seconds'
  #step 'I check "Activity"'
  #step 'I should wait 2 seconds'
  step 'I follow "Assign to a Class"'
  step 'I check "Physics"'
  step 'I follow "Save"'
  step 'I go to the Instructional Materials page for "Physics"'
  step 'I should see "Circular Motion"'
end

Then /^I can preview investigations on search instruction material page$/ do
    #Preview investigations after search
    investigation_id = Investigation.find_by_name('Geometry').id
    within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
      step 'I follow "Preview"'
    end
    step 'I receive a file for download with a filename like "_investigation_"'
    #Preview investigations after search
    step 'I am on the search instruction material page'
    step 'I fill in "search_term" with "graph theory"'
    step 'I press "GO"'
    step 'I should wait 2 seconds'
    #step 'I check "Investigation"'
    #step 'I should wait 2 seconds'
    within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][1]") do
      step 'I follow "Preview"'
    end
    step 'I should wait 2 seconds'
    step 'I receive a file for download with a filename like "_investigation_"'
    
end


Then /^I can preview activities on search instruction material page$/ do
    #Preview activities
    within(:xpath, "//div[@class = 'results_container']/div[@class = 'materials_container'][2]//div[@class='material_list_item']") do
      step 'I follow "Preview"'
    end
    step 'I receive a file for download with a filename like "_activity_"'
end


And /^I assign materials on search instruction material page$/ do
 #investigation
 investigation_id = Investigation.find_by_name('Geometry').id
  within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
    step 'I follow "Assign to a Class"'
  end
  
  step 'I should be on my home page'
  step 'I go to the search instruction material page'
  step 'I should see "Please login or register as a teacher"'
  
  activity_id = Activity.find_by_name('Fluid Mechanics').id
  step 'I am on the search instruction material page'
  within(:xpath,"//div[@id = 'search_activity_#{activity_id}']") do
    step 'I follow "Assign to a Class"'
  end
end

And /^I preview materials$/ do
   #investigation
 investigation_id = Investigation.find_by_name('Geometry').id
  within(:xpath,"//div[@id = 'search_investigation_#{investigation_id}']") do
    step 'I follow "Preview"'
  end
  step 'I receive a file for download with a filename like ".jnlp"'
  activity_id = Activity.find_by_name('Fluid Mechanics').id
  step 'I go to the search instruction material page'
  within(:xpath,"//div[@id = 'search_activity_#{activity_id}']") do
    step 'I follow "Preview"'
  end
  step 'I receive a file for download with a filename like ".jnlp"'
end