require File.expand_path('../../../spec_helper', __FILE__)

describe  RiGse::BigIdeasController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "ri_gse/big_ideas" }.should route_to(:controller => "ri_gse/big_ideas", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "ri_gse/big_ideas/new" }.should route_to(:controller => "ri_gse/big_ideas", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "ri_gse/big_ideas/1" }.should route_to(:controller => "ri_gse/big_ideas", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "ri_gse/big_ideas/1/edit" }.should route_to(:controller => "ri_gse/big_ideas", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "ri_gse/big_ideas" }.should route_to(:controller => "ri_gse/big_ideas", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "ri_gse/big_ideas/1" }.should route_to(:controller => "ri_gse/big_ideas", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "ri_gse/big_ideas/1" }.should route_to(:controller => "ri_gse/big_ideas", :action => "destroy", :id => "1") 
    end
  end
end
