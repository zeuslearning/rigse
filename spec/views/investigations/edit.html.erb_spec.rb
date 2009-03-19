require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/edit.html.erb" do
  include InvestigationsHelper
  
  before(:each) do
    assigns[:investigation] = @investigation = stub_model(Investigation,
      :new_record? => false,
      :title => "value for title",
      :context => "value for context",
      :opportunities => "value for opportunities",
      :objectives => "value for objectives",
      :procedures_opening => "value for procedures_opening",
      :procedures_engagement => "value for procedures_engagement",
      :procedures_closure => "value for procedures_closure",
      :assessment => "value for assessment",
      :reflection => "value for reflection"
    )
  end

  it "should render edit form" do
    render "/pages/edit.html.erb"
    
    response.should have_tag("form[action=#{investigation_path(@investigation)}][method=post]") do
      with_tag('input#investigation_title[name=?]', "investigation[title]")
      with_tag('textarea#investigation_context[name=?]', "investigation[context]")
      with_tag('textarea#investigation_opportunities[name=?]', "investigation[opportunities]")
      with_tag('textarea#investigation_objectives[name=?]', "investigation[objectives]")
      with_tag('textarea#investigation_procedures_opening[name=?]', "investigation[procedures_opening]")
      with_tag('textarea#investigation_procedures_engagement[name=?]', "investigation[procedures_engagement]")
      with_tag('textarea#investigation_procedures_closure[name=?]', "investigation[procedures_closure]")
      with_tag('textarea#investigation_assessment[name=?]', "investigation[assessment]")
      with_tag('textarea#investigation_reflection[name=?]', "investigation[reflection]")
    end
  end
end


