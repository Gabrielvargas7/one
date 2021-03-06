require 'spec_helper'

describe UsersBookmarksController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }


  before  do

    @user = FactoryGirl.create(:user)
    @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    @bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
    @user_bookmark = FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark.id)
    #puts @user_bookmark.as_json
    @limit = 2
    @offset = 0

    sign_in @user

    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @user }



  #/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/:user_id/:bookmark_id/:item_id
  # Form Parameters:
  #               :position
  ##***********************************
  ## rspec POST json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id
  ##***********************************

  describe "POST json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id", tag_json_create:true  do

    before do
      @item2 = FactoryGirl.create(:item)
      @bookmarks_category2 = FactoryGirl.create(:bookmarks_category,item_id:@item2.id)
      @bookmark2 = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category2.id)
      @user_max_position = UsersBookmark.maximum("position")

    end


    describe "is regular user with valid parameters" do
      let(:user_bookmark_count_start) {UsersBookmark.count} #Note, let is not allowed in a before block
      before do
        post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
          user_id:@user.id,bookmark_id:@bookmark2.id,
          item_id:@item2.id,
          position:@user_max_position+1,
          :format => :json
      end
      it "creates a new user bookmark " do
        UsersBookmark.count.should be_within(1).of(user_bookmark_count_start)
      end

      it "assigns a newly created user bookmark request as @user_bookmark" do
        assigns(:user_bookmark).should be_a(UsersBookmark)
        assigns(:user_bookmark).should be_persisted

      end

      it "response should be success" do
        response.should be_success
      end

      it "has a 201 status code" do
        expect(response.status).to eq(201)
      end

      #{"bookmark_id":101,"created_at":"2013-05-02T14:23:45Z","id":2242,"position":10,"updated_at":"2013-05-02T14:23:45Z","user_id":206}
      context "return json values " do
        it "should return friend request in json" do # depend on what you return in action
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts body["user_friend_request"]["user_id"].to_s

          body["user_id"].should == @user.id
          body["bookmark_id"].should == @bookmark2.id
          body["position"].should == @user_max_position+1
        end
      end

      
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
        post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
          user_id:@user.id,
          bookmark_id:@bookmark2.id,
          item_id:@item2.id,
          position:@user_max_position+1,
          :format => :json
      end
      it "has a 404 status code" do
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
        post :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
          user_id:@user.id,
          bookmark_id:@bookmark2.id,
          item_id:@item2.id,
          position:@user_max_position+1,
          :format => :json
      end
      it "has a 404 status code" do
        expect(response.status).to eq(404)
      end
    end


  end

#***********************************
  # rspec DELETE  destroy  json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position
  #***********************************


  #/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/:user_id/:bookmark_id/:position

  describe "DELETE json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position",tag_destroy:true do
    before do
      @item = FactoryGirl.create(:item)
      @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
      @bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
      @user_max_position = UsersBookmark.maximum("position")
      @user_bookmark = FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark.id,position:@user_max_position)

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
        delete :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
               user_id: @user.id,
               bookmark_id:@bookmark.id,
               position:@user_max_position ,:format => :json
      end
      it "has a 404 status code" do
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
        delete :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
         user_id: @user.id,
         bookmark_id:@bookmark.id,
         position:@user_max_position  ,:format => :json
      end
      it "has a 404 status code" do
        expect(response.status).to eq(404)
      end
    end


  end


  #***********************************
  # rspec GET  #json_index_user_bookmarks_by_user_id
  #***********************************

  describe "GET #json_index_user_bookmarks_by_user_id",tag_json_index:true do

    before do
      sign_in @user
    end

    context "correct user" do
      before do
        get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
      end

      it "should be successful" do
        
        response.should be_success
      end


      it "should get the user bookmark " do
        user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc,  bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? ',@user.id)
        #puts @user_bookmarks.as_json
        #get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        assigns(:user_bookmarks).as_json.should eq(user_bookmarks.as_json)
      end

      it "has a 200 status code" do
        #get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index user bookmarks in json" do # depend on what you return in action

          #get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
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
            body_user_bookmark["title"].should == @bookmark_json.title
            body_user_bookmark["position"].should == @user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == @bookmark_json.like


          end
        end
      end
    end #end context correct user


    context "is sign in with other user" do
      before do
       @user1 = FactoryGirl.create(:user)
       sign_in @user1
       get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
      end
      

      it "has a 200 status code" do
       expect(response.status).to eq(200)
      end
      
      it "should get the user bookmark " do
        user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc,  bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? ',@user.id)
        #puts @user_bookmarks.as_json
        #get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        assigns(:user_bookmarks).as_json.should eq(user_bookmarks.as_json)
      end
      
      
      it "should get values- return json_index user bookmarks in json" do # depend on what you return in action
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
          body_user_bookmark["title"].should == @bookmark_json.title
          body_user_bookmark["position"].should == @user_bookmark_json.position.to_s
          body_user_bookmark["like"].should == @bookmark_json.like
        end
      end
    end #end context is sign in with other user


    context "is sign out user" do
      before do
       sign_out
       get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
      end
      
      it "has a 200 status code" do
       expect(response.status).to eq(200)
      end
      
      it "should get the user bookmark " do
        user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc,  bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? ',@user.id)
        #puts @user_bookmarks.as_json
        #get :json_index_user_bookmarks_by_user_id,user_id: @user.id, :format => :json
        assigns(:user_bookmarks).as_json.should eq(user_bookmarks.as_json)
      end
      

      
      it "should return json_index user bookmarks in json" do # depend on what you return in action
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
          body_user_bookmark["title"].should == @bookmark_json.title
          body_user_bookmark["position"].should == @user_bookmark_json.position.to_s
          body_user_bookmark["like"].should == @bookmark_json.like
        end
      end
      
    end

  end

  #***********************************
  # rspec GET  #json_index_user_bookmarks_by_user_id_by_limit_and_offset
  #***********************************
  describe "get json_index_user_bookmarks_by_user_id_by_limit_and_offset", tag_index_limit:true do
    before do
      #Make sure user has 10 bookmarks.
      @user_bookmarks = []
      for i in 1..10
        FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
        user_bookmark = FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark.id)
      end
    end

    describe "correct parameters and correct user" do

      context "test limits of 6 and offset 0" do 

        let(:offset){0}
        let(:limit){6} 

        before do
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
           user_id: @user.id,limit:limit, 
           offset:offset,
           :format => :json
          @body = JSON.parse(response.body)
        end
        it "should be successful" do
          expect(response.status).to eq(200)
        end

        it "should return only 6 bookmarks since limit is 6" do
          expect(@body.length).to eq(limit)
        end

        it "should have the correct values" do
          @body.each do |body_user_bookmark|
            bookmark_json = Bookmark.find(body_user_bookmark["id"])
            user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
            body_user_bookmark["id"].should == bookmark_json.id
            body_user_bookmark["bookmark_url"].should == bookmark_json.bookmark_url
            body_user_bookmark["bookmarks_category_id"].should == bookmark_json.bookmarks_category_id
            body_user_bookmark["description"].should == bookmark_json.description
            body_user_bookmark["i_frame"].should == bookmark_json.i_frame
            body_user_bookmark["image_name"]["url"].should == bookmark_json.image_name.to_s
            body_user_bookmark["image_name_desc"]["url"].should == bookmark_json.image_name_desc.to_s
            body_user_bookmark["title"].should == bookmark_json.title
            body_user_bookmark["position"].should == user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == bookmark_json.like
          end
        end
      end
    

      context "correct parameters and correct user and offset 6" do
        let(:offset){0}
        let(:limit){1}
        
        before do
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
          user_id: @user.id,limit:limit, 
          offset:offset,
           :format => :json
          @body = JSON.parse(response.body)
          @first_bookmark_in_user_collection = @body.first
          # puts @first_bookmark_in_user_collection

        end

        it " should not contain the first bookmark." do
          #call function with limit and offset 6. 
          offset = 6
          limit = 6
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
          user_id: @user.id,limit:limit, 
          offset:offset,
           :format => :json
          body_with_offset = JSON.parse(response.body)
          body_with_offset.should_not include(@first_bookmark_in_user_collection)
        end
      end
    end

    describe "sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      context "test limits of 6 and offset 0" do 

        let(:offset){0}
        let(:limit){6} 


        before do
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
           user_id: @user.id,limit:limit, 
           offset:offset,
           :format => :json
          @body = JSON.parse(response.body)
        end
        it "should be successful" do
          expect(response.status).to eq(200)
        end

        it "should return only 6 bookmarks since limit is 6" do
          expect(@body.length).to eq(limit)
        end

        it "should have the correct values" do
          @body.each do |body_user_bookmark|
            bookmark_json = Bookmark.find(body_user_bookmark["id"])
            user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
            body_user_bookmark["id"].should == bookmark_json.id
            body_user_bookmark["bookmark_url"].should == bookmark_json.bookmark_url
            body_user_bookmark["bookmarks_category_id"].should == bookmark_json.bookmarks_category_id
            body_user_bookmark["description"].should == bookmark_json.description
            body_user_bookmark["i_frame"].should == bookmark_json.i_frame
            body_user_bookmark["image_name"]["url"].should == bookmark_json.image_name.to_s
            body_user_bookmark["image_name_desc"]["url"].should == bookmark_json.image_name_desc.to_s
            body_user_bookmark["title"].should == bookmark_json.title
            body_user_bookmark["position"].should == user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == bookmark_json.like
          end
        end
      end
    

      context "correct parameters and correct user and offset 6" do
        let(:offset){0}
        let(:limit){1}
        
        before do
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
          user_id: @user.id,limit:limit, 
          offset:offset,
           :format => :json
          @body = JSON.parse(response.body)
          @first_bookmark_in_user_collection = @body.first
          # puts @first_bookmark_in_user_collection

        end

        it " should not contain the first bookmark." do
          #call function with limit and offset 6. 
          offset = 6
          limit = 6
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
          user_id: @user.id,limit:limit, 
          offset:offset,
           :format => :json
          body_with_offset = JSON.parse(response.body)
          body_with_offset.should_not include(@first_bookmark_in_user_collection)
        end
      end

    end #end describe sign in with other user
    describe "sign out user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      context "test limits of 6 and offset 0" do 

        let(:offset){0}
        let(:limit){6} 

        before do
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
           user_id: @user.id,limit:limit, 
           offset:offset,
           :format => :json
          @body = JSON.parse(response.body)
        end
        it "should be successful" do
          expect(response.status).to eq(200)
        end

        it "should return only 6 bookmarks since limit is 6" do
          expect(@body.length).to eq(limit)
        end

        it "should have the correct values" do
          @body.each do |body_user_bookmark|
            bookmark_json = Bookmark.find(body_user_bookmark["id"])
            user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
            body_user_bookmark["id"].should == bookmark_json.id
            body_user_bookmark["bookmark_url"].should == bookmark_json.bookmark_url
            body_user_bookmark["bookmarks_category_id"].should == bookmark_json.bookmarks_category_id
            body_user_bookmark["description"].should == bookmark_json.description
            body_user_bookmark["i_frame"].should == bookmark_json.i_frame
            body_user_bookmark["image_name"]["url"].should == bookmark_json.image_name.to_s
            body_user_bookmark["image_name_desc"]["url"].should == bookmark_json.image_name_desc.to_s
            body_user_bookmark["title"].should == bookmark_json.title
            body_user_bookmark["position"].should == user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == bookmark_json.like
          end
        end
      end
    

      context "correct parameters and correct user and offset 6" do
        let(:offset){0}
        let(:limit){1}
        
        before do
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
          user_id: @user.id,limit:limit, 
          offset:offset,
           :format => :json
          @body = JSON.parse(response.body)
          @first_bookmark_in_user_collection = @body.first
          # puts @first_bookmark_in_user_collection

        end

        it " should not contain the first bookmark." do
          #call function with limit and offset 6. 
          offset = 6
          limit = 6
          get :json_index_user_bookmarks_by_user_id_by_limit_and_offset,
          user_id: @user.id,limit:limit, 
          offset:offset,
           :format => :json
          body_with_offset = JSON.parse(response.body)
          body_with_offset.should_not include(@first_bookmark_in_user_collection)
        end
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
    context "correct user and correct parameters" do 
      it "should be successful" do
        get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
        response.should be_success
      end


      it "should get user bookmark " do
        #puts "user bookmark "+@user_bookmarks.as_json
        #puts "item id "+@item.id.to_s
        #puts "user id "+@user.id.to_s



        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, bookmarks_categories.item_id,description, i_frame, image_name, image_name_desc, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? and bookmarks_categories.item_id = ?',@user.id,@item.id)

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
            body_user_bookmark["title"].should == @bookmark_json.title
            body_user_bookmark["position"].should == @user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == @bookmark_json.like

          end
        end
      end
    end #end context correct user and correct paramters

    context "is sign in with other user" do
      before do
        @user1=FactoryGirl.create(:user)
        sign_in @user1
      end
      context "correct user and correct parameters" do 
        it "should be successful" do
          get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
          response.should be_success
        end


        it "should set user bookmark " do
          #puts "user bookmark "+@user_bookmarks.as_json
          #puts "item id "+@item.id.to_s
          #puts "user id "+@user.id.to_s



          @user_bookmarks = Bookmark.
              select('bookmarks.id, bookmark_url, bookmarks_category_id, bookmarks_categories.item_id,description, i_frame, image_name, image_name_desc, title,position,"like"').
              joins(:users_bookmarks).
              joins(:bookmarks_category).
              where('user_id = ? and bookmarks_categories.item_id = ?',@user.id,@item.id)

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
              body_user_bookmark["title"].should == @bookmark_json.title
              body_user_bookmark["position"].should == @user_bookmark_json.position.to_s
              body_user_bookmark["like"].should == @bookmark_json.like

            end
          end
        end
      end #end context sign in with other user
      #before do
      #  @user1 = FactoryGirl.create(:user)
      #  sign_in @user1
      #end
      #it "has a 404 status code" do
      #  get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
      #  expect(response.status).to eq(404)
      #end
    end


    context "is sign out user" do
      
      before do
        sign_out
      end

      context "correct user and correct parameters" do 
        it "should be successful" do
          get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
          response.should be_success
        end


        it "should set user bookmark " do
          #puts "user bookmark "+@user_bookmarks.as_json
          #puts "item id "+@item.id.to_s
          #puts "user id "+@user.id.to_s



          @user_bookmarks = Bookmark.
              select('bookmarks.id, bookmark_url, bookmarks_category_id, bookmarks_categories.item_id,description, i_frame, image_name, image_name_desc, title,position,"like"').
              joins(:users_bookmarks).
              joins(:bookmarks_category).
              where('user_id = ? and bookmarks_categories.item_id = ?',@user.id,@item.id)

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
              body_user_bookmark["title"].should == @bookmark_json.title
              body_user_bookmark["position"].should == @user_bookmark_json.position.to_s
              body_user_bookmark["like"].should == @bookmark_json.like

            end
          end
        end
      end #end context sign out
      #before do
      #  sign_out
      #end
      #it "has a 404 status code" do
      #  get :json_index_user_bookmarks_by_user_id_and_item_id,user_id: @user.id,item_id:@item.id, :format => :json
      #  expect(response.status).to eq(404)
      #end
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
      @bookmarks_category2 = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
      @bookmark2 = FactoryGirl.build(:bookmark,bookmarks_category_id:@bookmarks_category2.id)
      @user_max_position = UsersBookmark.maximum("position")
    end

    describe "is regular user" do
      context "with valid params" do


        xit "has a 201 status code" do
          
          puts @user.id
          puts @bookmark2.bookmark_url
          puts @bookmark2.bookmarks_category_id
          puts @item2.id
          puts @bookmark2.title
          puts @user_max_position+1
          puts "http://placekitten/30/30"
          
          post :json_create_user_bookmark_custom_by_user_id,
               user_id:@user.id,
               bookmark_url:@bookmark2.bookmark_url,
               bookmarks_category_id:@bookmark2.bookmarks_category_id,
               item_id:Item.first.id,
               title:@bookmark2.title,
               position:@user_max_position+1,
               image_name:"http://placekitten/30/30",
               #remote_image_name_desc_url:@bookmark2.remote_image_name_desc_url,
               :format => :json
          puts response.body
          # puts :user_bookmark.errors
          # puts :bookmark.errors

          #puts response
          expect(response.status).to eq(201)
        end


        #{
        #    "user_bookmark":
        #    {"bookmark_id":16508,"created_at":"2013-05-06T16:47:07Z","id":2248,"position":12,"updated_at":"2013-05-06T16:47:07Z","user_id":206},
        #    "bookmark":
        #    {"bookmark_url":"http%3A%2F%2Fwww.univision.com%2F","bookmarks_category_id":301,"created_at":"2013-05-06T16:47:07Z","description":null,"i_frame":"y","id":16508,"image_name":{"url":"/uploads/bookmark/image_name/16508/images.jpg","small":{"url":"/uploads/bookmark/image_name/16508/small_images.jpg"},"tiny":{"url":"/uploads/bookmark/image_name/16508/tiny_images.jpg"},"toolbar":{"url":"/uploads/bookmark/image_name/16508/toolbar_images.jpg"}},"image_name_desc":{"url":"/images/fallback/bookmark/default_bookmark.png","small":{"url":"/images/fallback/bookmark/default_bookmark.png"},"tiny":{"url":"/images/fallback/bookmark/default_bookmark.png"},"toolbar":{"url":"/images/fallback/bookmark/default_bookmark.png"}},"item_id":3,"title":"%22uni%22","updated_at":"2013-05-06T16:47:07Z"}
        #}
        context "return json values " do
          xit "should return friend request in json" do

            # @bookmarkTest = Bookmark.new(title: @bookmark2.title,
            #                              bookmark_url:@bookmark2.bookmark_url,
            #      bookmarks_category_id:@bookmark2.bookmarks_category_id,
            #      remote_image_name_url:@bookmark2.remote_image_name_url,
            #      remote_image_name_desc_url:@bookmark2.remote_image_name_url,
            #      approval:'n',
            #      i_frame:'y',
            #      user_bookmark:@user.id,
            #      like:1)
            
            puts "Bookmarks2: "
            puts @bookmark2.as_json
            puts "BOOKAMRKS TEST"
            puts @bookmarkTest.as_json

            #@bookmarkTest.save
            #@bookmark2.remote_image_name_url

            post :json_create_user_bookmark_custom_by_user_id,
                 user_id:@user.id,
                 bookmark_url:@bookmark2.bookmark_url,
                 bookmarks_category_id:@bookmark2.bookmarks_category_id,
                 item_id:@item2.id,
                 title:@bookmark2.title,
                 position:@user_max_position+1,
                 image_name:@bookmark2.remote_image_name_url,
                 :format => :json

            body = JSON.parse(response.body)
            #puts "body ---- > "+body.to_s
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
            body["bookmark"]["user_bookmark"].should == @bookmark_json.user_bookmark

          end
        end
        #it "creates a new user bookmark " do
        #  #puts "user id --->"+@user1.id.to_s
        #  #puts "user id requested--->"+@user_requested.id.to_s
        #  #puts "user max posi " + @user_max_position.to_s
        #  expect {
        #    post :json_create_user_bookmark_custom_by_user_id,
        #         user_id:@user.id,
        #         bookmark_url:@bookmark2.bookmark_url,
        #         bookmarks_category_id:@bookmark2.bookmarks_category_id,
        #         item_id:@item2.id,
        #         title:@bookmark.title,
        #         position:@user_max_position+1,:format => :json
        #  }.to change(UsersBookmark, :count).by(1)
        #end
        #
        #it "assigns a newly created user_bookmark request as @user_bookmark request" do
        #
        #  post :json_create_user_bookmark_custom_by_user_id,
        #       user_id:@user.id,
        #       bookmark_url:@bookmark2.bookmark_url,
        #       bookmarks_category_id:@bookmark2.bookmarks_category_id,
        #       item_id:@item2.id,
        #       title:@bookmark2.title,
        #       position:@user_max_position+1,:format => :json
        #
        #  assigns(:user_bookmark).should be_a(UsersBookmark)
        #  assigns(:user_bookmark).should be_persisted
        #  assigns(:bookmark).should be_a(Bookmark)
        #  assigns(:bookmark).should be_persisted
        #
        #
        #end
        #
        #it "response should be success" do
        #
        #  post :json_create_user_bookmark_custom_by_user_id,
        #       user_id:@user.id,
        #       bookmark_url:@bookmark2.bookmark_url,
        #       bookmarks_category_id:@bookmark2.bookmarks_category_id,
        #       item_id:@item2.id,
        #       title:@bookmark2.title,
        #       position:@user_max_position+1,:format => :json
        #
        #  response.should be_success
        #end

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

  #rspec GET json_show_user_bookmark_by_user_id_and_bookmark_id
  #1-24-2014 ApI returns the bookmark if the bookmark is present in the user's mybookmarks. Otherwise it returns empty.
  #           This API is public -SN

  describe "GET json_show_user_bookmark_by_user_id_and_bookmark_id", tag_show_by_user_bm_id:true do
    
        
    before do
      sign_in @user
      @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
      @bookmark2= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
      user_bookmark=FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark1.id)
      
      get :json_show_user_bookmark_by_user_id_and_bookmark_id,
          user_id: @user.id,
          bookmark_id: @bookmark1.id,
          :format => :json

      
    end

    context "correct user " do
      context "with a bookmark present" do

        it "should be successful" do
          response.should be_success
        end

        it "has a 200 status code" do
          expect(response.status).to eq(200)
        end

        it "should get the user bookmark with values" do
          # Bookmark.columns_hash.each {|k,v| puts "#{k} => #{v.type}"}
          # @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
          # user_bookmark=FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark1.id)

          #Note this assumes that the newly added bookmark is not a custom bookmark. 
          # Otherwise, we'd have to add sql parameters defined in the controller. 
          body = JSON.parse(response.body)
          user_bookmark_test = Bookmark.
              select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
              joins(:users_bookmarks).
              joins(:bookmarks_category).
              where('user_id = ? and bookmark_id =?',@user.id,@bookmark1.id)
          #puts @user_bookmarks.as_json

          user_bookmark_test[0].id.should == body["id"]
          user_bookmark_test[0].bookmark_url.should == body["bookmark_url"]
          user_bookmark_test[0].bookmarks_category_id.should ==body["bookmarks_category_id"]
          user_bookmark_test[0].description.should ==body["description"]
          user_bookmark_test[0].i_frame.should ==body["i_frame"]
          user_bookmark_test[0].item_id.should ==body["item_id"]
          user_bookmark_test[0].like.should ==body["like"]
          user_bookmark_test[0].position.should ==body["position"]
         # assigns(:user_bookmarks).as_json.should eq(@user_bookmarks.as_json)
        end
      end #end context with a bookmark present

      context "without the bookmark present" do
        before do
          get :json_show_user_bookmark_by_user_id_and_bookmark_id,
            user_id: @user.id,
            bookmark_id: @bookmark2.id,
            :format => :json
          @body = JSON.parse(response.body)
        end
        it "should be successful and have status 200" do
          expect(response.status).to eq(200)
          response.should be_success
        end
        it "should be an empty array" do
          expect(@body).to be_empty
        end
      end #end context without a bookmark present
    end #end context correct user
    

    context "Another user signed in" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
        get :json_show_user_bookmark_by_user_id_and_bookmark_id,
            user_id: @user.id,
            bookmark_id: @bookmark1.id,
            :format => :json
      end

      context "with a bookmark present" do

        it "should be successful" do
          response.should be_success
        end

        it "has a 200 status code" do
          expect(response.status).to eq(200)
        end

        it "should get the user bookmark with values" do
          # Bookmark.columns_hash.each {|k,v| puts "#{k} => #{v.type}"}
          # @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
          # user_bookmark=FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark1.id)

          #Note this assumes that the newly added bookmark is not a custom bookmark. 
          # Otherwise, we'd have to add sql parameters defined in the controller. 
          body = JSON.parse(response.body)
          user_bookmark_test = Bookmark.
              select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
              joins(:users_bookmarks).
              joins(:bookmarks_category).
              where('user_id = ? and bookmark_id =?',@user.id,@bookmark1.id)
          #puts @user_bookmarks.as_json

          user_bookmark_test[0].id.should == body["id"]
          user_bookmark_test[0].bookmark_url.should == body["bookmark_url"]
          user_bookmark_test[0].bookmarks_category_id.should ==body["bookmarks_category_id"]
          user_bookmark_test[0].description.should ==body["description"]
          user_bookmark_test[0].i_frame.should ==body["i_frame"]
          user_bookmark_test[0].item_id.should ==body["item_id"]
          user_bookmark_test[0].like.should ==body["like"]
          user_bookmark_test[0].position.should ==body["position"]
         # assigns(:user_bookmarks).as_json.should eq(@user_bookmarks.as_json)
        end
      end #end context with a bookmark present

      context "without the bookmark present" do
        before do
          get :json_show_user_bookmark_by_user_id_and_bookmark_id,
            user_id: @user.id,
            bookmark_id: @bookmark2.id,
            :format => :json
          @body = JSON.parse(response.body)
        end
        it "should be successful and have status 200" do
          expect(response.status).to eq(200)
          response.should be_success
        end
        it "should be an empty array" do
          expect(@body).to be_empty
        end
      end #end context without a bookmark present

    end

    context "signed out" do
      before do
        sign_out
        get :json_show_user_bookmark_by_user_id_and_bookmark_id,
          user_id: @user.id,
          bookmark_id: @bookmark1.id,
          :format => :json
      end
      context "with a bookmark present" do

        it "should be successful" do
          response.should be_success
        end

        it "has a 200 status code" do
          expect(response.status).to eq(200)
        end

        it "should get the user bookmark with values" do
          # Bookmark.columns_hash.each {|k,v| puts "#{k} => #{v.type}"}
          # @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
          # user_bookmark=FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:@bookmark1.id)

          #Note this assumes that the newly added bookmark is not a custom bookmark. 
          # Otherwise, we'd have to add sql parameters defined in the controller. 
          body = JSON.parse(response.body)
          user_bookmark_test = Bookmark.
              select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
              joins(:users_bookmarks).
              joins(:bookmarks_category).
              where('user_id = ? and bookmark_id =?',@user.id,@bookmark1.id)
          #puts @user_bookmarks.as_json

          user_bookmark_test[0].id.should == body["id"]
          user_bookmark_test[0].bookmark_url.should == body["bookmark_url"]
          user_bookmark_test[0].bookmarks_category_id.should ==body["bookmarks_category_id"]
          user_bookmark_test[0].description.should ==body["description"]
          user_bookmark_test[0].i_frame.should ==body["i_frame"]
          user_bookmark_test[0].item_id.should ==body["item_id"]
          user_bookmark_test[0].like.should ==body["like"]
          user_bookmark_test[0].position.should ==body["position"]
         # assigns(:user_bookmarks).as_json.should eq(@user_bookmarks.as_json)
        end
      end #end context with a bookmark present

      context "without the bookmark present" do
        before do
          get :json_show_user_bookmark_by_user_id_and_bookmark_id,
            user_id: @user.id,
            bookmark_id: @bookmark2.id,
            :format => :json
          @body = JSON.parse(response.body)
        end
        it "should be successful and have status 200" do
          expect(response.status).to eq(200)
          response.should be_success
        end
        it "should be an empty array" do
          expect(@body).to be_empty
        end
      end #end context without a bookmark present

    end

  end

  describe "GET json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset", tag_bm:true do
    before do
      #ensure user has 4 bookmarks. 
      @item = FactoryGirl.create(:item)
      @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
      for i in 1..4
        bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
        user_bookmark = FactoryGirl.create(:users_bookmark,user_id:@user.id,bookmark_id:bookmark.id)
      end
    end

    context "with sign in user" do
      let(:offset){0}
      let(:limit){2}
      before do
        @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
        get :json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset,
          user_id: @user.id,
          item_id: @item.id,
          limit: limit,
          offset: offset,
          :format => :json
      end
      
      context "with limit 2 and offset 0" do
        let(:body){JSON.parse(response.body)}
        it "should have 200 status and be successful" do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "should return 2 bookmarks since limit is 2" do
          body.length.should eq(limit)
        end

        it "should have the correct bookmarks" do
          #   user_bookmarks = Bookmark.
          #     select('bookmarks.id, bookmark_url, bookmarks_category_id, bookmarks_categories.item_id,description, i_frame, image_name, image_name_desc, title,position,"like"').
          #     joins(:users_bookmarks).
          #     joins(:bookmarks_category).
          #     where('user_id = ? and bookmarks_categories.item_id = ?',@user.id,@item.id)
          # puts body
          # puts user_bookmarks
          body.each do |body_user_bookmark|
            bookmark_json = Bookmark.find(body_user_bookmark["id"])
            user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
            body_user_bookmark["id"].should == bookmark_json.id
            body_user_bookmark["bookmark_url"].should == bookmark_json.bookmark_url
            body_user_bookmark["bookmarks_category_id"].should == bookmark_json.bookmarks_category_id
            body_user_bookmark["description"].should == bookmark_json.description
            body_user_bookmark["i_frame"].should == bookmark_json.i_frame
            body_user_bookmark["image_name"]["url"].should == bookmark_json.image_name.to_s
            body_user_bookmark["image_name_desc"]["url"].should == bookmark_json.image_name_desc.to_s
            body_user_bookmark["title"].should == bookmark_json.title
            body_user_bookmark["position"].should == user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == bookmark_json.like
          end

        end

      end #end context with limit 2 and offset 0

      context "with limit 2 and offset 1" do
        let(:body_no_offset){JSON.parse(response.body)}
        let(:offset){1}
        let(:limit){2}

        before do
          get :json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset,
            user_id: @user.id,
            item_id: @item.id,
            limit: limit,
            offset: offset,
            :format => :json
        end

        it "should be successful and status 200" do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "should not contain the first bookmark" do
          body_with_offset = JSON.parse(response.body)
          body_with_offset.should_not include(body_no_offset)
        end

      end #end context with limit 2 and offset 

    end #end context sign in user



    context "with other sign in user" do
      let(:offset){0}
      let(:limit){2}
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
        @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
        get :json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset,
          user_id: @user.id,
          item_id: @item.id,
          limit: limit,
          offset: offset,
          :format => :json
      end
      
      context "with limit 2 and offset 0" do
        let(:body){JSON.parse(response.body)}
        it "should have 200 status and be successful" do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "should return 2 bookmarks since limit is 2" do
          body.length.should eq(limit)
        end

        it "should have the correct bookmarks" do
          #   user_bookmarks = Bookmark.
          #     select('bookmarks.id, bookmark_url, bookmarks_category_id, bookmarks_categories.item_id,description, i_frame, image_name, image_name_desc, title,position,"like"').
          #     joins(:users_bookmarks).
          #     joins(:bookmarks_category).
          #     where('user_id = ? and bookmarks_categories.item_id = ?',@user.id,@item.id)
          # puts body
          # puts user_bookmarks
          body.each do |body_user_bookmark|
            bookmark_json = Bookmark.find(body_user_bookmark["id"])
            user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
            body_user_bookmark["id"].should == bookmark_json.id
            body_user_bookmark["bookmark_url"].should == bookmark_json.bookmark_url
            body_user_bookmark["bookmarks_category_id"].should == bookmark_json.bookmarks_category_id
            body_user_bookmark["description"].should == bookmark_json.description
            body_user_bookmark["i_frame"].should == bookmark_json.i_frame
            body_user_bookmark["image_name"]["url"].should == bookmark_json.image_name.to_s
            body_user_bookmark["image_name_desc"]["url"].should == bookmark_json.image_name_desc.to_s
            body_user_bookmark["title"].should == bookmark_json.title
            body_user_bookmark["position"].should == user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == bookmark_json.like
          end

        end

      end #end context with limit 2 and offset 0

      context "with limit 2 and offset 1" do
        let(:body_no_offset){JSON.parse(response.body)}
        let(:offset){1}
        let(:limit){2}

        before do
          get :json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset,
            user_id: @user.id,
            item_id: @item.id,
            limit: limit,
            offset: offset,
            :format => :json
        end

        it "should be successful and status 200" do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "should not contain the first bookmark" do
          body_with_offset = JSON.parse(response.body)
          body_with_offset.should_not include(body_no_offset)
        end

      end #end context with limit 2 and offset 

    end #end context sign in with other user
    


    context "with sign out user" do
      
      let(:offset){0}
      let(:limit){2}
      
      before do
        sign_out
        @bookmark1= FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
        get :json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset,
          user_id: @user.id,
          item_id: @item.id,
          limit: limit,
          offset: offset,
          :format => :json
      end
      
      context "with limit 2 and offset 0" do
        let(:body){JSON.parse(response.body)}
        it "should have 200 status and be successful" do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "should return 2 bookmarks since limit is 2" do
          body.length.should eq(limit)
        end

        it "should have the correct bookmarks" do
          #   user_bookmarks = Bookmark.
          #     select('bookmarks.id, bookmark_url, bookmarks_category_id, bookmarks_categories.item_id,description, i_frame, image_name, image_name_desc, title,position,"like"').
          #     joins(:users_bookmarks).
          #     joins(:bookmarks_category).
          #     where('user_id = ? and bookmarks_categories.item_id = ?',@user.id,@item.id)
          # puts body
          # puts user_bookmarks
          body.each do |body_user_bookmark|
            bookmark_json = Bookmark.find(body_user_bookmark["id"])
            user_bookmark_json = UsersBookmark.find_by_bookmark_id_and_position(body_user_bookmark["id"],body_user_bookmark["position"])
            body_user_bookmark["id"].should == bookmark_json.id
            body_user_bookmark["bookmark_url"].should == bookmark_json.bookmark_url
            body_user_bookmark["bookmarks_category_id"].should == bookmark_json.bookmarks_category_id
            body_user_bookmark["description"].should == bookmark_json.description
            body_user_bookmark["i_frame"].should == bookmark_json.i_frame
            body_user_bookmark["image_name"]["url"].should == bookmark_json.image_name.to_s
            body_user_bookmark["image_name_desc"]["url"].should == bookmark_json.image_name_desc.to_s
            body_user_bookmark["title"].should == bookmark_json.title
            body_user_bookmark["position"].should == user_bookmark_json.position.to_s
            body_user_bookmark["like"].should == bookmark_json.like
          end

        end

      end #end context with limit 2 and offset 0

      context "with limit 2 and offset 1" do
        let(:body_no_offset){JSON.parse(response.body)}
        let(:offset){1}
        let(:limit){2}

        before do
          get :json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset,
            user_id: @user.id,
            item_id: @item.id,
            limit: limit,
            offset: offset,
            :format => :json
        end

        it "should be successful and status 200" do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "should not contain the first bookmark" do
          body_with_offset = JSON.parse(response.body)
          body_with_offset.should_not include(body_no_offset)
        end

      end #end context with limit 2 and offset 
    end
  end

end
