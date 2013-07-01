require 'spec_helper'

describe FriendsController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }


  before  do

    @limit = 2
    @offset = 0
    @user1 = FactoryGirl.create(:user)
    @user2 = FactoryGirl.create(:user)
    @user3 = FactoryGirl.create(:user)
    @user4 = FactoryGirl.create(:user)
    @user5 = FactoryGirl.create(:user)
    @user6 = FactoryGirl.create(:user)
    @user7 = FactoryGirl.create(:user)


    @friend1 = FactoryGirl.create(:friend,user_id:@user1.id,user_id_friend:@user2.id)
    @friend2 = FactoryGirl.create(:friend,user_id:@user1.id,user_id_friend:@user3.id)
    @friend3 = FactoryGirl.create(:friend,user_id:@user1.id,user_id_friend:@user4.id)
    @friend4 = FactoryGirl.create(:friend,user_id:@user1.id,user_id_friend:@user5.id)

    @suggestion1_for_user1 = FactoryGirl.create(:friend,user_id:@user2.id,user_id_friend:@user6.id)
    @suggestion2_for_user1 = FactoryGirl.create(:friend,user_id:@user3.id,user_id_friend:@user7.id)

    sign_in @user1

    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @user1 }



  #***********************************
  # rspec test  #json_index_friend_by_user_id
  #***********************************

  #  /friends/json/index_friend_by_user_id/:user_id'
  describe "api #json_index_friend_by_user_id",tag_json_index:true do

    before do
      #sign_in @requested
    end

    it "should be successful" do
      puts "user id 1--->"+@user1.id.to_s
      puts "user id 2--->"+@user2.id.to_s

      get :json_index_friend_by_user_id,user_id: @user1.id, :format => :json
      response.should be_success
    end


    it "should set friend " do

      @friends = Friend.where('user_id = ?',@user1.id)
      @user_friend =  User.select('id,name,image_name').where(:id => @friends.map {|b| b.user_id_friend})

      get :json_index_friend_by_user_id,user_id: @user1.id, :format => :json
      assigns(:user_friend).as_json.should eq(@user_friend.as_json)
    end

    it "has a 200 status code" do
      get :json_index_friend_by_user_id,user_id: @user1.id, :format => :json
      expect(response.status).to eq(200)
    end

    context "get all values " do
      it "should return json_index friend in json" do # depend on what you return in action


        get :json_index_friend_by_user_id,user_id: @user1.id, :format => :json
        body = JSON.parse(response.body)
        #puts "body ---- > "+body.to_s
        #puts "theme ----> "+@theme.as_json.to_s
        #puts "body name ----> " + body[0]["name"].to_s
        #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
        #puts "theme name----> "+@theme.name.to_s
        #puts "theme image name----> "+@theme.image_name.to_s

        body.each do |body_friend|
          @friend_json = User.find(body_friend["id"])
          body_friend["name"].should == @friend_json.name.to_s
          body_friend["image_name"]["url"].should == @friend_json.image_name.to_s
          body_friend["id"].should == @friend_json.id
        end
      end
    end

  end



  #***********************************
  # rspec test  #json_index_friend_by_user_id_by_limit_by_offset
  #***********************************


  describe "api #json_index_friend_by_user_id_by_limit_by_offset",tag_json_index:true do

    before do

      #sign_in @requested
    end

    it "should be successful" do
      puts "user id 1--->"+@user1.id.to_s
      puts "user id 2--->"+@user2.id.to_s

      get :json_index_friend_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
      response.should be_success
    end


    it "should set friend " do

      @friends = Friend.where('user_id = ?',@user1.id).limit(@limit).offset(@offset)

      @user_friend =  User.select('id,name,image_name').where(:id => @friends.map {|b| b.user_id_friend})

      get :json_index_friend_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
      assigns(:user_friend).as_json.should eq(@user_friend.as_json)
    end

    it "has a 200 status code" do
      get :json_index_friend_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
      expect(response.status).to eq(200)
    end

    context "get all values " do
      it "should return json_index friend in json" do # depend on what you return in action


        get :json_index_friend_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
        body = JSON.parse(response.body)
        #puts "body ---- > "+body.to_s
        #puts "theme ----> "+@theme.as_json.to_s
        #puts "body name ----> " + body[0]["name"].to_s
        #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
        #puts "theme name----> "+@theme.name.to_s
        #puts "theme image name----> "+@theme.image_name.to_s

        body.each do |body_friend|
          @friend_json = User.find(body_friend["id"])
          body_friend["name"].should == @friend_json.name.to_s
          body_friend["image_name"]["url"].should == @friend_json.image_name.to_s
          body_friend["id"].should == @friend_json.id
        end
      end
    end

  end

  # json_index_friends_suggestion_by_user_id_by_limit_by_offset
  #  /friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/:user_id/:limit/:offset'

  #***********************************
  # rspec test  #json_index_friends_suggestion_by_user_id_by_limit_by_offset
  #***********************************

  describe "api #json_index_friends_suggestion_by_user_id_by_limit_by_offset",tag_json_suggestion:true do

    before do

    end

    it "should be successful" do
      puts "user id 1--->"+@user1.id.to_s
      puts "user id 2--->"+@user2.id.to_s

      get :json_index_friends_suggestion_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
      response.should be_success
    end



    it "has a 200 status code" do
      get :json_index_friends_suggestion_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
      expect(response.status).to eq(200)
    end

    context "get all values " do
      it "should return json_index friend in json" do # depend on what you return in action


        get :json_index_friends_suggestion_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
        body = JSON.parse(response.body)
        #puts "body ---- > "+body.to_s
        #puts "body name ----> " + body[0].to_s
        ##puts "body image name ----> " + body[0]["image_name"]["url"].to_s

        body.each do |body_friend|
          puts "body friend "+body_friend.to_s

          body_friend.each do |b_friend|
            #  @friend_json = User.find(body_friend["id"])
            #  body_friend["name"].should == @friend_json.name.to_s
            #  body_friend["image_name"]["url"].should == @friend_json.image_name.to_s
            #  body_friend["id"].should == @friend_json.id

            puts "body friend ---> "+b_friend.to_s
            puts "body friend "+b_friend["name"].to_s
            #puts "body friend "+body_friend1

            @friend_json = User.find(b_friend["id"])
            b_friend["name"].should == @friend_json.name.to_s
            b_friend["image_name"]["url"].should == @friend_json.image_name.to_s
            b_friend["id"].should == @friend_json.id

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
        get :json_index_friends_suggestion_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        get :json_index_friends_suggestion_by_user_id_by_limit_by_offset,user_id: @user1.id,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(404)
      end
    end




  end



  #json_create_friend_by_user_id_accept_and_user_id_request
  #'/friends/json/create_friend_by_user_id_accept_and_user_id_request/:user_id/:user_id_request'

  ##***********************************
  ## rspec test json_create_friend_by_user_id_accept_and_user_id_request
  ##***********************************

  describe "POST json_create_friend_by_user_id_accept_and_user_id_request", tag_json_create:true  do
    before do
      @user_requested = FactoryGirl.create(:user)
      @friend_request = FactoryGirl.create(:friend_request,user_id:@user1.id,user_id_requested:@user_requested.id)
      sign_in @user_requested
    end


    describe "is regular user" do
      context "with valid params" do

        it "creates a new friend " do
          #puts "user id --->"+@user1.id.to_s
          #puts "user id requested--->"+@user_requested.id.to_s

          expect {
            post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
          }.to change(Friend, :count).by(2)
        end

        it "assigns a newly created friend request as @friend request" do
          post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
          assigns(:user_friend_request).should be_a(Friend)
          assigns(:user_friend_request).should be_persisted
          assigns(:user_friend_accept).should be_a(Friend)
          assigns(:user_friend_accept).should be_persisted
        end

        it "response should be success" do
          post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
          response.should be_success
        end

        it "has a 201 status code" do
          post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
          expect(response.status).to eq(201)
        end

        context "return json values " do
          it "should return friend request in json" do # depend on what you return in action
            puts "user id --->"+@user1.id.to_s
            puts "user id requested--->"+@user_requested.id.to_s
            post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
            body = JSON.parse(response.body)
            puts "body ---- > "+body.to_s
            puts body["user_friend_request"]["user_id"].to_s

            body["user_friend_request"]["user_id"].should == @user1.id
            body["user_friend_request"]["user_id_friend"].should == @user_requested.id

            body["user_friend_accept"]["user_id"].should == @user_requested.id
            body["user_friend_accept"]["user_id_friend"].should == @user1.id


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
        post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        post :json_create_friend_by_user_id_accept_and_user_id_request,user_id:@user_requested.id,user_id_request:@user1.id, :format => :json
        expect(response.status).to eq(404)
      end
    end

  end


  #***********************************
  # rspec test  destroy  json_destroy_friend_by_user_id_and_user_id_friend
  #***********************************


  #'/friends/json/destroy_friend_by_user_id_and_user_id_friend/:user_id/:user_id_friend'
  describe "DELETE json_destroy_friend_by_user_id_and_user_id_friend",tag_destroy:true do
    before do
      sign_in @user1
    end

    it "deletes friend request" do
      expect{
        delete :json_destroy_friend_by_user_id_and_user_id_friend, user_id: @user1.id,user_id_friend:@user2.id, :format => :json
      }.to change(Friend,:count).by(-1)
    end

    context "is sign in with other user" do
      before do
        @user3 = FactoryGirl.create(:user)
        sign_in @user3
      end
      it "has a 404 status code" do
        delete :json_destroy_friend_by_user_id_and_user_id_friend, user_id: @user1.id,user_id_friend:@user2.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        delete :json_destroy_friend_by_user_id_and_user_id_friend, user_id: @user1.id,user_id_friend:@user2.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


  end




end
