require "spec_helper"

describe UsersPhotosController do
  describe "routing" do

    it "routes to #index" do
      get("/users_photos").should route_to("users_photos#index")
    end

    it "routes to #new" do
      get("/users_photos/new").should route_to("users_photos#new")
    end

    it "routes to #show" do
      get("/users_photos/1").should route_to("users_photos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/users_photos/1/edit").should route_to("users_photos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/users_photos").should route_to("users_photos#create")
    end

    it "routes to #update" do
      put("/users_photos/1").should route_to("users_photos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/users_photos/1").should route_to("users_photos#destroy", :id => "1")
    end

  end
end
