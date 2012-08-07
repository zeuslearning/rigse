module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

    when "the page"
      "html > body"
    when "left panel for class navigation"
      "div#clazzes_nav"
    when "the popup"
      "div.ui-window div.content"
    when "the tab block for Instructional Materials"
      "div#oTabcontainer"
    when "activity button list of Instructional Material page"
      "table.materials"
    when "the first recent activity on the recent activity page"
      [:xpath, "//div[@class=\"recent_activity_container\"]/div[1]"]
    when "the search suggestion"
      [:xpath, "//div[@id='suggestions']"]
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #  when /^the (notice|error|info) flash$/
    #    ".flash.#{$1}"

    # You can also return an array to use a different selector
    # type, like:
    #
    #  when /the header/
    #    [:xpath, "//header"]

    # This allows you to provide a quoted selector as the scope
    # for "within" steps as was previously the default for the
    # web steps:
    when /^"(.+)"$/
      $1
    when /^(#.+)$/
      $1

    else
      raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)
