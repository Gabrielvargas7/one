require 'spec_helper'


describe NotificationsController do
  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    @notification = FactoryGirl.create(:notification)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @notification }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:notification_all) { Notification.all }

      it "assigns all notification as @notification" do
        get :index
        assigns(:notifications).should eq(notification_all)
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

      it "assigns the requested notification as @notification" do
        get :show, id: @notification
        assigns(:notification).should eq(@notification)

      end

      it "renders the #show view" do

        get :show, id: @notification
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@notification
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@notification
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new notifications as @notifications" do

        new_notification = FactoryGirl.create(:notification)
        Notification.should_receive(:new).and_return(new_notification)
        get :new
        assigns[:notification].should eq(new_notification)
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

      it "assigns the requested notification as @notification" do

        new_notification = FactoryGirl.create(:notification)
        get :edit, id: new_notification
        assigns[:notification].should eq(new_notification)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_notification = FactoryGirl.create(:notification)
        get :edit, id: new_notification
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

        it "creates a new Notification" do
          expect {
            post :create,notification: FactoryGirl.attributes_for(:notification)
          }.to change(Notification, :count).by(1)
        end


        it "update a user notification" do
           UsersNotification.update_all(notified: 'y')
           @users_notification = UsersNotification.last
           @users_notification.notified.should eq('y')
           post :create,notification: FactoryGirl.attributes_for(:notification)

           @notification = Notification.last
           @users_notification = UsersNotification.last
           @users_notification.notified.should eq('n')
           @users_notification.notification_id.should eq(@notification.id)
        end

        it "assigns a newly created notification as @notification" do
          post :create,notification: FactoryGirl.attributes_for(:notification)
          assigns(:notification).should be_a(Notification)
          assigns(:notification).should be_persisted
        end

        it "redirects to the created notification" do
          post :create, notification: FactoryGirl.attributes_for(:notification)
          response.should redirect_to(Notification.last)
        end
      end


    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create, notification: FactoryGirl.attributes_for(:notification)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created notification" do
        post :create, notification: FactoryGirl.attributes_for(:notification)
        response.should_not redirect_to(Notification.last)
      end
    end

  end


  ##***********************************
  ## rspec test  update
  ##***********************************

  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @notification" do
          put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification)
          assigns(:notification).should eq(@notification)
        end
      end

      it "changes @notification's attributes" do
        put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification, name: "new notification", description: "new desc")
        @notification.reload
        @notification.name.should eq("new notification")
        @notification.description.should eq("new desc")
      end

      it "redirects to the updated notification" do
        put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification)
        response.should redirect_to @notification
      end

      context "invalid attributes" do

        it "locates the requested @notification" do
          put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification,name:nil)
          assigns(:notification).should eq(@notification)
        end
        it "does not change @notification's attributes" do

          put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification,name:nil)
          @notification.reload
          @notification.name.should_not eq(nil)
        end
        it "re-renders the edit method" do
          put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification,name:nil)
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
        put :update, id: @notification, notification: FactoryGirl.attributes_for(:notification)
        response.should redirect_to root_path
      end

    end


  end





end
