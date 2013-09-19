require 'spec_helper'


describe ThemesController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @theme = FactoryGirl.create(:theme)
    @theme2 = FactoryGirl.create(:theme)
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
          @theme = FactoryGirl.create(:theme,name:"Larry",description:"Smith")
          put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme, name:nil, description: "lopez")
          @theme.reload
          @theme.name.should_not eq(nil)
          @theme.description.should_not eq("lopez")
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
  # rspec test  #json_index_themes
  #***********************************


  describe "api #json_index_themes",tag_json_index:true do

    describe "is public api" do
        before do
          sign_out
        end


        it "should be successful" do
          get :json_index_themes, theme: @theme, :format => :json
          response.should be_success
        end
        let(:themes_all){Theme.all}
        it "should set theme" do
          get :json_index_themes, :format => :json
          assigns(:themes).as_json.should == themes_all.as_json
        end

        it "has a 200 status code" do
          get :json_index_themes, theme: @theme, :format => :json
          expect(response.status).to eq(200)
        end

        context "get all values " do
            it "should return json_index theme in json" do # depend on what you return in action
                get :json_index_themes, :format => :json
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
                  body_theme["category"].should == @theme_json.category
                  body_theme["style"].should == @theme_json.style
                  body_theme["brand"].should == @theme_json.brand
                  body_theme["location"].should == @theme_json.location
                  body_theme["color"].should == @theme_json.color
                  body_theme["make"].should == @theme_json.make
                  body_theme["special_name"].should == @theme_json.special_name
                  body_theme["like"].should == @theme_json.like


                end
            end
        end
    end
  end

  #***********************************
  # rspec test  #json_show_theme_by_theme_id
  #***********************************

  describe "api #json_show_theme_by_theme_id",tag_json_show:true do

    describe "is public api" do
      before do
        sign_out
      end

      it "should be successful" do
        get :json_show_theme_by_theme_id, theme_id: @theme.id, :format => :json
        response.should be_success
      end

      let(:themes_all){Theme.all}
      it "should set theme" do
        get :json_show_theme_by_theme_id,theme_id:@theme.id, :format => :json
        assigns(:theme).as_json.should == @theme.as_json
      end

      it "has a 200 status code" do
        get :json_show_theme_by_theme_id, theme_id: @theme.id, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_show theme in json" do # depend on what you return in action
          get :json_show_theme_by_theme_id,theme_id:@theme.id, :format => :json
          body = JSON.parse(response.body)
          #puts body.as_json
          #puts body["category"]
          #puts @the

          body["name"].should == @theme.name
          body["description"].should == @theme.description
          body["id"].should == @theme.id
          body["image_name"]["url"].should == @theme.image_name.to_s
          body["image_name_selection"]["url"].should == @theme.image_name_selection.to_s

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
  end


  #***********************************
  # rspec test  #json_index_themes_categories
  #***********************************

  describe "api #json_index_themes_categories",tag_json_category:true do


    describe "is public api" do
      before do
        sign_out
        FactoryGirl.create(:theme,category:"furniture",style:"modern",brand:"nike",color:"green",make:"wood",location:"los angeles")
        FactoryGirl.create(:theme,category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")
      end

      it "should be successful" do
        get :json_index_themes_categories, :format => :json
        response.should be_success
      end

      it "has a 200 status code" do
        get :json_index_themes_categories, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do

        it "should return json_index_themes_categories" do # depend on what you return in action
          get :json_index_themes_categories, :format => :json
          body = JSON.parse(response.body)
          #puts body.as_json
          puts body["category"]
          #puts @the

          body["themes_categories"].each do |body_theme|
            @theme_json = Theme.find_all_by_category(body_theme["category"]).first()
            body_theme["category"].should == @theme_json.category
            #puts body_theme["category"]
          end

          body["themes_brands"].each do |body_theme|
            @theme_json = Theme.find_all_by_brand(body_theme["brand"]).first()
            body_theme["brand"].should == @theme_json.brand
            #puts body_theme["brand"]
          end

          body["themes_styles"].each do |body_theme|
            @theme_json = Theme.find_all_by_style(body_theme["style"]).first()
            body_theme["style"].should == @theme_json.style
            #puts body_theme["style"]
          end

          body["themes_colors"].each do |body_theme|
            @theme_json = Theme.find_all_by_color(body_theme["color"]).first()
            body_theme["color"].should == @theme_json.color
            #puts body_theme["color"]
          end

          body["themes_makes"].each do |body_theme|
            @theme_json = Theme.find_all_by_make(body_theme["make"]).first()
            body_theme["make"].should == @theme_json.make
            #puts body_theme["make"]
          end

          body["themes_locations"].each do |body_theme|
            @theme_json = Theme.find_all_by_location(body_theme["location"]).first()
            body_theme["location"].should == @theme_json.location
            #puts body_theme["location"]
          end


        end
      end
    end
  end


#***********************************
# rspec test  #json_index_themes_filter_by_category_by_keyword_and_limit_and_offset
#***********************************


  describe "api #json_index_themes_filter_by_category_by_keyword_and_limit_and_offset",tag_json_index:true do

    describe "is public api" do
      before do
        sign_out
        @category = "category"
        @keyword = "electronics"
        @limit = 4
        @offset = 0

        FactoryGirl.create(:theme,category:"furniture",style:"modern",brand:"nike",color:"green",make:"wood",location:"los angeles")
        FactoryGirl.create(:theme,category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")
        FactoryGirl.create(:theme,category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")
        FactoryGirl.create(:theme,category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")

      end


      it "should be successful" do
        get :json_index_themes_filter_by_category_by_keyword_and_limit_and_offset, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        response.should be_success
      end


      it "has a 200 status code" do
        get :json_index_themes_filter_by_category_by_keyword_and_limit_and_offset, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index theme in json" do # depend on what you return in action
          get :json_index_themes_filter_by_category_by_keyword_and_limit_and_offset, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
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
            body_theme["category"].should == @theme_json.category
            body_theme["style"].should == @theme_json.style
            body_theme["brand"].should == @theme_json.brand
            body_theme["location"].should == @theme_json.location
            body_theme["color"].should == @theme_json.color
            body_theme["make"].should == @theme_json.make
            body_theme["special_name"].should == @theme_json.special_name
            body_theme["like"].should == @theme_json.like


          end
        end
      end
    end
  end




  #***********************************
  # rspec test  destroy
  #***********************************


  #describe 'DELETE destroy' do
  #
  #  it "deletes the contact" do
  #    expect{
  #      delete :destroy, id: @bundles_items_design
  #    }.to change(BundlesItemsDesign,:count).by(-1)
  #  end
  #  it "redirects to contacts#index" do
  #    delete :destroy, id:  @bundles_items_design
  #    response.should redirect_to bundles_items_designs_url
  #  end
  #end






end
