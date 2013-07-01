require 'spec_helper'

describe UsersBookmarksController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }


  before  do

    @user = FactoryGirl.create(:user)
    @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
    @user_bookmark = FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark.id)
    #puts @user_bookmark.as_json
    @limit = 2
    @offset = 0

    sign_in @user

    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @user }



  #***********************************
  # rspec test  #json_index_user_bookmarks_by_user_id
  #***********************************

  describe "api #json_index_user_bookmarks_by_user_id",tag_json_index:true do

    before do
      #sign_in @requested
    end

    it "should be successful" do
      get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
      response.should be_success
    end


    it "should set user bookmark " do
      @user_bookmarks = Bookmark.
          select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title,position').
          joins(:users_bookmarks).
          where('user_id = ? ',@user.id)
      #puts @user_bookmarks.as_json
      get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
      assigns(:user_bookmarks).as_json.should eq(@user_bookmarks.as_json)
    end

    it "has a 200 status code" do
      get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
      expect(response.status).to eq(200)
    end

    context "get all values " do
      it "should return json_index user bookmarks in json" do # depend on what you return in action

        get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        body = JSON.parse(response.body)
        #puts "body ---- > "+body.to_s
        #puts "theme ----> "+@theme.as_json.to_s
        #puts "body name ----> " + body[0]["name"].to_s
        #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
        #puts "theme name----> "+@theme.name.to_s
        #puts "theme image name----> "+@theme.image_name.to_s

        body.each do |body_user_bookmark|
          @bookmark_json = Bookmark.find(body_user_bookmark["id"])
          @user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
          body_user_bookmark["id"].should == @bookmark_json.id
          body_user_bookmark["bookmark_url"].should == @bookmark_json.bookmark_url
          body_user_bookmark["bookmarks_category_id"].should == @bookmark_json.bookmarks_category_id
          body_user_bookmark["description"].should == @bookmark_json.description
          body_user_bookmark["i_frame"].should == @bookmark_json.i_frame
          body_user_bookmark["image_name"]["url"].should == @bookmark_json.image_name.to_s
          body_user_bookmark["image_name_desc"]["url"].should == @bookmark_json.image_name_desc.to_s
          body_user_bookmark["item_id"].should == @bookmark_json.item_id
          body_user_bookmark["title"].should == @bookmark_json.title
          body_user_bookmark["position"].should == @user_bookmark_json.position.to_s

        end
      end
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      it "has a 404 status code" do
        get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        expect(response.status).to eq(404)
      end
    end



  end



  #***********************************
  # rspec test  #json_index_user_bookmarks_by_user_id_and_item_id
  #***********************************


  describe "api #json_index_user_bookmarks_by_user_id_and_item_id",tag_json_index:true do

    before do
      #sign_in @requested
    end

    it "should be successful" do
      get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
      response.should be_success
    end


    it "should set user bookmark " do
      #puts "user bookmark "+@user_bookmarks.as_json
      puts "item id "+@item.id.to_s
      puts "user id "+@user.id.to_s



      @user_bookmarks = Bookmark.
          select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title,position').
          joins(:users_bookmarks).
          where('user_id = ? and item_id = ?',@user.id,@item.id)

      #puts "user bookmark "+@user_bookmarks.as_json.to_s


      get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
      assigns(:user_bookmarks).as_json.should eq(@user_bookmarks.as_json)
    end

    it "has a 200 status code" do
      get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
      expect(response.status).to eq(200)
    end

    context "get all values " do
      it "should return json_index user bookmarks in json" do # depend on what you return in action

        get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
        body = JSON.parse(response.body)

        body.each do |body_user_bookmark|
          @bookmark_json = Bookmark.find(body_user_bookmark["id"])
          @user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
          body_user_bookmark["id"].should == @bookmark_json.id
          body_user_bookmark["bookmark_url"].should == @bookmark_json.bookmark_url
          body_user_bookmark["bookmarks_category_id"].should == @bookmark_json.bookmarks_category_id
          body_user_bookmark["description"].should == @bookmark_json.description
          body_user_bookmark["i_frame"].should == @bookmark_json.i_frame
          body_user_bookmark["image_name"]["url"].should == @bookmark_json.image_name.to_s
          body_user_bookmark["image_name_desc"]["url"].should == @bookmark_json.image_name_desc.to_s
          body_user_bookmark["item_id"].should == @bookmark_json.item_id
          body_user_bookmark["title"].should == @bookmark_json.title
          body_user_bookmark["position"].should == @user_bookmark_json.position.to_s

        end
      end
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      it "has a 404 status code" do
        get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


  end





  #/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/:user_id/:bookmark_id/:item_id
  # Form Parameters:
  #               :position
  ##***********************************
  ## rspec test json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id
  ##***********************************

  describe "POST json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id", tag_json_create:true  do

    before do
      @item2 = FactoryGirl.create(:item)
      @bookmarks_category2 = FactoryGirl.create(:bookmarks_category,item_id:@item2.id)
      @bookmark2 = FactoryGirl.create(:bookmark,item_id:@item2.id,bookmarks_category_id:@bookmarks_category2.id)
      @user_max_position = UsersBookmark.maximum("position")

    end


    describe "is regular user" do
      context "with valid params" do

        it "creates a new user bookmark " do
          #puts "user id --->"+@user1.id.to_s
          #puts "user id requested--->"+@user_requested.id.to_s
          puts "user max posi " + @user_max_position.to_s
          expect {
            post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
          }.to change(UsersBookmark, :count).by(1)
        end

        it "assigns a newly created user bookmark request as @user_bookmark" do

          post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
          assigns(:user_bookmark).should be_a(UsersBookmark)
          assigns(:user_bookmark).should be_persisted

        end

        it "response should be success" do
          post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
          response.should be_success
        end

        it "has a 201 status code" do
          post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
          expect(response.status).to eq(201)
        end

        #{"bookmark_id":101,"created_at":"2013-05-02T14:23:45Z","id":2242,"position":10,"updated_at":"2013-05-02T14:23:45Z","user_id":206}
        context "return json values " do
          it "should return friend request in json" do # depend on what you return in action
            #puts "user id --->"+@user1.id.to_s
            #puts "user id requested--->"+@user_requested.id.to_s
            #
            post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
            body = JSON.parse(response.body)
            #puts "body ---- > "+body.to_s
            #puts body["user_friend_request"]["user_id"].to_s

            body["user_id"].should == @user.id
            body["bookmark_id"].should == @bookmark2.id
            body["position"].should == @user_max_position+1


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
        post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,user_id:@user.id,bookmark_id:@bookmark2.id,item_id:@item2.id,position:@user_max_position+1,:format => :json
        expect(response.status).to eq(404)
      end
    end


  end

  #  /users_bookmarks/json/create_user_bookmark_custom_by_user_id/:user_id'
  #  /users_bookmarks/json/create_user_bookmark_custom_by_user_id/1000.json
  # Content-Type : multipart/form-data
  #  Form Parameters:
  #             :bookmark_url,
  #             :bookmarks_category_id,
  #             :image_name, (full path)
  #             :item_id,
  #             :title
  #             :position
  ##***********************************
  ## rspec test json_create_user_bookmark_custom_by_user_id
  ##***********************************

  describe "POST json_create_user_bookmark_custom_by_user_id", tag_json_create_custom:true  do
    before do
      @item2 = FactoryGirl.create(:item)
      @bookmarks_category2 = FactoryGirl.create(:bookmarks_category,item_id:@item2.id)
      @bookmark2 = FactoryGirl.build(:bookmark,item_id:@item2.id,bookmarks_category_id:@bookmarks_category2.id)
      @user_max_position = UsersBookmark.maximum("position")
    end

    describe "is regular user" do
      context "with valid params" do

        it "creates a new user bookmark " do
          #puts "user id --->"+@user1.id.to_s
          #puts "user id requested--->"+@user_requested.id.to_s
          puts "user max posi " + @user_max_position.to_s
          expect {
            post :json_create_user_bookmark_custom_by_user_id,
                 user_id:@user.id,
                 bookmark_url:@bookmark2.bookmark_url,
                 bookmarks_category_id:@bookmark2.bookmarks_category_id,
                 item_id:@item2.id,
                 title:@bookmark.title,
                 position:@user_max_position+1,:format => :json
          }.to change(UsersBookmark, :count).by(1)
        end

        it "assigns a newly created user_bookmark request as @user_bookmark request" do

          post :json_create_user_bookmark_custom_by_user_id,
               user_id:@user.id,
               bookmark_url:@bookmark2.bookmark_url,
               bookmarks_category_id:@bookmark2.bookmarks_category_id,
               item_id:@item2.id,
               title:@bookmark2.title,
               position:@user_max_position+1,:format => :json

          assigns(:user_bookmark).should be_a(UsersBookmark)
          assigns(:user_bookmark).should be_persisted
          assigns(:bookmark).should be_a(Bookmark)
          assigns(:bookmark).should be_persisted


        end
        #
        it "response should be success" do

          post :json_create_user_bookmark_custom_by_user_id,
               user_id:@user.id,
               bookmark_url:@bookmark2.bookmark_url,
               bookmarks_category_id:@bookmark2.bookmarks_category_id,
               item_id:@item2.id,
               title:@bookmark2.title,
               position:@user_max_position+1,:format => :json

          response.should be_success
        end

        it "has a 201 status code" do
          post :json_create_user_bookmark_custom_by_user_id,
               user_id:@user.id,
               bookmark_url:@bookmark2.bookmark_url,
               bookmarks_category_id:@bookmark2.bookmarks_category_id,
               item_id:@item2.id,
               title:@bookmark2.title,
               position:@user_max_position+1,:format => :json

          expect(response.status).to eq(201)
        end


        #{
        #    "user_bookmark":
        #    {"bookmark_id":16508,"created_at":"2013-05-06T16:47:07Z","id":2248,"position":12,"updated_at":"2013-05-06T16:47:07Z","user_id":206},
        #    "bookmark":
        #    {"bookmark_url":"http%3A%2F%2Fwww.univision.com%2F","bookmarks_category_id":301,"created_at":"2013-05-06T16:47:07Z","description":null,"i_frame":"y","id":16508,"image_name":{"url":"/uploads/bookmark/image_name/16508/images.jpg","small":{"url":"/uploads/bookmark/image_name/16508/small_images.jpg"},"tiny":{"url":"/uploads/bookmark/image_name/16508/tiny_images.jpg"},"toolbar":{"url":"/uploads/bookmark/image_name/16508/toolbar_images.jpg"}},"image_name_desc":{"url":"/images/fallback/bookmark/default_bookmark.png","small":{"url":"/images/fallback/bookmark/default_bookmark.png"},"tiny":{"url":"/images/fallback/bookmark/default_bookmark.png"},"toolbar":{"url":"/images/fallback/bookmark/default_bookmark.png"}},"item_id":3,"title":"%22uni%22","updated_at":"2013-05-06T16:47:07Z"}
        #}
        context "return json values " do
          it "should return friend request in json" do

            post :json_create_user_bookmark_custom_by_user_id,
                 user_id:@user.id,
                 bookmark_url:@bookmark2.bookmark_url,
                 bookmarks_category_id:@bookmark2.bookmarks_category_id,
                 item_id:@item2.id,
                 title:@bookmark2.title,
                 position:@user_max_position+1,:format => :json

            body = JSON.parse(response.body)
            puts "body ---- > "+body.to_s
            #puts body["user_friend_request"]["user_id"].to_s
            #
            @bookmark_json = Bookmark.find(body["user_bookmark"]["bookmark_id"])
            @user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_user_id(@bookmark_json.id,@user.id)

            body["user_bookmark"]["position"].should == @user_max_position+1
            body["user_bookmark"]["user_id"].should == @user.id
            body["bookmark"]["bookmark_url"].should == @bookmark_json.bookmark_url
            body["bookmark"]["approval"].should == 'n'
            body["bookmark"]["i_frame"].should == 'y'
            body["bookmark"]["title"].should == @bookmark_json.title
            body["bookmark"]["item_id"].should == @bookmark_json.item_id
            body["bookmark"]["user_bookmark"].should == @bookmark_json.user_bookmark

          end
        end

      end


      context "is sign in with other user" do
        before do
          @user1 = FactoryGirl.create(:user)
          sign_in @user1
        end
        it "has a 404 status code" do
          post :json_create_user_bookmark_custom_by_user_id,
               user_id:@user.id,
               bookmark_url:@bookmark2.bookmark_url,
               bookmarks_category_id:@bookmark2.bookmarks_category_id,
               item_id:@item2.id,
               title:@bookmark2.title,
               position:@user_max_position+1,:format => :json
          expect(response.status).to eq(404)
        end
      end


      context "is sign out user" do
        before do
          sign_out
        end
        it "has a 404 status code" do
          post :json_create_user_bookmark_custom_by_user_id,
               user_id:@user.id,
               bookmark_url:@bookmark2.bookmark_url,
               bookmarks_category_id:@bookmark2.bookmarks_category_id,
               item_id:@item2.id,
               title:@bookmark2.title,
               position:@user_max_position+1,:format => :json
          expect(response.status).to eq(404)
        end
      end

    end

  end



  #***********************************
  # rspec test  destroy  json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position
  #***********************************


  #/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/:user_id/:bookmark_id/:position

  describe "DELETE json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position",tag_destroy:true do
    before do
      @item = FactoryGirl.create(:item)
      @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
      @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
      @user_bookmark = FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark.id)
      @user_max_position = UsersBookmark.maximum("position")
    end

    it "deletes friend request" do
      expect{
        delete :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
               user_id: @user.id,
               bookmark_id:@bookmark.id,
               position:@user_max_position ,:format => :json
      }.to change(UsersBookmark,:count).by(-1)
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      it "has a 404 status code" do

        delete :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
               user_id: @user.id,
               bookmark_id:@bookmark.id,
               position:@user_max_position ,:format => :json

        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        delete :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
               user_id: @user.id,
               bookmark_id:@bookmark.id,
               position:@user_max_position  ,:format => :json

        expect(response.status).to eq(404)
      end
    end


  end




end
