require "spec_helper"

describe BookmarksCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/bookmarks_categories").should route_to("bookmarks_categories#index")
    end

    it "routes to #new" do
      get("/bookmarks_categories/new").should route_to("bookmarks_categories#new")
    end

    it "routes to #show" do
      get("/bookmarks_categories/1").should route_to("bookmarks_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bookmarks_categories/1/edit").should route_to("bookmarks_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bookmarks_categories").should route_to("bookmarks_categories#create")
    end

    it "routes to #update" do
      put("/bookmarks_categories/1").should route_to("bookmarks_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bookmarks_categories/1").should route_to("bookmarks_categories#destroy", :id => "1")
    end

  end
end
