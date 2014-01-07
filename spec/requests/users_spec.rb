require 'spec_helper'

describe "User pages" do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  subject { page }

  describe "Authentications", tag_auth:true do
    before do
      get '/auth/facebook'
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end
    context "without signing into app" do

      it "twitter sign in button should lead to facebookt authentication page" do
        visit root_path
        click_on "login_lightbox_facebook_btn"
        request.env["omniauth.auth"][:uid].should == '12345'
      end

    end
  end


  describe "update password",  tag_update_password:true do
    pending "add some examples to (or delete) #{__FILE__}"
  end


end