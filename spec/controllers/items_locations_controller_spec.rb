require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ItemsLocationsController do

  # This should return the minimal set of attributes required to create a valid
  # ItemsLocation. As you add validations to ItemsLocation, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "item_id" => "1" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ItemsLocationsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all items_locations as @items_locations" do
      items_location = ItemsLocation.create! valid_attributes
      get :index, {}, valid_session
      assigns(:items_locations).should eq([items_location])
    end
  end

  describe "GET show" do
    it "assigns the requested items_location as @items_location" do
      items_location = ItemsLocation.create! valid_attributes
      get :show, {:id => items_location.to_param}, valid_session
      assigns(:items_location).should eq(items_location)
    end
  end

  describe "GET new" do
    it "assigns a new items_location as @items_location" do
      get :new, {}, valid_session
      assigns(:items_location).should be_a_new(ItemsLocation)
    end
  end

  describe "GET edit" do
    it "assigns the requested items_location as @items_location" do
      items_location = ItemsLocation.create! valid_attributes
      get :edit, {:id => items_location.to_param}, valid_session
      assigns(:items_location).should eq(items_location)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ItemsLocation" do
        expect {
          post :create, {:items_location => valid_attributes}, valid_session
        }.to change(ItemsLocation, :count).by(1)
      end

      it "assigns a newly created items_location as @items_location" do
        post :create, {:items_location => valid_attributes}, valid_session
        assigns(:items_location).should be_a(ItemsLocation)
        assigns(:items_location).should be_persisted
      end

      it "redirects to the created items_location" do
        post :create, {:items_location => valid_attributes}, valid_session
        response.should redirect_to(ItemsLocation.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved items_location as @items_location" do
        # Trigger the behavior that occurs when invalid params are submitted
        ItemsLocation.any_instance.stub(:save).and_return(false)
        post :create, {:items_location => { "item_id" => "invalid value" }}, valid_session
        assigns(:items_location).should be_a_new(ItemsLocation)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ItemsLocation.any_instance.stub(:save).and_return(false)
        post :create, {:items_location => { "item_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested items_location" do
        items_location = ItemsLocation.create! valid_attributes
        # Assuming there are no other items_locations in the database, this
        # specifies that the ItemsLocation created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ItemsLocation.any_instance.should_receive(:update_attributes).with({ "item_id" => "1" })
        put :update, {:id => items_location.to_param, :items_location => { "item_id" => "1" }}, valid_session
      end

      it "assigns the requested items_location as @items_location" do
        items_location = ItemsLocation.create! valid_attributes
        put :update, {:id => items_location.to_param, :items_location => valid_attributes}, valid_session
        assigns(:items_location).should eq(items_location)
      end

      it "redirects to the items_location" do
        items_location = ItemsLocation.create! valid_attributes
        put :update, {:id => items_location.to_param, :items_location => valid_attributes}, valid_session
        response.should redirect_to(items_location)
      end
    end

    describe "with invalid params" do
      it "assigns the items_location as @items_location" do
        items_location = ItemsLocation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ItemsLocation.any_instance.stub(:save).and_return(false)
        put :update, {:id => items_location.to_param, :items_location => { "item_id" => "invalid value" }}, valid_session
        assigns(:items_location).should eq(items_location)
      end

      it "re-renders the 'edit' template" do
        items_location = ItemsLocation.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ItemsLocation.any_instance.stub(:save).and_return(false)
        put :update, {:id => items_location.to_param, :items_location => { "item_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested items_location" do
      items_location = ItemsLocation.create! valid_attributes
      expect {
        delete :destroy, {:id => items_location.to_param}, valid_session
      }.to change(ItemsLocation, :count).by(-1)
    end

    it "redirects to the items_locations list" do
      items_location = ItemsLocation.create! valid_attributes
      delete :destroy, {:id => items_location.to_param}, valid_session
      response.should redirect_to(items_locations_url)
    end
  end

end