# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#  username        :string(255)
#  image_name      :string(255)
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
  it { @user.should respond_to(:name) }
  it { @user.should respond_to(:email) }
  it { @user.should respond_to(:username)}
  it { @user.should respond_to(:image_name)}
  it { @user.should respond_to(:admin) }

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
  #test validation - name
  ###############
  describe "when the name" , tag_name: true  do

      context "is not present" do
        before {@user.name = " "}
        it {should_not be_valid}

      end

      context "is too long" do
        before { @user.name = "a" * 51 }
        it { should_not be_valid }
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
              print user_with_same_email.email+"  "
              print @user.email
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
        @user_with_same_username = User.new(name: "Example User", email:"user_with_same_username@example.com", password: "foobar")
        @user_with_same_username.name = @user.name.upcase
        @user_with_same_username.save
        @user.save
      end

      it { @user.username.should_not == @user_with_same_username.username  }
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
      puts @user.id
      user_notification.should be_valid
    end

    it "should not be valid " do
      user_notification_not_exist.should be_nil
    end

  end


  ###############
  #test validation - send signup email
  ###############
  describe "#send_signup_user_email", tag_send_signup_user_email:true do
    it "delivers email to user" do
      @user.send_signup_user_email
      last_email.to.should include (@user.email)
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
        last_email.to.should include (@user.email)
      end

   end


  ###############
  #test validation - default image
  ###############
  describe "when image default ", tag_image_default: true  do

    let(:image_default) {"/assets/fallback/user/default_user.png"}

    it "should be default " do
      puts @user.image_name
      @user.image_name.to_s.should == image_default.to_s

    end

  end


  ###############
  #test validation - upload image
  ###############
  # these test only run when it is explicit.- example
  # bundle exec rspec --tag tag_image spec/models/theme_spec.rb
  describe "when image",tag_image_user:true  do

    let(:user_with_image_upload) { Theme.create(
        name:"user test",
        image_name:Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'image', 'test_image.jpg'))
    )}

    it "should be upload to CDN - cloudinary " do
      puts user_with_image_upload.image_name
      user_with_image_upload.image_name.to_s.should include("http")
    end

  end




  ###############
  #test validation - create random room
  ###############
  describe "#random_room",tag_random_room:true do
    pending "add some examples to (or delete) #{__FILE__}"

  end


  ###############
  #test validation - facebook login  def self.from_omniauth(auth)
  ###############
  describe " #omniauth",tag_omniauth:true do
    pending "add some examples to (or delete) #{__FILE__}"
  end


  #def get_username
  ###############
  #test validation - def get_username
  ###############
  describe "#get_username",tag_get_username:true do
    pending "add some examples to (or delete) #{__FILE__}"
  end










end
