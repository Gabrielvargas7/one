require 'spec_helper'

describe UsersThemesController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @user = FactoryGirl.create(:user)
    @section = FactoryGirl.create(:section)
    @theme = FactoryGirl.create(:theme)
    @theme2 = FactoryGirl.create(:theme)
    @user_theme = FactoryGirl.create(:users_theme,user_id:@user.id,theme_id:@theme.id,section_id:@section.id)
    sign_in @user
  end


  subject { @user_theme }



  # GET get theme by user id
  # users_themes/json/show_user_theme_by_user_id_and_section_id/:user_id/:section_id'
  # users_themes/json/show_user_theme_by_user_id_and_section_id/1/1.json
  #Return ->
  #success    ->  head  200 OK
  #def json_show_user_theme_by_user_id_and_section_id


    #***********************************
  # rspec test  #json_show_user_theme_by_user_id_and_section_id
  #***********************************


  describe "api #json_show_user_theme_by_user_id_and_section_id",tag_json_show:true do

    describe "is regular user" do

      before  do

      end

      it "should be successful" do
        get :json_show_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id, :format => :json
        response.should be_success
      end


      it "should set user notification" do
        get :json_show_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id, :format => :json
        assigns(:theme).as_json.should == @theme.as_json
      end

      it "has a 200 status code" do
        get :json_show_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get a values " do

        it "should return json_show user theme in json" do


          get :json_show_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id, :format => :json
          body = JSON.parse(response.body)
          body["name"].should == @theme.name
          body["description"].should == @theme.description
          body["id"].should == @theme.id
          body["image_name"]["url"].should == @theme.image_name.to_s
          body["category"].should == @theme.category
          body["style"].should == @theme.style
          body["brand"].should == @theme.brand
          body["location"].should == @theme.location
          body["color"].should == @theme.color
          body["make"].should == @theme.make
          body["special_name"].should == @theme.special_name
          body["like"].should == @theme.like


        end
      end
    end



    describe "is sign out user" do

      before  do
        sign_out
      end

      it "has a 404 status code" do
        get :json_show_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id, :format => :json
        expect(response.status).to eq(404)
      end
    end

  end


  # PUT change the user's theme by user id
  #  users_themes/json/update_user_theme_by_user_id_and_section_id/:user_id/:section_id'
  #  users_themes/json/update_user_theme_by_user_id_and_section_id/1/1.json
  #  Form Parameters:
  #                  new_theme_id = 1
  # Return ->
  # Success    ->  head  200 ok


    #***********************************
  # rspec test json_update_user_theme_by_user_id_and_section_id
  #***********************************


  describe "PUT json_update_user_themes", tag_json_update:true do

    describe "is regular user" do
      before  do

      end

      context "valid attributes" do
        it "located the requested @user themes" do
          put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
          assigns(:user_theme).should eq(@user_theme)
        end
      end

      it "changes @user notification's attributes" do

        @user_theme.theme_id.should eq(@theme.id)
        put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
        @user_theme.reload
        @user_theme.theme_id.should eq(@theme2.id)
      end


      it "response should be success" do
        put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
        response.should be_success
      end

      it "has a 200 status code OK" do
        put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "return json values " do
        it "should return user request in json" do # depend on what you return in action
          put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
          @user_theme.reload
          body = JSON.parse(response.body)
          body["user_id"].should == @user_theme.user_id
          body["section_id"].should == @user_theme.section_id
          body["theme_id"].should == @theme2.id
          body["id"].should == @user_theme.id


        end
      end

      context "return json values " do
        it "should count one user notification 'y' " do
          put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
          @user_theme_count  = UsersTheme.where("section_id = ? and user_id = ?",@section.id,@user.id).count
          @user_theme_count.should == 1
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
          put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
          expect(response.status).to eq(404)
        end
      end


      context "is sign out user" do
        before do
          sign_out
        end
        it "has a 404 status code" do
          put :json_update_user_theme_by_user_id_and_section_id, user_id: @user_theme.user_id,section_id:@user_theme.section_id,new_theme_id:@theme2.id, :format => :json
          expect(response.status).to eq(404)
        end
      end


    end

  end



end
