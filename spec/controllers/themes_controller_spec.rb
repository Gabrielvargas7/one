require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ThemesController do

  # This should return the minimal set of attributes required to create a valid
  # Theme. As you add validations to Theme, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ThemesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

   #the (before) line will instance the variable for every (describe methods)

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @theme = FactoryGirl.create(:theme)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @theme }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
        let(:themes_all) { Theme.all }

        it "assigns all themes as @themes" do
          get :index
          assigns(:themes).should eq(themes_all)
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

      it "assigns the requested themes as @themes" do
        get :show, id: @theme
        assigns(:theme).should eq(@theme)

      end

      it "renders the #show view" do

        get :show, id: @theme
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@theme
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@theme
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do

    context "is admin user"  do
        it "assigns a new themes as @themes" do

          new_theme = FactoryGirl.create(:theme)
          Theme.should_receive(:new).and_return(new_theme)
          get :new
          assigns[:theme].should eq(new_theme)
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

        it "assigns the requested themes as @themes" do

          new_theme = FactoryGirl.create(:theme)
          get :edit, id: new_theme
          assigns[:theme].should eq(new_theme)
        end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_theme = FactoryGirl.create(:theme)
        get :edit, id: new_theme
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

      it "creates a new Theme" do

        expect {
          post :create,theme: FactoryGirl.attributes_for(:theme)
        }.to change(Theme, :count).by(1)


      end

      it "assigns a newly created themes as @themes" do
        post :create,theme: FactoryGirl.attributes_for(:theme)
        assigns(:theme).should be_a(Theme)
        assigns(:theme).should be_persisted
      end

      it "redirects to the created themes" do
        post :create, theme: FactoryGirl.attributes_for(:theme)
        response.should redirect_to(Theme.last)
      end
    end

      context "with invalid params" do

      context "with invalid attributes" do
        it "does not save the new contact" do
          expect{ post :create, theme: FactoryGirl.attributes_for(:theme,name:nil)
          }.to_not change(Theme,:count)
        end
        it "re-renders the new method" do
          post :create, theme: FactoryGirl.attributes_for(:theme,name:nil)
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
        post :create, theme: FactoryGirl.attributes_for(:theme)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created themes" do
        post :create, theme: FactoryGirl.attributes_for(:theme)
        response.should_not redirect_to(Theme.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do

    describe "is admin user" do

        context "valid attributes" do
          it "located the requested @theme" do
            put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme)
            assigns(:theme).should eq(@theme)
          end
        end

        it "changes @theme's attributes" do
          put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme, name: "Larry", description: "Smith")
          @theme.reload
          @theme.name.should eq("Larry")
          @theme.description.should eq("Smith")
        end

        it "redirects to the updated theme" do
          put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme)
          response.should redirect_to @theme
        end

        context "invalid attributes" do

          it "locates the requested @theme" do
          put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme,name:nil)
          assigns(:theme).should eq(@theme)
        end
          it "does not change @theme's attributes" do
          put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme, name:"John", description: "Smith")
          @theme.reload
          @theme.name.should_not eq("Larry")
          @theme.description.should_not eq("Smith")
        end
          it "re-renders the edit method" do
          put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme,name:nil)
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
        put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme)
        response.should redirect_to root_path
      end

    end


  end

  #***********************************
  # rspec test  #json_index
  #***********************************


  describe "api #json_index",tag_json_index:true do

    describe "is public api" do
        before do
          sign_out
        end


        it "should be successful" do
          get :json_index, theme: @theme, :format => :json
          response.should be_success
        end
        let(:themes_all){Theme.all}
        it "should set theme" do
          get :json_index, :format => :json
          assigns(:themes).as_json.should == themes_all.as_json
        end

        it "has a 200 status code" do
          get :json_index, theme: @theme, :format => :json
          expect(response.status).to eq(200)
        end

        context "get all values " do
            it "should return json_index theme in json" do # depend on what you return in action
                get :json_index, :format => :json
                body = JSON.parse(response.body)
                #puts "body ---- > "+body.to_s
                #puts "theme ----> "+@theme.as_json.to_s
                #puts "body name ----> " + body[0]["name"].to_s
                #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
                #puts "theme name----> "+@theme.name.to_s
                #puts "theme image name----> "+@theme.image_name.to_s

                body.each do |body_theme|
                  @theme_json = Theme.find(body_theme["id"])
                  body_theme["name"].should == @theme_json.name
                  body_theme["description"].should == @theme_json.description
                  body_theme["id"].should == @theme_json.id
                  body_theme["image_name"]["url"].should == @theme_json.image_name.to_s
                  body_theme["image_name_selection"]["url"].should == @theme_json.image_name_selection.to_s
                end
            end
        end
    end
  end

  #***********************************
  # rspec test  #json_show
  #***********************************


  describe "api #json_show",tag_json_show:true do

    describe "is public api" do
      before do
        sign_out
      end


      it "should be successful" do
        get :json_show, id: @theme, :format => :json
        response.should be_success
      end

      let(:themes_all){Theme.all}
      it "should set theme" do
        get :json_show,id:@theme, :format => :json
        assigns(:theme).as_json.should == @theme.as_json
      end

      it "has a 200 status code" do
        get :json_show, id: @theme, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_show theme in json" do # depend on what you return in action
          get :json_show,id:@theme, :format => :json
          body = JSON.parse(response.body)
          body["name"].should == @theme.name
          body["description"].should == @theme.description
          body["id"].should == @theme.id
          body["image_name"]["url"].should == @theme.image_name.to_s
          body["image_name_selection"]["url"].should == @theme.image_name_selection.to_s


        end
      end
    end
  end





end
