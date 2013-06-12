require "spec_helper"

describe BundlesItemsDesignsController do
  describe "routing" do

    it "routes to #index" do
      get("/bundles_items_designs").should route_to("bundles_items_designs#index")
    end

    it "routes to #new" do
      get("/bundles_items_designs/new").should route_to("bundles_items_designs#new")
    end

    it "routes to #show" do
      get("/bundles_items_designs/1").should route_to("bundles_items_designs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bundles_items_designs/1/edit").should route_to("bundles_items_designs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bundles_items_designs").should route_to("bundles_items_designs#create")
    end

    it "routes to #update" do
      put("/bundles_items_designs/1").should route_to("bundles_items_designs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bundles_items_designs/1").should route_to("bundles_items_designs#destroy", :id => "1")
    end

  end
end
