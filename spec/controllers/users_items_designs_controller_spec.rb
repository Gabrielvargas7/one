require 'spec_helper'

describe UsersItemsDesignsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @user = FactoryGirl.create(:user)
    @section = FactoryGirl.create(:section)
    @location1 = FactoryGirl.create(:location,section_id:@section.id )
    @location2 = FactoryGirl.create(:location,section_id:@section.id )

    @item1 = FactoryGirl.create(:item)
    @item2 = FactoryGirl.create(:item)

    @items_location1 = FactoryGirl.create(:items_location,location_id:@location1.id,item_id:@item1.id)

    @items_designs1 = FactoryGirl.create(:items_design,item_id:@item1.id)
    @items_designs2 = FactoryGirl.create(:items_design,item_id:@item1.id)


    @user_items_design1 = FactoryGirl.create(:users_items_design,user_id:@user.id,items_design_id:@items_designs1.id,location_id:@items_location1.location_id)



    sign_in @user

  end


  #the (subject)line declare the variable that is use in all the test
  #subject { @user_notification }


  #   GET get all the Item design of the user
  #  /users_items_designs/json/index_user_items_designs_by_user_id/:user_id
  #  /users_items_designs/json/index_user_items_designs_by_user_id/10000001.json
  # Return ->
  # success    ->  head  200 OK
  #def json_index_user_items_designs_by_user_id

  #***********************************
  # rspec test  #json_index_user_items_designs_by_user_id
  #***********************************


  describe "api #json_index_user_items_designs_by_user_id",tag_json_show:true do

    describe "is regular user api " do

      before  do
      end

      it "should be successful" do
        get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json
        response.should be_success
      end


      #it "should set user items design" do
      #  get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json
      #  assigns(:user_items_designs).as_json.should == @items_designs1.as_json
      #end

      it "has a 200 status code" do
        get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get a values " do

        it "should return json_show user item design in json" do

          get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json

          body = JSON.parse(response.body)

          body.each do |body_items_design|
            @items_designs_json = ItemsDesign.find(body_items_design["id"])
            @user_items_design_json = UsersItemsDesign.
                where("user_id = ? and location_id = ? and items_design_id = ?",
                    @user.id,body_items_design["location_id"],body_items_design["id"]).first
            @location_json = Location.find(body_items_design["location_id"])

            body_items_design["name"].should == @items_designs_json.name
            body_items_design["item_id"].should == @items_designs_json.item_id
            body_items_design["description"].should == @items_designs_json.description
            body_items_design["image_name"]["url"].should == @items_designs_json.image_name.to_s
            body_items_design["hide"].should == @user_items_design_json.hide
            body_items_design["section_id"].should == @location_json.section_id.to_s
            body_items_design["category"].should == @items_designs_json.category
            body_items_design["style"].should == @items_designs_json.style
            body_items_design["brand"].should == @items_designs_json.brand
            body_items_design["color"].should == @items_designs_json.color
            body_items_design["make"].should == @items_designs_json.make
            body_items_design["special_name"].should == @items_designs_json.special_name
            body_items_design["like"].should == @items_designs_json.like


          end
        end
      end
    end

    #describe "is regular user api when notified is 'y'" do
    #
    #  before  do
    #    @user = FactoryGirl.create(:user)
    #    @notification = FactoryGirl.create(:notification)
    #    @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
    #    @user_notification.notification_id = @notification.id
    #    @user_notification.notified = 'y'
    #    @user_notification.save!
    #    sign_in @user
    #  end
    #
    #  it "has a 404 status code" do
    #    get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
    #    expect(response.status).to eq(404)
    #  end
    #end

    describe "is sign out user" do
      before  do
        sign_out
      end

      it "has a 404 status code" do
        #get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json
        #expect(response.status).to eq(404)
        pending "pending test api for security"
      end
    end

  end

  # GET get one item design of the user
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/10000001/100.json
  #Return ->
  #success    ->  head  200 OK
  #def json_show_user_items_design_by_user_id_and_items_design_id


        #***********************************
    # rspec test  #json_show_user_items_design_by_user_id_and_items_design_id
    #***********************************


  describe "api #json_show_user_items_design_by_user_id_and_items_design_id",tag_json_show:true do

    describe "is regular user api " do

      before  do
      end

      it "should be successful" do
        get :json_show_user_items_design_by_user_id_and_items_design_id, user_id: @user.id,items_design_id:@user_items_design1.items_design_id, :format => :json
        response.should be_success
      end


      #it "should set user items design" do
      #  get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json
      #  assigns(:user_items_designs).as_json.should == @items_designs1.as_json
      #end

      it "has a 200 status code" do
        get :json_show_user_items_design_by_user_id_and_items_design_id, user_id: @user.id,items_design_id:@user_items_design1.items_design_id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get a values " do

        it "should return json_show user item design in json" do

          get :json_show_user_items_design_by_user_id_and_items_design_id, user_id: @user.id,items_design_id:@user_items_design1.items_design_id, :format => :json

          body = JSON.parse(response.body)

          body.each do |body_items_design|
            @items_designs_json = ItemsDesign.find(body_items_design["id"])
            @user_items_design_json = UsersItemsDesign.
                where("user_id = ? and location_id = ? and items_design_id = ?",
                      @user.id,body_items_design["location_id"],body_items_design["id"]).first
            @location_json = Location.find(body_items_design["location_id"])

            body_items_design["name"].should == @items_designs_json.name
            body_items_design["item_id"].should == @items_designs_json.item_id
            body_items_design["description"].should == @items_designs_json.description
            body_items_design["image_name"]["url"].should == @items_designs_json.image_name.to_s
            body_items_design["hide"].should == @user_items_design_json.hide
            body_items_design["section_id"].should == @location_json.section_id.to_s
            body_items_design["category"].should == @items_designs_json.category
            body_items_design["style"].should == @items_designs_json.style
            body_items_design["brand"].should == @items_designs_json.brand
            body_items_design["color"].should == @items_designs_json.color
            body_items_design["make"].should == @items_designs_json.make
            body_items_design["special_name"].should == @items_designs_json.special_name
            body_items_design["like"].should == @items_designs_json.like
          end
        end
      end
    end

    #describe "is regular user api when notified is 'y'" do
    #
    #  before  do
    #    @user = FactoryGirl.create(:user)
    #    @notification = FactoryGirl.create(:notification)
    #    @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
    #    @user_notification.notification_id = @notification.id
    #    @user_notification.notified = 'y'
    #    @user_notification.save!
    #    sign_in @user
    #  end
    #
    #  it "has a 404 status code" do
    #    get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
    #    expect(response.status).to eq(404)
    #  end
    #end

    describe "is sign out user" do
      before  do
        sign_out
      end

      it "has a 404 status code" do
        #get :json_show_user_items_design_by_user_id_and_items_design_id, user_id: @user.id,items_design_id:@user_items_design1.items_design_id, :format => :json
        #expect(response.status).to eq(404)
        pending "pending test api for security"
      end
    end

  end



  #   GET get all the Item design of the user and section id
  #  /users_items_designs/json/index_user_items_designs_by_user_id_and_section_id/:user_id/:section_id
  #  /users_items_designs/json/index_user_items_designs_by_user_id/23/1.json
  # Return ->
  # success    ->  head  200 OK
  #def json_index_user_items_designs_by_user_id_and_section_id

    #***********************************
  # rspec test  #json_index_user_items_designs_by_user_id_and_section_id
  #***********************************


  describe "api #json_index_user_items_designs_by_user_id_and_section_id",tag_json_show:true do

    describe "is regular user api " do

      before  do
      end

      it "should be successful" do
        get :json_index_user_items_designs_by_user_id_and_section_id, user_id: @user.id,section_id:@section.id, :format => :json
        response.should be_success
      end


      #it "should set user items design" do
      #  get :json_index_user_items_designs_by_user_id, user_id: @user_items_design1.user_id, :format => :json
      #  assigns(:user_items_designs).as_json.should == @items_designs1.as_json
      #end

      it "has a 200 status code" do
        get :json_index_user_items_designs_by_user_id_and_section_id, user_id: @user.id,section_id:@section.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get a values " do

        it "should return json_show user item design in json" do

          get :json_index_user_items_designs_by_user_id_and_section_id, user_id: @user.id,section_id:@section.id, :format => :json

          body = JSON.parse(response.body)

          body.each do |body_items_design|
            @items_designs_json = ItemsDesign.find(body_items_design["id"])
            @user_items_design_json = UsersItemsDesign.
                where("user_id = ? and location_id = ? and items_design_id = ?",
                      @user.id,body_items_design["location_id"],body_items_design["id"]).first
            @location_json = Location.find(body_items_design["location_id"])

            body_items_design["name"].should == @items_designs_json.name
            body_items_design["item_id"].should == @items_designs_json.item_id
            body_items_design["description"].should == @items_designs_json.description
            body_items_design["image_name"]["url"].should == @items_designs_json.image_name.to_s
            body_items_design["hide"].should == @user_items_design_json.hide
            body_items_design["section_id"].should == @location_json.section_id.to_s
            body_items_design["category"].should == @items_designs_json.category
            body_items_design["style"].should == @items_designs_json.style
            body_items_design["brand"].should == @items_designs_json.brand
            body_items_design["color"].should == @items_designs_json.color
            body_items_design["make"].should == @items_designs_json.make
            body_items_design["special_name"].should == @items_designs_json.special_name
            body_items_design["like"].should == @items_designs_json.like
          end
        end
      end
    end

    #describe "is regular user api when notified is 'y'" do
    #
    #  before  do
    #    @user = FactoryGirl.create(:user)
    #    @notification = FactoryGirl.create(:notification)
    #    @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
    #    @user_notification.notification_id = @notification.id
    #    @user_notification.notified = 'y'
    #    @user_notification.save!
    #    sign_in @user
    #  end
    #
    #  it "has a 404 status code" do
    #    get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
    #    expect(response.status).to eq(404)
    #  end
    #end

    describe "is sign out user" do
      before  do
        sign_out
      end

      it "has a 404 status code" do
        #get :json_index_user_items_designs_by_user_id_and_section_id, user_id: @user.id,section_id:@section.id, :format => :json
        #expect(response.status).to eq(404)
        pending "pending test api for security"
      end
    end

  end



  #//# PUT change the user's items design by user id and item design id
  #//#  /users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id'
  #//#  /users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
  #//#  Form Parameters:
  #//#                  :new_items_design_id = 1
  #Return ->
  #success    ->  head  200 OK
  ##***********************************
  ## rspec test  json_update_user_items_design_by_user_id_and_items_design_id_and_location_id
  ##***********************************
  #

  describe "PUT json_update_user_notification_to_notified_by_user", tag_json_update:true do

    describe "is regular user" do
      before  do
      end

      context "valid attributes" do
        it "located the requested @user items design" do
          put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              new_items_design_id:  @items_designs2.id,
              :format => :json
          assigns(:user_items_design).should eq(@user_items_design1)
        end
      end

      it "changes @user items_design's attributes" do

        @user_items_design1.items_design_id.should eq(@items_designs1.id)
        put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
            user_id: @user_items_design1.user_id,
            items_design_id:@user_items_design1.items_design_id,
            location_id:@user_items_design1.location_id,
            new_items_design_id:  @items_designs2.id,
            :format => :json

        @user_items_design1.reload
        @user_items_design1.items_design_id.should eq(@items_designs2.id)
      end


      it "response should be success" do
        put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
            user_id: @user_items_design1.user_id,
            items_design_id:@user_items_design1.items_design_id,
            location_id:@user_items_design1.location_id,
            new_items_design_id:  @items_designs2.id,
            :format => :json

        response.should be_success
      end

      it "has a 200 status code OK" do
        put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
            user_id: @user_items_design1.user_id,
            items_design_id:@user_items_design1.items_design_id,
            location_id:@user_items_design1.location_id,
            new_items_design_id:  @items_designs2.id,
            :format => :json

        expect(response.status).to eq(200)
      end

      context "return json values " do
        it "should return user request in json" do # depend on what you return in action
          put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              new_items_design_id:  @items_designs2.id,
              :format => :json

          @user_items_design1.reload
          body = JSON.parse(response.body)
          body["user_id"].should == @user_items_design1.user_id
          body["id"].should == @user_items_design1.id
          body["items_design_id"].should == @user_items_design1.items_design_id
          body["location_id"].should == @user_items_design1.location_id
        end
      end

      #context "return json values " do
      #  it "should count one user notification 'y' " do
      #    put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
      #    @user_notification_count  = UsersNotification.where("notified = 'y' and user_id = ?",@user.id).count
      #    @user_notification_count.should == 1
      #  end
      #end

      #context "invalid attributes" do
      #
      #  it "does not change @users photo's attributes" do
      #    put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:-1  , :format => :json
      #    @users_photo.reload
      #    @users_photo.profile_image.should_not eq("y")
      #  end
      #end


      context "is sign in with other user" do
        before do
          @user1 = FactoryGirl.create(:user)
          sign_in @user1
        end
        it "has a 404 status code" do
          put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              new_items_design_id:  @items_designs2.id,
              :format => :json
          expect(response.status).to eq(404)
        end
      end


      context "is sign out user" do
        before do
          sign_out
        end
        it "has a 404 status code" do
          put :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              new_items_design_id:  @items_designs2.id,
              :format => :json

          expect(response.status).to eq(404)
        end
      end


    end

  end


  #   PUT (hide the item)toggle the user items design with (yes to no to yes)
  #  /users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id
  #  /users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
  #       toggle operation -> yes -> no
  #Return ->
  #success    ->  head  200 OK

  #json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id

    ##***********************************
    ## rspec test  json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id
    ##***********************************
    #

    describe "PUT json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id", tag_json_update:true do

      describe "is regular user" do
        before  do
        end

        context "valid attributes" do
          it "located the requested @user items design" do
            put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
                user_id: @user_items_design1.user_id,
                items_design_id:@user_items_design1.items_design_id,
                location_id:@user_items_design1.location_id,
                :format => :json
            assigns(:user_items_design).should eq(@user_items_design1)
          end
        end

        it "changes @user items_design's attributes" do

          @user_items_design1.hide.should eq('no')
          put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              :format => :json

          @user_items_design1.reload
          @user_items_design1.hide.should eq('yes')
        end


        it "response should be success" do
          put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              :format => :json

          response.should be_success
        end

        it "has a 200 status code OK" do
          put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
              user_id: @user_items_design1.user_id,
              items_design_id:@user_items_design1.items_design_id,
              location_id:@user_items_design1.location_id,
              :format => :json

          expect(response.status).to eq(200)
        end

        context "return json values " do
          it "should return user request in json" do # depend on what you return in action
            put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
                user_id: @user_items_design1.user_id,
                items_design_id:@user_items_design1.items_design_id,
                location_id:@user_items_design1.location_id,
                :format => :json

            @user_items_design1.reload
            body = JSON.parse(response.body)
            body["user_id"].should == @user_items_design1.user_id
            body["id"].should == @user_items_design1.id
            body["items_design_id"].should == @user_items_design1.items_design_id
            body["location_id"].should == @user_items_design1.location_id
          end
        end

        #context "return json values " do
        #  it "should count one user notification 'y' " do
        #    put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
        #    @user_notification_count  = UsersNotification.where("notified = 'y' and user_id = ?",@user.id).count
        #    @user_notification_count.should == 1
        #  end
        #end

        #context "invalid attributes" do
        #
        #  it "does not change @users photo's attributes" do
        #    put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:-1  , :format => :json
        #    @users_photo.reload
        #    @users_photo.profile_image.should_not eq("y")
        #  end
        #end


        context "is sign in with other user" do
          before do
            @user1 = FactoryGirl.create(:user)
            sign_in @user1
          end
          it "has a 404 status code" do
            put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
                user_id: @user_items_design1.user_id,
                items_design_id:@user_items_design1.items_design_id,
                location_id:@user_items_design1.location_id,
                :format => :json
            expect(response.status).to eq(404)
          end
        end


        context "is sign out user" do
          before do
            sign_out
          end
          it "has a 404 status code" do
            put :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
                user_id: @user_items_design1.user_id,
                items_design_id:@user_items_design1.items_design_id,
                location_id:@user_items_design1.location_id,
                :format => :json

            expect(response.status).to eq(404)
          end
        end


      end

    end







  end
