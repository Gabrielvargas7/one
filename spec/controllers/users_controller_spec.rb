require 'spec_helper'


describe UsersController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @theme = FactoryGirl.create(:theme)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  subject { @admin }

  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:users_all) { User.all }

      it "assigns all users as @users" do
        get :index
        assigns(:users).should eq(users_all)
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
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
    end


    context "is admin user" do

      it "assigns the requested users as @users" do
        get :show, id: @user
        assigns(:user).should eq(@user)

      end

      it "renders the #show view" do

        get :show, id: @user
        response.should render_template :show
      end

    end

    context "is not current user" do
      before do
        @user1  = FactoryGirl.create(:user)
      end

      it "redirect to root " do
        get :show, id:@user1
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@user1
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do
    before do
      sign_out
    end


    context "is not current  user"  do
      it "assigns a new users as @users" do

        new_user = FactoryGirl.create(:user)
        User.should_receive(:new).and_return(new_user)
        get :new
        assigns[:user].should eq(new_user)
      end
    end
  end

  #***********************************
  # rspec test  edit
  #***********************************


  describe "GET edit", tag_edit:true do
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
    end


    context "is current user"  do

      it "assigns the requested user as @user" do
        get :edit, id: @user
        assigns[:user].should eq(@user)
      end
    end

    context "is not current user" do

      before do
        sign_out
      end

      it "redirect to root " do
        get :edit, id: @user
        response.should redirect_to root_path
      end
    end

  end


  #***********************************
  # rspec test create
  #***********************************


  describe "POST create", tag_create: true  do
    before do
      sign_out
    end

    describe "is not user" do
      context "with valid params" do

        it "creates a new User" do

          expect {
            post :create,user: FactoryGirl.attributes_for(:user)
          }.to change(User, :count).by(1)


        end

        it "assigns a newly created user as @user" do
          post :create,user: FactoryGirl.attributes_for(:user)
          assigns(:user).should be_a(User)
          assigns(:user).should be_persisted
        end

        it "redirects to the room of the user" do
          post :create, user: FactoryGirl.attributes_for(:user)

          #response.should  redirect_to room_rooms_path(User.last.username,:anchor => "")
          response.should  redirect_to room_rooms_path(User.last.username)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create, user: FactoryGirl.attributes_for(:user,email:nil)
            }.to_not change(User,:count)
          end
          it "re-renders the new method" do
            post :create, user: FactoryGirl.attributes_for(:user,email:nil)
            response.should render_template :new
          end
        end

      end

    end

  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
    end


    describe "is current user" do

      context "valid attributes" do
        it "located the requested @user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user)
          assigns(:user).should eq(@user)
        end
      end

      it "changes @user's attributes" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user, username: "larry")
        @user.reload
        @user.username.should eq("larry")
      end

      it "redirects to the updated user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to @user
      end

      context "invalid attributes" do

        it "locates the requested @user" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user,username:nil)
          assigns(:user).should eq(@user)
        end
        it "re-renders the edit method" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user,username:nil)
          response.should render_template :edit
        end

        it "re-renders the edit method when is invalid username" do
          put :update, id: @user, user: FactoryGirl.attributes_for(:user,username:"one%%$$one")
          response.should render_template :edit
        end


      end
    end

    describe "is not sign up user" do
      before do
        sign_out
      end

      it "redirects to root " do
        put :update, id: @user, user: FactoryGirl.attributes_for(:user)
        response.should redirect_to root_path
      end
    end
  end




  ##***********************************
  ## rspec test  #json_show_user_profile_by_user_id
  ##***********************************
  #
  #  /users/json/show_user_profile_by_user_id/:user_id

  describe "api #json_show_user_profile_by_user_id",tag_json_profile:true do

    describe "profile" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end


      it "should be successful" do
        get :json_show_user_profile_by_user_id,user_id:@user.id, :format => :json
        response.should be_success
      end

      it "should set theme" do

        get :json_show_user_profile_by_user_id,user_id:@user.id, :format => :json
        assigns(:user).as_json.should == @user.as_json
      end

      it "has a 200 status code" do
        get :json_show_user_profile_by_user_id,user_id:@user.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index theme in json" do # depend on what you return in action
          get :json_show_user_profile_by_user_id,user_id:@user.id, :format => :json
          body = JSON.parse(response.body)
            body["username"].should == @user.username
            body["email"].should == @user.email


        end
      end

      context "is sign in with other user" do
        before do
          @user3 = FactoryGirl.create(:user)
          sign_in @user3
        end
        it "has a 404 status code" do
          get :json_show_user_profile_by_user_id,user_id:@user.id, :format => :json
          expect(response.status).to eq(404)
        end
      end


      context "is sign out user" do
        before do
          sign_out
        end
        it "has a 404 status code" do
          get :json_show_user_profile_by_user_id,user_id:@user.id, :format => :json
          expect(response.status).to eq(404)
        end
      end


   end
  end

  ##***********************************
  ## rspec test  #json_show_signed_user
  ##***********************************

  describe "api #json_show_signed_user",tag_json_signed_user:true do

    describe "profile" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :json_show_signed_user, :format => :json
        response.should be_success
      end

      it "should get user" do

        get :json_show_signed_user, :format => :json
        assigns(:current_user).as_json.should == @user.as_json
      end

      it "has a 200 status code" do
        get :json_show_signed_user, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_show_signed user" do # depend on what you return in action
          get :json_show_signed_user, :format => :json
          body = JSON.parse(response.body)
          body["id"].should == @user.id
          body["username"].should == @user.username

        end
      end

      context "is sign out user" do
        before do
          sign_out
        end
        it "has a 404 status code" do
          get :json_show_signed_user, :format => :json
          expect(response.status).to eq(404)
        end
      end


    end
  end




  ##  /users/json/create_user_full_bundle_by_user_id_and_bundle_id/:user_id/:bundle_id

  ##***********************************
  ## rspec test json_create_user_full_bundle_by_user_id_and_bundle_id
  ##***********************************

  describe "POST json_create_user_full_bundle_by_user_id_and_bundle_id", tag_json_create:true  do
    before do
      @bundle = Bundle.where("active='y'").first
      @user  = FactoryGirl.create(:user)
      sign_in @user
    end


    describe "is regular user" do
      context "with valid params" do


        it "assigns a newly created user bundle as @bundle" do
          post :json_create_user_full_bundle_by_user_id_and_bundle_id, user_id:@user.id,bundle_id:@bundle.id, :format => :json
          assigns(:user_theme).should be_a(UsersTheme)
          assigns(:user_theme).should be_persisted
          assigns(:user_items_design).should be_a(UsersItemsDesign)
          assigns(:user_items_design).should be_persisted
        end

        it "response should be success" do
          post :json_create_user_full_bundle_by_user_id_and_bundle_id, user_id:@user.id,bundle_id:@bundle.id, :format => :json
          response.should be_success
        end

        it "has a 200 status code" do
          post :json_create_user_full_bundle_by_user_id_and_bundle_id, user_id:@user.id,bundle_id:@bundle.id, :format => :json
          expect(response.status).to eq(200)
        end

        context "return json values " do
          it "should return user theme and items design in json" do # depend on what you return in action

            post :json_create_user_full_bundle_by_user_id_and_bundle_id, user_id:@user.id,bundle_id:@bundle.id, :format => :json
            body = JSON.parse(response.body)
            #puts "body ---- > "+body.to_s
            #puts body["user_friend_req"]["user_id"].to_s
            @user_theme_json = UsersTheme.find(body["user_theme"]["id"])
            body["user_theme"]["user_id"].should == @user_theme_json.user_id
            body["user_theme"]["section_id"].should == @user_theme_json.section_id
            body["user_theme"]["theme_id"].should == @user_theme_json.theme_id

            body["users_items_design"].each do |body_item|
              @item_json = UsersItemsDesign.find(body_item["id"])
              body_item["hide"].should == @item_json.hide
              body_item["items_design_id"].should == @item_json.items_design_id
              body_item["location_id"].should == @item_json.location_id
              body_item["user_id"].should == @item_json.user_id
            end

          end
        end

      end
    end

    context "is sign in with other user" do
      before do
        @user3 = FactoryGirl.create(:user)
        sign_in @user3
      end
      it "has a 404 status code" do
        post :json_create_user_full_bundle_by_user_id_and_bundle_id, user_id:@user.id,bundle_id:@bundle.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        post :json_create_user_full_bundle_by_user_id_and_bundle_id, user_id:@user.id,bundle_id:@bundle.id, :format => :json
        expect(response.status).to eq(404)
      end
    end

  end


  describe "json_is_signed_user", tag_json_signed:true do

    describe "sign_in user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should be successful" do
        get :json_is_signed_user, :format => :json
        response.should be_success
      end

      it "should get json object {'signed':'yes'}" do
        @is_signed_user = JSON.parse('{"signed":"yes"}')
        get :json_is_signed_user, :format => :json
        assigns(:is_signed_user).as_json.should ==  @is_signed_user
      end

      it "has a 200 status code" do
        get :json_is_signed_user, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_is_signed_user" do # depend on what you return in action
          get :json_is_signed_user, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          body["signed"].should == "yes"
          #body["username"].should == @user.username

        end
      end
    end

    describe "sign_out user" do
      before do
        sign_out
      end

      it "should be successful" do
        get :json_is_signed_user, :format => :json
        response.should be_success
      end

      it "should get json object {'signed':'not'}" do
        @is_signed_user = JSON.parse('{"signed":"not"}')
        get :json_is_signed_user, :format => :json
        assigns(:is_signed_user).as_json.should ==  @is_signed_user
      end

      it "has a 200 status code" do
        get :json_is_signed_user, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_is_signed_user" do # depend on what you return in action
          get :json_is_signed_user, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          body["signed"].should == "not"
          #body["username"].should == @user.username

        end
      end
    end

  end









end
