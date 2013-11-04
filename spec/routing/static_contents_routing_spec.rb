require "spec_helper"

describe StaticContentsController do
  describe "routing" do

    it "routes to #index" do
      get("/static_contents").should route_to("static_contents#index")
    end

    it "routes to #new" do
      get("/static_contents/new").should route_to("static_contents#new")
    end

    it "routes to #show" do
      get("/static_contents/1").should route_to("static_contents#show", :id => "1")
    end

    it "routes to #edit" do
      get("/static_contents/1/edit").should route_to("static_contents#edit", :id => "1")
    end

    it "routes to #create" do
      post("/static_contents").should route_to("static_contents#create")
    end

    it "routes to #update" do
      put("/static_contents/1").should route_to("static_contents#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/static_contents/1").should route_to("static_contents#destroy", :id => "1")
    end

  end
end
