require 'spec_helper'


describe UsersProfilesController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    @admin = FactoryGirl.create(:admin)
    @users_profile = UsersProfile.find_all_by_user_id(@admin.id).first
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @users_profile }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:users_profiles_all) { UsersProfile.all }

      it "assigns all user profile  as @user profile" do
        get :index
        assigns(:users_profiles).should eq(users_profiles_all)
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

      it "assigns the requested user photos as @user profile" do
        get :show, id: @users_profile
        assigns(:users_profile).should eq(@users_profile)

      end

      it "renders the #show view" do

        get :show, id: @users_profile
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@users_profile
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@users_profile
        response.should_not render_template :show
      end

    end
  end


  #***********************************
  # rspec test  edit
  #***********************************


  describe "GET edit", tag_edit:true do

    context "is admin user"  do

      it "assigns the requested user profile as @user profile" do


        get :edit, id: @users_profile
        assigns[:users_profile].should eq(@users_profile)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do

        get :edit, id: @users_profile
        response.should redirect_to root_path
      end
    end

  end


  #***********************************
  # rspec test  update
  #***********************************

  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @user profile" do
          put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@admin.id)
          assigns(:users_profile).should eq(@users_profile)
        end
      end

      it "changes @user profile's attributes" do
        put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@admin.id,firstname:"juan",lastname:"lopez")
        @users_profile.reload
        @users_profile.firstname.should eq("juan")
        @users_profile.lastname.should eq("lopez")
      end

      it "redirects to the updated users profile " do
        put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@admin.id,firstname:"juan",lastname:"lopez")
        response.should redirect_to @users_profile
      end

      context "invalid attributes" do

        it "locates the requested @user photos" do
          put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:nil,firstname:"juan",lastname:"lopez")
          assigns(:users_profile).should eq(@users_profile)
        end

        it "does not change @users photo's attributes" do
          put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:nil,firstname:"juan",lastname:"lopez")
          @users_profile.reload
          @users_profile.firstname.should_not eq("juan")
          @users_profile.lastname.should_not eq("lopez")
        end
        it "re-renders the edit method" do
          put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:nil,firstname:"juan",lastname:"lopez")
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
        put :update, id: @users_profile, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:nil,firstname:"juan",lastname:"lopez")
        response.should redirect_to root_path
      end
    end
  end


  #***********************************
  # rspec test  show_by_user_id
  #***********************************


  describe "GET show by user id", tag_show_user:true do

    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
      @regular_user_profile = UsersProfile.find_all_by_user_id(@user.id).first
    end
    context "is regular user" do

      it "assigns the requested user photos as @user profile" do
        get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
        assigns(:users_profile).should eq(@regular_user_profile)
      end

      it "renders the #show view" do

        get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
        response.should render_template :show_users_profiles_by_user_id
      end

    end

    context "is sign out  user" do
      before do
        sign_out
      end

      it "redirect to root " do
        get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
        response.should_not render_template :show_by_user_id
      end

    end
  end

  #***********************************
  # rspec test  edit_by_user_id
  #***********************************


  describe "GET edit_users_profile by user id", tag_edit_user:true do
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
      @regular_user_profile = UsersProfile.find_all_by_user_id(@user.id).first
    end

    context "is regular user"  do

      it "assigns the requested user profile as @user profile" do


        get :edit_users_profiles_by_user_id, id: @regular_user_profile.user_id
        assigns[:users_profile].should eq(@regular_user_profile)
      end
    end

    context "is sight out user" do

      before do
        sign_out

      end

      it "redirect to root " do
        get :edit_users_profiles_by_user_id, id: @regular_user_profile.user_id
        response.should redirect_to root_path
      end
    end

  end


  #***********************************
  # rspec test  update_by_user_id
  #***********************************

  describe "PUT update by user id", tag_update_user:true do
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
      @regular_user_profile = UsersProfile.find_all_by_user_id(@user.id).first
    end

    describe "is regular user" do

      context "valid attributes" do
        it "located the requested @user profile" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@user.id)
          assigns(:users_profile).should eq(@regular_user_profile)
        end
      end

      it "changes @user profile's attributes" do
        put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@user.id,firstname:"juan",lastname:"lopez")
        @regular_user_profile.reload
        @regular_user_profile.firstname.should eq("juan")
        @regular_user_profile.lastname.should eq("lopez")
      end

      it "redirects to the updated users profile " do
        put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@user.id,firstname:"juan",lastname:"lopez")
        response.should redirect_to show_users_profiles_by_user_id_path(@regular_user_profile.user_id)
      end

      context "invalid attributes" do

        it "locates the requested @user photos" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@user.id,firstname:"juan",lastname:"lopez")
          assigns(:users_profile).should eq(@regular_user_profile)
        end

        it "does not change @users photo's attributes" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:nil,firstname:"juan",lastname:"lopez")
          @regular_user_profile.reload
          @regular_user_profile.firstname.should_not eq("juan")
          @regular_user_profile.lastname.should_not eq("lopez")

        end
        it "re-renders the edit method" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:nil,firstname:"juan",lastname:"lopez")
          response.should render_template :edit_users_profiles_by_user_id
        end
      end
    end

    describe "is sign out user" do
      before do

        sign_out
      end

      it "redirects to root " do
        put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile,user_id:@user.id,firstname:"juan",lastname:"lopez")
        response.should redirect_to root_path
      end
    end
  end







end
