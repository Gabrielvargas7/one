require "spec_helper"

describe UsersProfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/users_profiles").should route_to("users_profiles#index")
    end

    it "routes to #new" do
      get("/users_profiles/new").should route_to("users_profiles#new")
    end

    it "routes to #show" do
      get("/users_profiles/1").should route_to("users_profiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/users_profiles/1/edit").should route_to("users_profiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/users_profiles").should route_to("users_profiles#create")
    end

    it "routes to #update" do
      put("/users_profiles/1").should route_to("users_profiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/users_profiles/1").should route_to("users_profiles#destroy", :id => "1")
    end

  end
end
