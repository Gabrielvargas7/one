require 'spec_helper'

describe ItemsLocationsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    @section = FactoryGirl.create(:section)
    @location = FactoryGirl.create(:location,section_id:@section.id )
    @item = FactoryGirl.create(:item)
    @items_design = FactoryGirl.create(:items_design,item_id:@item.id)
    @items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @items_location }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:items_location_all) { ItemsLocation.all }


      it "assigns all items_locations as @items_locations" do
        get :index
        assigns(:items_locations).should eq(items_location_all)

      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :index
        response.should redirect_to root_path
      end

      it "not render to index " do
        get :index
        response.should_not render_template :index
      end
    end

  end

  #***********************************
  # rspec test  show
  #***********************************

  describe "GET show", tag_show:true do

    context "is admin user" do

      it "assigns the requested items_location as @items_location" do
        get :show, id: @items_location
        assigns(:items_location).should eq(@items_location)

      end

      it "renders the #show view" do

        get :show, id: @items_location
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@items_location
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@items_location
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new items_location as @items_location" do

        new_section = FactoryGirl.create(:section)
        new_location = FactoryGirl.create(:location,section_id:new_section.id)
        new_items_location = FactoryGirl.create(:items_location,location_id:new_location.id,item_id:@item.id)
        ItemsLocation.should_receive(:new).and_return(new_items_location)
        get :new
        assigns[:items_location].should eq(new_items_location)
      end
    end
    context "is not admin user"  do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root" do
        get :new
        response.should redirect_to root_path
      end
    end

  end

  #***********************************
  # rspec test  edit
  #***********************************


  describe "GET edit", tag_edit:true do

    context "is admin user"  do

      it "assigns the requested items_location as @items_location" do
        new_section = FactoryGirl.create(:section)
        new_location = FactoryGirl.create(:location,section_id:new_section.id)
        new_items_location = FactoryGirl.create(:items_location,location_id:new_location.id,item_id:@item.id)

        get :edit, id: new_items_location
        assigns[:items_location].should eq(new_items_location)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_section = FactoryGirl.create(:section)
        new_location = FactoryGirl.create(:location,section_id:new_section.id)
        new_items_location = FactoryGirl.create(:items_location,location_id:new_location.id,item_id:@item.id)

        get :edit, id: new_items_location
        response.should redirect_to root_path
      end
    end
  end


  #***********************************
  # rspec test create
  #***********************************


  describe "POST create", tag_create:true  do

    describe "is admin user" do
      context "with valid params" do

        it "creates a new items_location" do

          expect {
            post :create,items_location: FactoryGirl.attributes_for(:items_location,location_id:@location.id,item_id:@item.id)
          }.to change(ItemsLocation, :count).by(1)


        end

        it "assigns a newly created items_location as @items_location" do
          post :create,items_location: FactoryGirl.attributes_for(:items_location,location_id:@location.id,item_id:@item.id)
          assigns(:items_location).should be_a(ItemsLocation)
          assigns(:items_location).should be_persisted
        end

        it "redirects to the created items_location" do
          post :create, items_location: FactoryGirl.attributes_for(:items_location,location_id:@location.id,item_id:@item.id)
          response.should redirect_to(ItemsLocation.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create, items_location: FactoryGirl.attributes_for(:items_location,location_id:@location.id,item_id:nil)
            }.to_not change(Location,:count)

            expect{ post :create, items_location: FactoryGirl.attributes_for(:items_location,location_id:nil,item_id:@item.id)
            }.to_not change(Location,:count)

          end
          it "re-renders the new method" do

            post :create, items_location: FactoryGirl.attributes_for(:items_location,location_id:nil,item_id:@item.id)
            response.should render_template :new
          end
        end
      end
    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create, items_location: FactoryGirl.attributes_for(:items_location,location_id:@location.id,item_id:@item.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created items_location" do
        post :create, items_location: FactoryGirl.attributes_for(:items_location,location_id:@location.id,item_id:@item.id)
        response.should_not redirect_to(ItemsLocation.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************

  #describe "PUT update", tag_update:true do
  #  before do
  #    @new_section = FactoryGirl.create(:section)
  #    @new_location = FactoryGirl.create(:location,section_id:@new_section.id)
  #    @new_item = FactoryGirl.create(:item)
  #
  #  end
  #
  #  describe "is admin user" do
  #
  #    context "valid attributes" do
  #      it "located the requested @items_location" do
  #
  #        put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:@new_location.id,item_id:@new_item.id)
  #        assigns(:items_location).should eq(@items_location)
  #      end
  #    end
  #
  #    it "changes @section's attributes" do
  #      put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:@new_location.id,item_id:@new_item.id)
  #      @items_location.reload
  #      @items_location.location_id.should eq(@new_location.id)
  #      @items_location.item_id.should eq(@new_item.id)
  #
  #    end
  #
  #    it "redirects to the updated section" do
  #      put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:@new_location.id,item_id:@new_item.id)
  #      response.should redirect_to @items_location
  #    end
  #
  #    context "invalid attributes" do
  #
  #      it "locates the requested @items_location" do
  #        #put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme,name:nil)
  #        put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:@new_location.id,item_id:nil)
  #        assigns(:items_location).should eq(@items_location)
  #      end
  #
  #      it "does not change @theme's attributes" do
  #
  #        put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:@new_location.id,item_id:-1)
  #        @items_location.reload
  #        @items_location.item_id.should_not eq(-1)
  #        @items_location.location_id.should_not eq(@new_location.id)
  #
  #        put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:-1,item_id:@new_item.id)
  #        @items_location.reload
  #        @items_location.item_id.should_not eq(@new_item.id)
  #        @items_location.location_id.should_not eq(-1)
  #
  #
  #      end
  #      it "re-renders the edit method" do
  #        put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:-1,item_id:@new_item.id)
  #        response.should render_template :edit
  #      end
  #    end
  #  end
  #
  #  describe "is not admin user" do
  #    before do
  #      @user  = FactoryGirl.create(:user)
  #      sign_in @user
  #    end
  #
  #    it "redirects to root " do
  #      put :update, id: @items_location, items_location: FactoryGirl.attributes_for(:items_location,location_id:@new_location.id,item_id:@new_item.id)
  #      response.should redirect_to root_path
  #    end
  #  end
  #
  #end


end
