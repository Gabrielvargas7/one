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
  # rspec test  new  Note: this action is a no-op
  #***********************************

  describe "GET new", tag_new: true do

    context "user is an admin" do

      it "should render the new template" do
        get :new
        expect(response).to render_template :new
      end

    end


    context "user not an admin" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        get :new
        expect(response).to redirect_to root_path
      end

      it "does not render new template" do
        get :new
        expect(response).to_not render_template :new
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
  # rspec test  create
  #***********************************

  describe "POST create", tag_create: true do

    context "user is an admin" do

      # The test below will fail b/c we there isn't a corresponding view / redirection
      xit "does not increment user profile count" do

        expect {
          post :create
        }.to_not change(UsersProfile, :count)
      end
    end


    context "user is not an admin" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create
        expect(response).to redirect_to root_path
      end

      it "does not increment user profile count" do

        expect {
          post :create
        }.to_not change(UsersProfile, :count)
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
  # rspec test  destroy
  #***********************************

  describe "DELETE destroy", tag_destroy: true do

    context "user is an admin" do

      it "should redirect to users_profiles_url when html request" do
        delete :destroy, :format => :html
        expect(response).to redirect_to users_profiles_url
      end


      it "should have no content when json request" do
        delete :destroy, :format => :json
        expect(response.code).to eq("204")
      end

      it "should not change the UsersProfiles count" do
        expect {
          post :destroy
        }.to_not change(UsersProfile, :count)
      end
    end


    context "user is not an admin" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "should redirect to root" do
        delete :destroy
        expect(response).to redirect_to root_path
      end
    end

  end



  #***********************************
  # rspec test  show_by_user_id   <-- method commented out in controller
  #***********************************


  # describe "GET show by user id", tag_show_user:true do

  #   before do
  #     @user  = FactoryGirl.create(:user)
  #     sign_in @user
  #     @regular_user_profile = UsersProfile.find_all_by_user_id(@user.id).first
  #   end
  #   context "is regular user" do

  #     it "assigns the requested user photos as @user profile" do
  #       get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
  #       assigns(:users_profile).should eq(@regular_user_profile)
  #     end

  #     it "renders the #show view" do

  #       get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
  #       response.should render_template :show_users_profiles_by_user_id
  #     end

  #   end

  #   context "is sign out  user" do
  #     before do
  #       sign_out
  #     end

  #     it "redirect to root " do
  #       get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
  #       response.should redirect_to root_path
  #     end

  #     it "not render to show " do
  #       get :show_users_profiles_by_user_id, id: @regular_user_profile.user_id
  #       response.should_not render_template :show_by_user_id
  #     end

  #   end
  # end




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

  describe "PUT update by user id", tag_update_user: true do
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user
      @regular_user_profile = UsersProfile.find_all_by_user_id(@user.id).first
    end

    describe "is regular user" do

      context "valid attributes" do
        it "located the requested @user profile" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: @user.id)
          assigns(:users_profile).should eq(@regular_user_profile)
        end
      end

      it "changes @user profile's attributes" do
        put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: @user.id, firstname: "juan", lastname: "lopez")
        @regular_user_profile.reload
        @regular_user_profile.firstname.should eq("juan")
        @regular_user_profile.lastname.should eq("lopez")
      end

      it "redirects to the updated users profile " do
        put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: @user.id, firstname: "juan", lastname: "lopez")
        response.should redirect_to edit_users_profiles_by_user_id_path(@regular_user_profile.user_id)
      end



      context "invalid attributes" do

        it "locates the requested @user photos" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: @user.id, firstname: "juan", lastname: "lopez")
          assigns(:users_profile).should eq(@regular_user_profile)
        end

        it "does not change @users photo's attributes" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: nil, firstname: "juan", lastname: "lopez")
          @regular_user_profile.reload
          @regular_user_profile.firstname.should_not eq("juan")
          @regular_user_profile.lastname.should_not eq("lopez")

        end
        it "re-renders the edit method" do
          put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: nil, firstname: "juan", lastname: "lopez")
          response.should render_template :edit_users_profiles_by_user_id
        end
      end
    end

    describe "is sign out user" do
      before do

        sign_out
      end

      it "redirects to root " do
        put :update_users_profiles_by_user_id, id: @regular_user_profile.user_id, users_profile: FactoryGirl.attributes_for(:users_profile, user_id: @user.id, firstname: "juan", lastname: "lopez")
        response.should redirect_to root_path
      end
    end
  end



  #***********************************
  # rspec test  json_update
  #***********************************

  describe "PUT json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step", tag_json_update: true do


    context "user is signed in but attempting to update another users account" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it "doesn't update the tutorial step" do
        put :json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step, user_id: @admin.id, tutorial_step: 7, :format => :json
        expect(response.status).to eq(404)
      end
    end





    context "user is not signed in" do
      before do
        sign_out
      end

      it "doesn't update the tutorial step" do
        put :json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step, user_id: @admin.id, tutorial_step: 7, :format => :json
        expect(response.status).to eq(404)
      end
    end






    context "user is signed in and wants to change her own info" do
      before do
        @my_user = FactoryGirl.create(:user)
        @my_users_profile = UsersProfile.find_all_by_user_id(@my_user.id).first

        sign_in @my_user
      end

      it 'updates the tutorial step' do
        put :json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step, user_id: @my_user.id, tutorial_step: 7, :format => :json

        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body["tutorial_step"]).to be(7)
      end
    end


  end




  #***********************************
  # rspec test  json_show
  #***********************************

  describe "GET json_show_users_profile_tutorial_step_by_user_id", tag_json_show: true do

    describe "is a public api" do
      before do
        sign_out
      end

      it "shows user id and tutorials step" do
        get :json_show_users_profile_tutorial_step_by_user_id, user_id: @admin.id, :format => :json
        expect(response.status).to eq(200)

        body = JSON.parse(response.body)
        expect(body["tutorial_step"]).to be(1)
      end
    end

  end



end
