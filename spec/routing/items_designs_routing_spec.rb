require "spec_helper"

describe ItemsDesignsController do
  describe "routing" do

    it "routes to #index" do
      get("/items_designs").should route_to("items_designs#index")
    end

    it "routes to #new" do
      get("/items_designs/new").should route_to("items_designs#new")
    end

    it "routes to #show" do
      get("/items_designs/1").should route_to("items_designs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/items_designs/1/edit").should route_to("items_designs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/items_designs").should route_to("items_designs#create")
    end

    it "routes to #update" do
      put("/items_designs/1").should route_to("items_designs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/items_designs/1").should route_to("items_designs#destroy", :id => "1")
    end

  end
end
