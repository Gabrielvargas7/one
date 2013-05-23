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

  before { @user = User.new(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar")

  }

  subject { @user }

  it { @user.should respond_to(:name) }
  it { @user.should respond_to(:email) }
  xit { @user.should respond_to(:password_digest)}
  xit { should respond_to(:password) }
  xit { should respond_to(:password_confirmation) }
  xit { should respond_to(:authenticate) }

  xit { @user.should be_valid }

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    xit { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    xit { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    xit { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      xit { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      xit { should_not == user_for_invalid_password }


      xspecify {
      user_for_invalid_password.should be_false
      }

    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    xit { should be_invalid }
  end

  describe "when the name is not present" do
    before {@user.name = " "}
    xit {should_not be_valid}

  end

  describe "when email is not present" do
    before { @user.email = " " }
    xit { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    xit { should_not be_valid }
  end

  describe "when email format is invalid" do
    xit "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    xit "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save

    end

    xit { should_not be_valid }
  end

  xit { should respond_to(:password_confirmation) }
  xit { should respond_to(:remember_token) }
  xit { should respond_to(:authenticate) }

  #describe "remember token" do
  #  before{@user.save}
  #  its(:remember_token){should_not be_blank}
  #end



  xit { should respond_to(:admin) }
  xit { should respond_to(:authenticate) }

  xit { should be_valid }
  xit { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    xit { should be_admin }
  end


end
