require 'spec_helper'


describe LocationsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @section = FactoryGirl.create(:section)
    @location = FactoryGirl.create(:location,section_id:@section.id)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @location }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:location_all) { Location.all }

      it "assigns all location as @location" do
        get :index
        assigns(:locations).should eq(location_all)
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

      it "assigns the requested location as @location" do
        get :show, id: @location
        assigns(:location).should eq(@location)

      end

      it "renders the #show view" do

        get :show, id: @location
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@location
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@location
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new location as @location" do

        new_section = FactoryGirl.create(:section)
        new_location = FactoryGirl.create(:location,section_id:new_section.id)
        Location.should_receive(:new).and_return(new_location)
        get :new
        assigns[:location].should eq(new_location)
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

      it "assigns the requested location as @location" do
        new_section = FactoryGirl.create(:section)
        new_location = FactoryGirl.create(:location,section_id:new_section.id)
        get :edit, id: new_location
        assigns[:location].should eq(new_location)
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

        get :edit, id: new_location
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

        it "creates a new location" do

          expect {
            post :create,location: FactoryGirl.attributes_for(:location,section_id:@section.id)
          }.to change(Location, :count).by(1)


        end

        it "assigns a newly created location as @location" do
          post :create,location: FactoryGirl.attributes_for(:location,section_id:@section.id)
          assigns(:location).should be_a(Location)
          assigns(:location).should be_persisted
        end

        it "redirects to the created location" do
          post :create, location: FactoryGirl.attributes_for(:location,section_id:@section.id)
          response.should redirect_to(Location.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create, location: FactoryGirl.attributes_for(:location,section_id:nil)
            }.to_not change(Location,:count)
          end
          it "re-renders the new method" do
            post :create, location: FactoryGirl.attributes_for(:location,section_id:nil)
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
        post :create, location: FactoryGirl.attributes_for(:location,section_id:@section.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created location" do
        post :create, location: FactoryGirl.attributes_for(:location,section_id:@section.id)
        response.should_not redirect_to(Location.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************

  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @location" do
          put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:@section.id)
          assigns(:location).should eq(@location)
        end
      end

      it "changes @section's attributes" do
        put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:@section.id,x:111,y:222,z:333)
        @location.reload
        @location.section_id.should eq(@section.id)
        @location.x.should eq(111)
        @location.y.should eq(222)
        @location.z.should eq(333)
      end

      it "redirects to the updated section" do
        put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:@section.id,x:111,y:222,z:333)
        response.should redirect_to @location
      end

      context "invalid attributes" do

        it "locates the requested @location" do
          #put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme,name:nil)
          put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:nil,x:111,y:222,z:333)
          assigns(:location).should eq(@location)
        end

        it "does not change @theme's attributes" do

          put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:nil,x:111,y:222,z:333)
          @location.reload
          @location.section_id.should eq(@section.id)
          @location.x.should_not eq(111)
          @location.y.should_not eq(222)
          @location.z.should_not eq(333)

        end
        it "re-renders the edit method" do
          put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:nil,x:111,y:222,z:333)
          response.should render_template :edit
        end
      end
    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :update, id: @location, location: FactoryGirl.attributes_for(:location,section_id:@section.id,x:111,y:222,z:333)
        response.should redirect_to root_path
      end

    end


  end



end
