require 'spec_helper'


describe BundlesController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do

    #@section = FactoryGirl.create(:section)
    #@theme = FactoryGirl.create(:theme)
    #@bundle = FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id)
    #
    #
    #@location = FactoryGirl.create(:location,section_id:@section.id )
    #@item = FactoryGirl.create(:item)
    #@items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
    #@items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
    #@bundle_items_design = FactoryGirl.build(:bundles_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id)
    #
    #@bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    #@bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
    #@bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)

    @bundle = Bundle.first
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "bundle id "+@bundle.id.to_s

  end


  #the (subject)line declare the variable that is use in all the test
  subject { @bundle }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:bundle_all) { Bundle.all }

      it "assigns all bundle as @bundle" do
        get :index
        assigns(:bundles).should eq(bundle_all)
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

  ##***********************************
  ## rspec test  show
  ##***********************************
  #
  describe "GET show", tag_show:true do

    context "is admin user" do

      it "assigns the requested bundle as @bundle" do
        get :show, id: @bundle
        assigns(:bundle).should eq(@bundle)
      end

      it "renders the #show view" do
        get :show, id: @bundle
        response.should render_template :show
      end

    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@bundle
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@bundle
        response.should_not render_template :show
      end

    end

  end

  ##***********************************
  ## rspec test  new
  ##***********************************

  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new bundle as @bundle" do


        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        new_bundle = FactoryGirl.create(:bundle,theme_id:new_theme.id,section_id:new_section.id)

        Bundle.should_receive(:new).and_return(new_bundle)
        get :new
        assigns[:bundle].should eq(new_bundle)
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

  ##***********************************
  ## rspec test  edit
  ##***********************************


  describe "GET edit", tag_edit:true do

    context "is admin user"  do

      it "assigns the requested bundle as @bundle" do
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        new_bundle = FactoryGirl.create(:bundle,theme_id:new_theme.id,section_id:new_section.id)

        get :edit, id: new_bundle
        assigns[:bundle].should eq(new_bundle)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        new_bundle = FactoryGirl.create(:bundle,theme_id:new_theme.id,section_id:new_section.id)

        get :edit, id: new_bundle
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

        it "creates a new bundle" do
          new_section = FactoryGirl.create(:section)
          new_theme = FactoryGirl.create(:theme)
          expect {
            post :create,bundle: FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
          }.to change(Bundle, :count).by(1)


        end

        it "assigns a newly created bundle as @bundle" do
          new_section = FactoryGirl.create(:section)
          new_theme = FactoryGirl.create(:theme)
          post :create,bundle: FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
          assigns(:bundle).should be_a(Bundle)
          assigns(:bundle).should be_persisted
        end

        it "redirects to the created bundle" do
          new_section = FactoryGirl.create(:section)
          new_theme = FactoryGirl.create(:theme)
          post :create,bundle: FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
          response.should redirect_to(Bundle.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            new_section = FactoryGirl.create(:section)
            new_theme = FactoryGirl.create(:theme)

            expect{ post :create, bundle: FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:nil)
            }.to_not change(Bundle,:count)
            expect{ post :create, bundle: FactoryGirl.attributes_for(:bundle,theme_id:nil,section_id:new_section.id)
            }.to_not change(Bundle,:count)

          end
          it "re-renders the new method" do
            new_section = FactoryGirl.create(:section)
            post :create, bundle: FactoryGirl.attributes_for(:bundle,theme_id:nil,section_id:new_section.id)
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
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)

        post :create, bundle: FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created bundle" do
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        post :create, bundle: FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
        response.should_not redirect_to(Bundle.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************

  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @bundle" do
          new_section = FactoryGirl.create(:section)
          new_theme = FactoryGirl.create(:theme)

          put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
          assigns(:bundle).should eq(@bundle)
        end
      end

      it "changes @bundle's attributes" do
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
        @bundle.reload
        @bundle.theme_id.should eq(new_theme.id)
        @bundle.section_id.should eq(new_section.id)

      end

      it "redirects to the updated section" do
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
        response.should redirect_to @bundle
      end

      context "invalid attributes" do

        it "locates the requested @bundle" do
          new_section = FactoryGirl.create(:section)
          new_theme = FactoryGirl.create(:theme)
          put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
          assigns(:bundle).should eq(@bundle)
        end

        it "does not change @bundle's attributes" do
          new_section = FactoryGirl.create(:section)
          new_theme = FactoryGirl.create(:theme)
          put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:nil)
          @bundle.reload
          @bundle.theme_id.should_not eq(new_theme.id)
          @bundle.section_id.should_not eq(new_section.id)



        end
        it "re-renders the edit method" do

          new_theme = FactoryGirl.create(:theme)
          put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:nil)
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
        new_section = FactoryGirl.create(:section)
        new_theme = FactoryGirl.create(:theme)
        put :update, id: @bundle, bundle:  FactoryGirl.attributes_for(:bundle,theme_id:new_theme.id,section_id:new_section.id)
        response.should redirect_to root_path
      end

    end
  end


  #***********************************
  # rspec test active_update
  #***********************************

  describe "PUT active_update", tag_active_update:true do
    before do

      @section = FactoryGirl.create(:section)
      @theme = FactoryGirl.create(:theme)
      @bundle = FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'n')

      @location = FactoryGirl.create(:location,section_id:@section.id )
      @item = FactoryGirl.create(:item)
      @items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
      @items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
      @bundle_items_design = FactoryGirl.create(:bundles_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id)

    end

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @bundle" do

          put :active_update, id: @bundle.id
          assigns(:bundle).should eq(@bundle)
        end
      end

      it "changes @bundle's attributes" do
        put :active_update, id: @bundle.id
        @bundle.reload
        @bundle.active.should eq('y')

      end

      it "redirects to the updated section" do

        put :active_update, id: @bundle.id
        response.should redirect_to @bundle
      end

      context "invalid attributes" do
        before do
          @invalid_bundle = FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'n')
        end

        it "locates the requested @invalid_bundle" do
          put :active_update, id: @invalid_bundle.id
          assigns(:bundle).should eq(@invalid_bundle)
        end

        it "does not change @bundle's attributes" do
          put :active_update, id: @invalid_bundle.id
          @invalid_bundle.reload
          @invalid_bundle.active.should eq('n')

        end

      end
    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :active_update, id: @bundle.id
        response.should redirect_to root_path
      end

    end
  end



  #***********************************
  # rspec test  #json_index_bundles
  #***********************************


  describe "api #json_index_bundles",tag_json_index:true do

    describe "is public api" do
      before do
        sign_out
      end


      it "should be successful" do
        #get :json_index_bundles, theme: @theme, :format => :json

        get :json_index_bundles, :format => :json
        response.should be_success
      end

      let(:bundles_all){Bundle.all}
      it "should set bundle" do
        get :json_index_bundles, :format => :json
        assigns(:bundles).as_json.should == bundles_all.as_json
      end

      it "has a 200 status code" do
        get :json_index_bundles, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index bundle in json" do # depend on what you return in action

          get :json_index_bundles, :format => :json

          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body name ----> " + body[0]["name"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "theme name----> "+@theme.name.to_s
          #puts "theme image name----> "+@theme.image_name.to_s

          #:description, :image_name, :name, :theme_id,:image_name_set,:section_id

          body.each do |body_bundle|
            @bundle_json = Bundle.find(body_bundle["id"])
            body_bundle["name"].should == @bundle_json.name
            body_bundle["description"].should == @bundle_json.description
            body_bundle["id"].should == @bundle_json.id
            body_bundle["image_name"]["url"].should == @bundle_json.image_name.to_s
            body_bundle["image_name_set"]["url"].should == @bundle_json.image_name_set.to_s
            body_bundle["section_id"].should == @bundle_json.section_id
            body_bundle["active"].should == 'y'
            body_bundle["category"].should == @bundle_json.category
            body_bundle["style"].should == @bundle_json.style
            body_bundle["brand"].should == @bundle_json.brand
            body_bundle["location"].should == @bundle_json.location
            body_bundle["color"].should == @bundle_json.color
            body_bundle["make"].should == @bundle_json.make
            body_bundle["special_name"].should == @bundle_json.special_name
            body_bundle["like"].should == @bundle_json.like

          end
        end
      end
    end
  end


  #***********************************
  # rspec test  #json_index_bunles_categories
  #***********************************

  describe "api #json_index_bundles_categories",tag_json_category:true do


    describe "is public api" do
      before do
        sign_out
        @section = Section.first()
        @theme =  Theme.first()
        FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'y',
                           category:"furniture",style:"modern",brand:"nike",color:"green",make:"wood",location:"los angeles")
        FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'y',
                           category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")
      end

      it "should be successful" do
        get :json_index_bundles_categories, :format => :json
        response.should be_success
      end

      it "has a 200 status code" do
        get :json_index_bundles_categories, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do

        it "should return json_index_bundles_categories" do # depend on what you return in action
          get :json_index_bundles_categories, :format => :json
          body = JSON.parse(response.body)
          #puts body.as_json
          #puts body["category"]
          #puts @the

          body["bundles_categories"].each do |body_b|
            @bundle_json = Bundle.find_all_by_category(body_b["category"]).first()
            body_b["category"].should == @bundle_json.category
            #puts body_theme["category"]
          end

          body["bundles_brands"].each do |body_b|
            @bundle_json = Bundle.find_all_by_brand(body_b["brand"]).first()
            body_b["brand"].should == @bundle_json.brand
            #puts body_theme["brand"]
          end

          body["bundles_styles"].each do |body_b|
            @bundle_json = Bundle.find_all_by_style(body_b["style"]).first()
            body_b["style"].should == @bundle_json.style
            #puts body_theme["style"]
          end

          body["bundles_colors"].each do |body_b|
            @bundle_json = Bundle.find_all_by_color(body_b["color"]).first()
            body_b["color"].should == @bundle_json.color
            #puts body_theme["color"]
          end

          body["bundles_makes"].each do |body_b|
            @bundle_json = Bundle.find_all_by_make(body_b["make"]).first()
            body_b["make"].should == @bundle_json.make
            #puts body_theme["make"]
          end

          body["bundles_locations"].each do |body_b|
            @bundle_json = Bundle.find_all_by_location(body_b["location"]).first()
            body_b["location"].should == @bundle_json.location
            #puts body_theme["location"]
          end


        end
      end
    end
  end


#***********************************
# rspec test  #json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset
#***********************************


  describe "api #json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset",tag_json_index:true do

    describe "is public api" do
      before do
        sign_out
        @category = "category"
        @keyword = "electronics"
        @limit = 4
        @offset = 0

        @section = Section.first()
        @theme =  Theme.first()
        FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'y',
                           category:"furniture",style:"modern",brand:"nike",color:"green",make:"wood",location:"los angeles")

        FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'y',
                           category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")

        FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id,active:'y',
                           category:"electronics",style:"easter",brand:"prada",color:"red",make:"leather",location:"london")


      end


      it "should be successful" do
        get :json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        response.should be_success
      end


      it "has a 200 status code" do
        get :json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
        expect(response.status).to eq(200)
      end

      context "get all values " do
        it "should return json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset" do # depend on what you return in action
          get :json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset, category:@category,keyword:@keyword,limit:@limit,offset:@offset, :format => :json
          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body name ----> " + body[0]["name"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "theme name----> "+@theme.name.to_s
          #puts "theme image name----> "+@theme.image_name.to_s

          body.each do |body_b|
            @b_json = Bundle.find(body_b["id"])
            body_b["name"].should == @b_json.name
            body_b["description"].should == @b_json.description
            body_b["id"].should == @b_json.id
            body_b["image_name"]["url"].should == @b_json.image_name.to_s
            body_b["image_name_set"]["url"].should == @b_json.image_name_set.to_s
            body_b["category"].should == @b_json.category
            body_b["style"].should == @b_json.style
            body_b["brand"].should == @b_json.brand
            body_b["location"].should == @b_json.location
            body_b["color"].should == @b_json.color
            body_b["make"].should == @b_json.make
            body_b["special_name"].should == @b_json.special_name
            body_b["like"].should == @b_json.like


          end
        end
      end
    end
  end

  describe "api #json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset",tag_json_category:true do
    pending "pending test api"
  end

  describe "api #json_index_bundles_categories",tag_json_category:true do
    pending "pending test api"
  end


  describe "api #json_show_bundles_seo_url_by_bundles_id",tag_json_category:true do
    pending "pending test api"
  end

  describe "api #json_show_entire_room_seo_url_by_entire_room_id",tag_json_category:true do
    pending "pending test api"
  end


  describe "destroy bundle" do
    pending "add test destroy bundle #{__FILE__}"
  end







end
