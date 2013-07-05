require 'spec_helper'


describe UsersPhotosController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    @admin = FactoryGirl.create(:admin)
    @users_photo = FactoryGirl.create(:users_photo,user_id:@admin.id)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @users_photo }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:users_photos_all) { UsersPhoto.all }

      it "assigns all user photos  as @user photos" do
        get :index
        assigns(:users_photos).should eq(users_photos_all)
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

      it "assigns the requested user photos as @user photos" do
        get :show, id: @users_photo
        assigns(:users_photo).should eq(@users_photo)

      end

      it "renders the #show view" do

        get :show, id: @users_photo
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@users_photo
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@users_photo
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new user photos as @user photos" do

        new_users_photo = FactoryGirl.create(:users_photo,user_id:@admin.id)
        UsersPhoto.should_receive(:new).and_return(new_users_photo)
        get :new
        assigns[:users_photo].should eq(new_users_photo)
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

      it "assigns the requested user photo as @user photo" do

        new_users_photo = FactoryGirl.create(:users_photo,user_id:@admin.id)
        get :edit, id: new_users_photo
        assigns[:users_photo].should eq(new_users_photo)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_users_photo = FactoryGirl.create(:users_photo,user_id:@user.id)
        get :edit, id: new_users_photo
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

        it "creates a new User Photo" do

          expect {
            post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id)
          }.to change(UsersPhoto, :count).by(1)


        end

        it "assigns a newly created user photos as @users photos" do
          post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id)
          assigns(:users_photo).should be_a(UsersPhoto)
          assigns(:users_photo).should be_persisted
        end

        it "redirects to the created user photos" do
          post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id)
          response.should redirect_to(UsersPhoto.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{
              post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:nil)
            }.to_not change(UsersPhoto,:count)
          end
          it "re-renders the new method" do
            post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:nil)
            response.should render_template :new
          end
        end

      end

    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created themes" do
        post :create,users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id)
        response.should_not redirect_to(UsersPhoto.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @user photos" do
          put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id)
          assigns(:users_photo).should eq(@users_photo)
        end
      end

      it "changes @user photos's attributes" do
        put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id, description: "new desc",profile_image:'y')
        @users_photo.reload
        @users_photo.description.should eq("new desc")
        @users_photo.profile_image.should eq("y")
      end

      it "redirects to the updated users photos " do
        put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@admin.id, description: "new desc",profile_image:'y')
        response.should redirect_to @users_photo
      end

      context "invalid attributes" do

        it "locates the requested @user photos" do
          put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:nil, description: "new desc",profile_image:'y')
          assigns(:users_photo).should eq(@users_photo)
        end

        it "does not change @users photo's attributes" do
          put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:nil, description: "new desc",profile_image:'y')
          @users_photo.reload
          @users_photo.description.should_not eq("new desc")
          @users_photo.profile_image.should_not eq("y")
        end
        it "re-renders the edit method" do
          put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:nil, description: "new desc",profile_image:'y')
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
        put :update, id: @users_photo, users_photo: FactoryGirl.attributes_for(:users_photo,user_id:@user.id, description: "new desc",profile_image:'y')
        response.should redirect_to root_path
      end
    end
  end

  ##***********************************
  ## rspec test  #json_create_users_photo_by_user_id
  ##***********************************
  #/users_photos/json/create_users_photos_by_user_id/:user_id
  #/users_photos/json/create_users_photos_by_user_id/206.json
  # Content-Type : multipart/form-data
  # Form Parameters:
  #               :image_name (full path)
  #               :description
  #               :profile_image (y/n)
  #Return ->
  #success    ->  head  201 create
  #json_create_users_photo_by_user_id

  describe "POST json_create_users_photo_by_user_id", tag_json_create:true  do
    before do
      @user  = FactoryGirl.create(:user)
      sign_in @user

    end


    describe "is regular user" do
      context "with valid params" do

        it "creates a new user photo" do
          puts "user id --->"+@user.id.to_s


          expect {
            post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
          }.to change(UsersPhoto, :count).by(1)
        end

        it "assigns a newly created photos request as @photos request" do
          post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
          assigns(:users_photo).should be_a(UsersPhoto)
          assigns(:users_photo).should be_persisted
        end
        #
        it "response should be success" do
          post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
          response.should be_success
        end

        it "has a 201 status code" do
          post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
          expect(response.status).to eq(201)
        end

        context "return json values " do
          it "should return user request in json" do # depend on what you return in action
            post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
            body = JSON.parse(response.body)
            body["user_id"].should == @user.id
            body["description"].should == @users_photo.description
            body["profile_image"].should == @users_photo.profile_image

          end
        end

      end
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      it "has a 404 status code" do
        post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        post :json_create_users_photo_by_user_id,user_id:@user.id,profile_image:@users_photo.profile_image,description:@users_photo.description, :format => :json
        expect(response.status).to eq(404)
      end
    end

  end


  # PUT update set profile image
  #/users_photos/json/update_users_set_profile_image_by_user_id_and_users_photo_id/:user_id/:users_photo_id
  #/users_photos/json/update_users_set_profile_image_by_user_id_and_users_photo_id/30/400.json
  #success    ->  head  200 ok

  #***********************************
  # rspec test  json_update_users_set_profile_image_by_user_id_and_users_photo_id
  #***********************************


  describe "PUT json_update_users_set_profile_image_by_user_id_and_users_photo_id", tag_json_update:true do

    describe "is regular user" do
      before do
        @user  = FactoryGirl.create(:user)
        @users_photo = FactoryGirl.create(:users_photo,user_id:@user.id)
        sign_in @user
      end


      context "valid attributes" do
        it "located the requested @user photos" do
          put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id , :format => :json
          assigns(:users_photo).should eq(@users_photo)
        end
      end

      it "changes @user photos's attributes" do

        @users_photo.profile_image.should eq("n")
        put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id, :format => :json
        @users_photo.reload
        @users_photo.profile_image.should eq("y")
      end


      it "response should be success" do
        put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id , :format => :json
        response.should be_success
      end

      it "has a 200 status code OK" do
        put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id  , :format => :json
        expect(response.status).to eq(200)
      end

      context "return json values " do
        it "should return user request in json" do # depend on what you return in action
          put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id  , :format => :json
          body = JSON.parse(response.body)
          body["user_id"].should == @user.id
          body["description"].should == @users_photo.description
          body["profile_image"].should == 'y'

        end
      end

      context "return json values " do
        it "should count one profile image 'Y' " do
          put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id  , :format => :json
          @user_photo_count  = UsersPhoto.where("profile_image = 'y' and user_id = ?",@user.id).count
          @user_photo_count.should == 1
        end

      end

      context "invalid attributes" do

        it "does not change @users photo's attributes" do
          put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:-1  , :format => :json
          @users_photo.reload
          @users_photo.profile_image.should_not eq("y")
        end
      end
    end

    context "is sign in with other user" do
      before do
        @user1 = FactoryGirl.create(:user)
        sign_in @user1
      end
      it "has a 404 status code" do
        put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id  , :format => :json
        expect(response.status).to eq(404)
      end
    end


    context "is sign out user" do
      before do
        sign_out
      end
      it "has a 404 status code" do
        put :json_update_users_set_profile_image_by_user_id_and_users_photo_id, user_id: @users_photo.user_id,users_photo_id:@users_photo.id  , :format => :json
        expect(response.status).to eq(404)
      end
    end


  end


  #GET Get all users photos

  #GET Get all users photos

  #/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/:user_id/:limit/:offset
  #/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/
  #                     #Return head
  #success    ->  head  200 OK

  #***********************************
  # rspec test  json_index_users_photos_by_user_id_by_limit_by_offset
  #***********************************




  describe "api #json_index_users_photos_by_user_id",tag_json_index:true do

    describe "is public api" do
      before do
        @user  = FactoryGirl.create(:user)
        @users_photo1 = FactoryGirl.create(:users_photo,user_id:@user.id)
        @users_photo2 = FactoryGirl.create(:users_photo,user_id:@user.id)
        @limit = 2
        @offset = 0
        sign_in @user
      end

      it "should be successful" do
        get :json_index_users_photos_by_user_id_by_limit_by_offset, user_id:@user.id,limit:@limit,offset:@offset, :format => :json
        response.should be_success
      end

      let(:users_photos_all){UsersPhoto.where("user_id = ?",@user.id).limit(@limit).offset(@offset)}
      it "should set users photos" do
        get :json_index_users_photos_by_user_id_by_limit_by_offset, user_id:@user.id,limit:@limit,offset:@offset, :format => :json
        assigns(:users_photos).as_json.should == users_photos_all.as_json
      end

      it "has a 200 status code" do
        get :json_index_users_photos_by_user_id_by_limit_by_offset, user_id:@user.id,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index theme in json" do # depend on what you return in action
          get :json_index_users_photos_by_user_id_by_limit_by_offset, user_id:@user.id,limit:@limit,offset:@offset, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body name ----> " + body[0]["name"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "theme name----> "+@theme.name.to_s
          #puts "theme image name----> "+@theme.image_name.to_s

          body.each do |body_users_photo|
            @users_photo_json = UsersPhoto.find(body_users_photo["id"])
            body_users_photo["profile_image"].should == @users_photo_json.profile_image
            body_users_photo["description"].should == @users_photo_json.description
            body_users_photo["id"].should == @users_photo_json.id
            body_users_photo["image_name"]["url"].should == @users_photo_json.image_name.to_s
          end
        end
      end
    end
  end

  ##***********************************
  ## rspec test  #json_show
  ##***********************************
  #
  #
  #describe "api #json_show",tag_json_show:true do
  #
  #  describe "is public api" do
  #    before do
  #      sign_out
  #    end
  #
  #
  #    it "should be successful" do
  #      get :json_show, id: @theme, :format => :json
  #      response.should be_success
  #    end
  #
  #    let(:themes_all){Theme.all}
  #    it "should set theme" do
  #      get :json_show,id:@theme, :format => :json
  #      assigns(:theme).as_json.should == @theme.as_json
  #    end
  #
  #    it "has a 200 status code" do
  #      get :json_show, id: @theme, :format => :json
  #      expect(response.status).to eq(200)
  #    end
  #
  #    context "get all values " do
  #      it "should return json_show theme in json" do # depend on what you return in action
  #        get :json_show,id:@theme, :format => :json
  #        body = JSON.parse(response.body)
  #        body["name"].should == @theme.name
  #        body["description"].should == @theme.description
  #        body["id"].should == @theme.id
  #        body["image_name"]["url"].should == @theme.image_name.to_s
  #        body["image_name_selection"]["url"].should == @theme.image_name_selection.to_s
  #
  #
  #      end
  #    end
  #  end
  #end
  #
  #
  #


end
