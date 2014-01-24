require 'spec_helper'

describe UsersNotificationsController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  #before  do
  #  @user = FactoryGirl.create(:user)
  #  @notification = FactoryGirl.create(:notification)
  #  @user_notification = FactoryGirl.create(:users_notification,user_id:@user.id,notification_id:@notification.id,notified:'n')
  #  sign_in @user
  #  #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  #end


  #the (subject)line declare the variable that is use in all the test
  #subject { @user_notification }


  #***********************************
  # rspec test  #json_show_user_notification_by_user
  #***********************************


  describe "api #json_show_user_notification_by_user", tag_json_show: true do

      describe "is regular user api when notified is 'n'" do

      before  do
        @user = FactoryGirl.create(:user)
        @notification = FactoryGirl.create(:notification)
        @notification_user = Notification.select('notifications.*,users_notifications.notified,users_notifications.user_id').
            joins(:users_notifications).where('users_notifications.user_id = ?',@user.id)

        @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
        @user_notification.notification_id = @notification.id
        @user_notification.notified = 'n'
        @user_notification.save!
        sign_in @user
      end

        it "should be successful" do
          get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
          response.should be_success
        end


        it "should set user notification" do
          get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
          assigns(:notification).as_json.should == @notification_user.as_json
        end

        it "has a 200 status code" do
          get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
          expect(response.status).to eq(200)
        end

      context "get a values " do

        it "should return json_show user notification in json" do # depend on what you return in action
          #puts @user.as_json
          #puts @notification.as_json
          #puts @user_notification.as_json
          get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
          body = JSON.parse(response.body)
          body.each do |body_notification|
            body_notification["name"].should == @notification.name
            body_notification["description"].should == @notification.description.to_s
            body_notification["id"].should == @notification.id
            body_notification["image_name"]["url"].should == @notification.image_name.to_s
            body_notification["notified"].should == 'n'
            body_notification["user_id"].should == @user.id
          end


        end
      end
      end

      describe "is regular user api when notified is 'y'" do

        before  do
          @user = FactoryGirl.create(:user)
          @notification = FactoryGirl.create(:notification)
          @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
          @user_notification.notification_id = @notification.id
          @user_notification.notified = 'y'
          @user_notification.save!
          sign_in @user
        end

        it "has a 200 status code" do
          get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
          expect(response.status).to eq(200)
        end
      end

      describe "is sign out user" do

        before  do
          @user = FactoryGirl.create(:user)
          @notification = FactoryGirl.create(:notification)
          @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
          @user_notification.notification_id = @notification.id
          @user_notification.notified = 'n'
          @user_notification.save!
          sign_out
        end

        it "has a 404 status code" do
          get :json_show_user_notification_by_user, user_id: @user_notification.user_id, :format => :json
          expect(response.status).to eq(404)
        end
      end

  end






  # PUT set user notified to yes by user id
  # users_notifications/json/update_user_notification_to_notified_by_user/:user_id'
  # users_notifications/json/update_user_notification_to_notified_by_user/1.json'
  #Return ->
  #success    ->  head  200 OK

  #***********************************
  # rspec test  json_update_user_notification_to_notified_by_user
  #***********************************


  describe "PUT json_update_user_notification_to_notified_by_user", tag_json_update: true do

    describe "is regular user" do
      before  do
        @user = FactoryGirl.create(:user)
        @notification = FactoryGirl.create(:notification)
        @user_notification = UsersNotification.find_all_by_user_id(@user.id).first
        @user_notification.notification_id = @notification.id
        @user_notification.notified = 'n'
        @user_notification.save!
        sign_in @user
      end

      context "valid attributes" do
        it "located the requested @user notification" do
          put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
          assigns(:user_notification).should eq(@user_notification)
        end
      end

      it "changes @user notification's attributes" do

        @user_notification.notified.should eq("n")
        put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
        @user_notification.reload
        @user_notification.notified.should eq("y")
      end


      it "response should be success" do
        put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
        response.should be_success
      end

      it "has a 200 status code OK" do
        put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "return json values " do
        it "should return user request in json" do # depend on what you return in action
          put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
          @user_notification.reload
          body = JSON.parse(response.body)
          body["user_id"].should == @user_notification.user_id
          body["notified"].should == @user_notification.notified
          body["notification_id"].should == @user_notification.notification_id

        end
      end

      context "return json values " do
        it "should count one user notification 'y' " do
          put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
          @user_notification_count  = UsersNotification.where("notified = 'y' and user_id = ?",@user.id).count
          @user_notification_count.should == 1
        end

      end

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
        put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        put :json_update_user_notification_to_notified_by_user, user_id: @user.id, :format => :json
        expect(response.status).to eq(404)
      end
    end


  end

  end


end
