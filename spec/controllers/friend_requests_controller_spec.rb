require 'spec_helper'

describe FriendRequestsController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }



  before  do

    @user = FactoryGirl.create(:user)
    @user_requested = FactoryGirl.create(:user)


    #sign_in @user_requested

    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  #subject { @friend_request }



  #***********************************
  # rspec test  #json_index_friend_request_make_from_your_friend_to_you_by_user_id
  #***********************************

  #  /friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/:user_id
  describe "api #json_index_friend_request_make_from_your_friend_to_you_by_user_id",tag_json_index:true do

       before do
         @friend_request1 = FactoryGirl.create(:friend_request,user_id:@user.id,user_id_requested:@user_requested.id)
         sign_in @user_requested
         @friend_requests_find = FriendRequest.where('user_id_requested = ?',@user_requested.id)
         @user_friend_requested_all =
                           UsersPhoto.select(
                               'users_photos.user_id,
                              users_photos.image_name,
                              users_photos.profile_image,
                              users_profiles.firstname,
                              users_profiles.lastname'
                           ).where(:user_id => @friend_requests_find.map {|b| b.user_id})
                           .where("users_photos.profile_image = 'y'")
                           .joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id')
       end

      it "should be successful" do
        #puts "user id --->"+@user.id.to_s
        #puts "user id requested--->"+@user_requested.id.to_s

        get :json_index_friend_request_make_from_your_friend_to_you_by_user_id,user_id: @user_requested.id, :format => :json
        response.should be_success
      end


      it "should set friend request" do

        #friend_requests_find = FriendRequest.where('user_id_requested = ?',@user_requested.id)
        #user_friend_requested_all =  User.select('id').where(:id => friend_requests_find.map {|b| b.user_id})

        get :json_index_friend_request_make_from_your_friend_to_you_by_user_id,user_id: @user_requested.id, :format => :json
        assigns(:user_friend_requested).as_json.should eq(@user_friend_requested_all.as_json)
      end
      #
      it "has a 200 status code" do
        get :json_index_friend_request_make_from_your_friend_to_you_by_user_id,user_id: @user_requested.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index friend request in json" do # depend on what you return in action

          get :json_index_friend_request_make_from_your_friend_to_you_by_user_id,user_id: @user_requested.id, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body name ----> " + body[0]["name"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "theme name----> "+@theme.name.to_s
          #puts "theme image name----> "+@theme.image_name.to_s

          body.each do |body_friend_request|
            @user_photos_json = UsersPhoto.find_all_by_user_id(body_friend_request["user_id"]).first
            @user_profile_json = UsersProfile.find_all_by_user_id(body_friend_request["user_id"]).first
            body_friend_request["firstname"].should == @user_profile_json.firstname
            body_friend_request["lastname"].should == @user_profile_json.lastname
            body_friend_request["image_name"]["url"].should == @user_photos_json.image_name.to_s
            body_friend_request["profile_image"].should == @user_photos_json.profile_image

          end
        end
      end

       context "is sign in with other user" do
         before do
           @user1 = FactoryGirl.create(:user)
           sign_in @user1
         end
         it "has a 404 status code" do
           get :json_index_friend_request_make_from_your_friend_to_you_by_user_id,user_id: @user_requested.id, :format => :json
           expect(response.status).to eq(404)
         end
       end


       context "is sign out user" do
         before do
           sign_out
         end
         it "has a 404 status code" do
           get :json_index_friend_request_make_from_your_friend_to_you_by_user_id,user_id: @user_requested.id, :format => :json
           expect(response.status).to eq(404)
         end
       end


  end



  #***********************************
  # rspec test json_create_friend_request_by_user_id_and_user_id_requested
  #***********************************
  # /friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested

  describe "POST json_create_friend_request_by_user_id_and_user_id_requested", tag_json_create:true  do
      before do
        sign_in @user
      end


    describe "is regular user" do
        context "with valid params" do

          it "creates a new friend request" do
            #puts "user id --->"+@user.id.to_s
            #puts "user id requested--->"+@user_requested.id.to_s

            expect {
              post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
            }.to change(FriendRequest, :count).by(1)
          end

          it "assigns a newly created friend request as @friend request" do
            post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
            assigns(:friend_request).should be_a(FriendRequest)
            assigns(:friend_request).should be_persisted
          end
          #
          it "response should be success" do
            post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
            response.should be_success
          end

          it "has a 201 status code" do
            post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
            expect(response.status).to eq(201)
          end

          context "return json values " do
            it "should return friend request in json" do # depend on what you return in action
              post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
              body = JSON.parse(response.body)
              body["user_id"].should == @user.id
              body["user_id_requested"].should == @user_requested.id
            end
          end

        end
    end

      context "is sign in with other user" do
        before do
          @user1 = FactoryGirl.create(:user)
          sign_in @user1
        end
        it "has a 404 status code" do
          post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
          expect(response.status).to eq(404)
        end
      end


      context "is sign out user" do
        before do
          sign_out
        end
        it "has a 404 status code" do
          post :json_create_friend_request_by_user_id_and_user_id_requested,user_id:@user.id,user_id_requested:@user_requested.id, :format => :json
          expect(response.status).to eq(404)
        end
      end

  end


  #***********************************
  # rspec test  destroy
  #***********************************


  # /friend_requests/json/destroy_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested
  describe 'DELETE json_destroy_friend_request_by_user_id_and_user_id_requested',tag_destroy:true do
    before do
      @friend_request = FactoryGirl.create(:friend_request,user_id:@user.id,user_id_requested:@user_requested.id)
      sign_in @user
    end

    it "deletes friend request" do
      expect{
        delete :json_destroy_friend_request_by_user_id_and_user_id_requested, user_id: @user.id,user_id_requested:@user_requested.id , :format => :json
      }.to change(FriendRequest,:count).by(-1)
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      it "has a 404 status code" do
        delete :json_destroy_friend_request_by_user_id_and_user_id_requested, user_id: @user.id,user_id_requested:@user_requested.id,:format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        delete :json_destroy_friend_request_by_user_id_and_user_id_requested, user_id: @user.id,user_id_requested:@user_requested.id , :format => :json
        expect(response.status).to eq(404)
      end
    end


  end





end

