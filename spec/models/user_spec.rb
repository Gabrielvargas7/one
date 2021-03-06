# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  username               :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  provider               :string(255)
#  uid                    :string(255)
#

require 'spec_helper'

describe User do


  # the (before) line will instance the variable for every (describe methods)
  #before { @user = User.new(name: "Example User", email: "user@example.com", password: "foobar")}

  before(:all){ create_init_data }
  after(:all){ delete_init_data }
  before {@user = FactoryGirl.build(:user) }

  #the (subject)line declare the variable that is use in all the test
  subject { @user }


  #user info

  it { @user.should respond_to(:email) }
  it { @user.should respond_to(:username)}
  it { @user.should respond_to(:admin) }
  it { @user.should respond_to(:specific_room_id) }



  #room authentication
  it { @user.should respond_to(:password_digest)}
  it { should respond_to(:password) }
  it { should respond_to(:authenticate) }

  # cookies value
  it { @user.should respond_to(:remember_token)}

  #facebook or other authentication
  it { @user.should respond_to(:provider)}
  it { @user.should respond_to(:uid)}



  #forget password
  it { @user.should respond_to(:password_reset_token)}
  it { @user.should respond_to(:password_reset_sent_at)}


  it { @user.should be_valid }


  ###############
  #test validation - password
  ###############
  describe "when password ", tag_password: true  do
      context "is not present" do
        before { @user.password =  " " }
        it { @user.should_not be_valid }
      end

      context "is too short" do
        before { @user.password = "a" * 5 }
        it { should be_invalid }
      end
  end

  ###############
  #test validation - authenticate
  ###############
  describe "return value of authenticate method" , tag_authenticate: true do

      before { @user.save }


      let(:found_user) { User.find_by_email(@user.email) }

      #here the variable found_user check is the user is valid with the method authenticate
      context "with valid password" do
        it { @user.should == found_user.authenticate(@user.password) }
      end


      context "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid") }
        it { @user.should_not == user_for_invalid_password }

        specify { user_for_invalid_password.should be_false }

      end
  end


  ###############
  #test validation - email
  ###############
  describe "when email ",tag_email: true do

      context  "is not present" do
        before { @user.email = " " }
        it { should_not be_valid }
      end

      context "format is invalid" do
          it "should be invalid" do
            addresses = %w[user@foo,com
                           user_at_foo.org
                           example.user@foo.
                           foo@bar_baz.com
                           foo@bar+baz.com]

            addresses.each do |invalid_address|
              @user.email = invalid_address
              #puts invalid_address
              @user.should_not be_valid
            end
          end
      end

      context "format is valid" do
          it "should be valid" do
              addresses = %w[user@foo.COM
                             A_US-ER@f.b.org
                             frst.lst@foo.jp
                              a+b@baz.cn]

              addresses.each do |valid_address|
                @user.email = valid_address
                @user.should be_valid
              end
          end
      end

      context "address is already taken" do
          before do
              user_with_same_email = @user.dup
              user_with_same_email.email = @user.email
              user_with_same_email.save
              #print user_with_same_email.email+"  "
              #print @user.email
          end
          it { @user.should_not be_valid }
      end


  end


  ###############
  #test validation - remember_token (cookies)
  ###############
  describe "remember token", tag_remember_token: true do

    before{@user.save}

    # these two test, test the same thing
    # it just show two ways to do it
    its(:remember_token){should_not be_blank}
    it{@user.remember_token.should_not be_blank}
  end


  ###############
  #test validation - user admin
  ###############

  describe "admin user", tag_user_admin:true do

      it { @user.should_not be_admin }
      context "with admin attribute set to 'true'" do
        before do
          @user.save!
          @user.toggle!(:admin)
        end
        it { should be_admin }
     end

  end

  ###############
  #test validation - username
  ###############

  describe "username", tag_username: true do
    before{@user.save}

    # these two test, test the same thing
    # it just show two ways to do it
    its(:username){should_not be_blank}
    it{@user.username.should_not be_blank}

    context "username is already taken" do

      before do

        @user_with_same_username = User.new(email:@user.username, password: "foobar")
        @user_with_same_username.save
        @user.save
      end

      it { @user.username.should_not == @user_with_same_username.username  }
    end


    context "get user name method" do

       it " should be valid"  do
         username =  @user.get_username("test@a.com")
         username.should == "test"

         username =  @user.get_username("te_st@a.com")
         username.should == "test"

         username =  @user.get_username("t#est123_@a.com")
         username.should == "test123"
       end

       it "should be unique"  do
         @user1 = FactoryGirl.create(:user,email:"email_unique@uni.com")
         @user2 = FactoryGirl.build(:user,email:"email_unique@uni.com")

         username1 = @user1.get_username("email_unique@uni.com")
         username2 = @user2.get_username("email_unique@uni.com")

          username1.should_not eq(username2)
       end
    end

  end

  ###############
  #test validation - create user-notification
  ###############

  describe "user notification", tag_user_notification:true do

    before{@user.save}
    let(:user_notification) { UsersNotification.find_by_user_id(@user.id) }
    let(:user_notification_not_exist) { UsersNotification.find_by_user_id(@user.id+1) }
    it do
      #puts @user.id
      user_notification.should be_valid
    end

    it "should not be valid " do
      user_notification_not_exist.should be_nil
    end

    it "build a new user notification" do
      expect {
        FactoryGirl.build(:user)
      }.to change(UsersNotification, :count).by(0)
    end

    it "creates a new user notification" do
      expect {
        FactoryGirl.create(:user)
      }.to change(UsersNotification, :count).by(1)
    end


  end


  ###############
  #test validation - send signup email
  ###############
  describe "#send_signup_user_email", tag_send_signup_user_email:true do
    it "delivers email to user" do
      @user.send_signup_user_email
      #last_email.to.should include (@user.email)
      last_email = ActionMailer::Base.deliveries.last
      last_email.to.should include(@user.email)
    end
  end



  ###############
  #test validation - forget password
  ###############
    describe "#send_password_reset", tag_send_password_reset:true do

      it "generates a unique password_reset_token each time" do
        @user.send_password_reset
        last_token = @user.password_reset_token
        @user.send_password_reset
        @user.password_reset_token.should_not eq(last_token)
      end

      it "saves the time the password reset was sent" do
        @user.send_password_reset
        @user.reload.password_reset_sent_at.should be_present
      end

      it "delivers email to user" do
        @user.send_password_reset
        last_email = ActionMailer::Base.deliveries.last
        last_email.to.should include (@user.email)
      end

   end



  ###############
  #test validation - create user photo name
  ###############
  describe "#create user photo for the user",tag_photo:true do

    before{@user.save}
    let(:user_photo) { UsersPhoto.find_by_user_id(@user.id) }
    let(:user_photo_not_exist) { UsersPhoto.find_by_user_id(@user.id+1) }
    it "should be valid" do
      #puts @user.id
      user_photo.should be_valid
    end

    it "should not be valid " do
      user_photo_not_exist.should be_nil
    end

    it "should image be = profile_image = y " do
      user_photo.profile_image.should eq('y')
    end


    it "build a new user" do
      expect {
        FactoryGirl.build(:user)
      }.to change(UsersPhoto, :count).by(0)
    end

    it "creates a new user" do
      expect {
        FactoryGirl.create(:user)
      }.to change(UsersPhoto, :count).by(1)
    end
  end


  ###############
  #test validation - create user profile name
  ###############
  describe "#create user profile for the user",tag_profile:true do

    before{@user.save}
    let(:user_profile) { UsersProfile.find_by_user_id(@user.id) }
    let(:user_profile_not_exist) { UsersProfile.find_by_user_id(@user.id+1) }
    it "should be valid" do
      user_profile.should be_valid
    end

    it "should not be valid " do
      user_profile_not_exist.should be_nil
    end

    it "should image be = profile_image = y " do
      user_profile.tutorial_step.should eq(1)
    end

    it "build a new user" do
      expect {
        FactoryGirl.build(:user)
      }.to change(UsersProfile, :count).by(0)
    end

    it "creates a new user" do
      expect {
        FactoryGirl.create(:user)
      }.to change(UsersProfile, :count).by(1)
    end


  end


  ###############
  #test validation - create random room
  ###############
  describe "#specific_room",tag_specific_room:true do

    before do
      @bundle = Bundle.first
    end

    context "must have a theme " do
      it "create user must change user theme by 1" do
        expect {
          FactoryGirl.create(:user,specific_room_id:@bundle.id)
        }.to change(UsersTheme, :count).by(1)
      end

      it "create user must hava user theme form bundle " do
          user_specific_room = FactoryGirl.create(:user,specific_room_id:@bundle.id)
          @user_theme = UsersTheme.find_by_user_id(user_specific_room.id)
          #puts "user theme"
          #puts @bundle.theme_id
          #puts @user_theme.theme_id
          @user_theme.theme_id.should == @bundle.theme_id
      end
    end


    context "must have a item design " do
      before do
        @bundle_items_design_count = BundlesItemsDesign.where("bundle_id = ?",@bundle.id).count
        #puts " count bundle items designs"
        #puts @bundle_items_design_count
      end
      it "create user must change user items designs by many" do
        expect {
          FactoryGirl.create(:user,specific_room_id:@bundle.id)
        }.to change(UsersItemsDesign, :count).by(@bundle_items_design_count)
      end

      it "create user must have some items designs from bundle  " do

        @bundle_items_designs = BundlesItemsDesign.where("bundle_id = ?",@bundle.id)
        @user_bundle = FactoryGirl.create(:user,specific_room_id:@bundle.id)

        @bundle_items_designs.each do | items_design|

          user_items_design = UsersItemsDesign.find_by_user_id_and_items_design_id(@user_bundle.id,items_design.items_design_id)
          #puts user_items_design.items_design_id
          user_items_design.should be_valid
        end
      end
    end

    context "must have a bookmarks " do
      before do
        @bundle_bookmarks_count = BundlesBookmark.count
        #puts " count bundle bookmarks "
        #puts @bundle_bookmarks_count
      end
      it "create user must change user bookmarks by many" do
        expect {
          FactoryGirl.create(:user,specific_room_id:@bundle.id)
        }.to change(UsersBookmark, :count).by(@bundle_bookmarks_count)
      end

      it "create user must have some bookmarks from bundle " do

        @bundle_bookmarks = BundlesBookmark.all
        @user_bundle = FactoryGirl.create(:user,specific_room_id:@bundle.id)

        @bundle_bookmarks.each do | bookmark|
          user_bookmark = UsersBookmark.find_by_user_id_and_bookmark_id(@user_bundle.id,bookmark.bookmark_id)
          #puts user_bookmark.bookmark_id
          #puts user_bookmark.position
          user_bookmark.should be_valid
        end
      end
    end

  end













end
