require 'spec_helper'


describe SectionsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @section = FactoryGirl.create(:section)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @section }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:section_all) { Section.all }

      it "assigns all section as @section" do
        get :index
        assigns(:sections).should eq(section_all)
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

      it "assigns the requested Section as @Section" do
        get :show, id: @section
        assigns(:section).should eq(@section)

      end

      it "renders the #show view" do

        get :show, id: @section
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@section
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@section
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new section as @section" do

        new_section = FactoryGirl.create(:section)
        Section.should_receive(:new).and_return(new_section)
        get :new
        assigns[:section].should eq(new_section)
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

      it "assigns the requested section as @section" do

        new_section = FactoryGirl.create(:section)
        get :edit, id: new_section
        assigns[:section].should eq(new_section)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        new_section = FactoryGirl.create(:section)
        get :edit, id: new_section
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

        it "creates a new section" do

          expect {
            post :create,section: FactoryGirl.attributes_for(:section)
          }.to change(Section, :count).by(1)


        end

        it "assigns a newly created section as @section" do
          post :create,section: FactoryGirl.attributes_for(:section)
          assigns(:section).should be_a(Section)
          assigns(:section).should be_persisted
        end

        it "redirects to the created section" do
          post :create, section: FactoryGirl.attributes_for(:section)
          response.should redirect_to(Section.last)
        end
      end

    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create, section: FactoryGirl.attributes_for(:section)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created section" do
        post :create, section: FactoryGirl.attributes_for(:section)
        response.should_not redirect_to(Section.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @section" do
          put :update, id: @section, section: FactoryGirl.attributes_for(:section)
          assigns(:section).should eq(@section)
        end
      end

      it "changes @section's attributes" do
        put :update, id: @section, section: FactoryGirl.attributes_for(:section, name: "new section", description: "new desc")
        @section.reload
        @section.name.should eq("new section")
        @section.description.should eq("new desc")
      end

      it "redirects to the updated section" do
        put :update, id: @section, section: FactoryGirl.attributes_for(:section)
        response.should redirect_to @section
      end

    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :update, id: @section, section: FactoryGirl.attributes_for(:section)
        response.should redirect_to root_path
      end

    end


  end






end
