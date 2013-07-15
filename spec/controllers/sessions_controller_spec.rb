require 'spec_helper'


describe SessionsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    @user = FactoryGirl.create(:user)
    #sign_in @user
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @user }


  #***********************************
  # rspec test create
  #***********************************


  describe "POST create", tag_create:true  do

    describe "is public " do
    #  context "with valid params" do
    #
    #    it "creates a new session" do
    #      post :create,session_email:@user.email,session_password:@user.password
    #      response.should redirect_to room_rooms_path(@user.username)
    #
    #    end
    #  end

      #context "with invalid params" do
      #
      #  it "creates a new session" do
      #
      #    @user1 = FactoryGirl.create(:user,password:"new password")
      #    post :create,email:@user1,password:@user.password
      #    response.should redirect_to root_path
      #
      #  end
      #end
    end

  end






end

