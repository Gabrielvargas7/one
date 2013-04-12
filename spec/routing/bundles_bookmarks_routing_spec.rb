require "spec_helper"

describe BundlesBookmarksController do
  describe "routing" do

    it "routes to #index" do
      get("/bundles_bookmarks").should route_to("bundles_bookmarks#index")
    end

    it "routes to #new" do
      get("/bundles_bookmarks/new").should route_to("bundles_bookmarks#new")
    end

    it "routes to #show" do
      get("/bundles_bookmarks/1").should route_to("bundles_bookmarks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bundles_bookmarks/1/edit").should route_to("bundles_bookmarks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bundles_bookmarks").should route_to("bundles_bookmarks#create")
    end

    it "routes to #update" do
      put("/bundles_bookmarks/1").should route_to("bundles_bookmarks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bundles_bookmarks/1").should route_to("bundles_bookmarks#destroy", :id => "1")
    end

  end
end
