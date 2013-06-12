require "spec_helper"

describe ItemsLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/items_locations").should route_to("items_locations#index")
    end

    it "routes to #new" do
      get("/items_locations/new").should route_to("items_locations#new")
    end

    it "routes to #show" do
      get("/items_locations/1").should route_to("items_locations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/items_locations/1/edit").should route_to("items_locations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/items_locations").should route_to("items_locations#create")
    end

    it "routes to #update" do
      put("/items_locations/1").should route_to("items_locations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/items_locations/1").should route_to("items_locations#destroy", :id => "1")
    end

  end
end
