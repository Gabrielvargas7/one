require 'spec_helper'


describe BundlesItemsDesignsController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    #@section = FactoryGirl.create(:section)
    #@theme = FactoryGirl.create(:theme)
    #@bundle = FactoryGirl.build(:bundle,theme_id:@theme.id,section_id:@section.id)

    #
    #@section = FactoryGirl.create(:section)
    #@location = FactoryGirl.create(:location,section_id:@section.id )
    #@item = FactoryGirl.create(:item)
    #@items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
    #@items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
    #@bundles_items_design = FactoryGirl.create(:bundles_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id)

    @bundles_items_design = BundlesItemsDesign.first
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @bundles_items_design }



  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:bundles_items_design_all) { BundlesItemsDesign.order('bundle_id,items_designs.item_id ').
              joins('LEFT OUTER JOIN items_designs ON items_designs.id = bundles_items_designs.items_design_id')
      }

      it "assigns all bundle_items_designs as @bundle_items_designs" do
        get :index
        assigns(:bundles_items_designs).should eq(bundles_items_design_all)
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

      it "assigns the requested themes as @bundle_item_design" do
        get :show, id: @bundles_items_design
        assigns(:bundles_items_design).should eq(@bundles_items_design)

      end

      it "renders the #show view" do

        get :show, id: @bundles_items_design
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@bundles_items_design
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@bundles_items_design
        response.should_not render_template :show
      end

    end
  end

  #***********************************
  # rspec test  destroy
  #***********************************


  describe 'DELETE destroy' do

    it "deletes the contact" do
      expect{
        delete :destroy, id: @bundles_items_design
      }.to change(BundlesItemsDesign,:count).by(-1)
    end
    it "redirects to contacts#index" do
      delete :destroy, id:  @bundles_items_design
      response.should redirect_to bundles_items_designs_url
    end
  end

  #***********************************
  # rspec test  index_bundle_selection
  #***********************************

  describe "GET index_bundle_selection",tag_index:true do

    context "is admin user" do

      let(:bundles_all) { Bundle.order(:id).all}

      it "assigns all bundle_items_designs as @bundles_items_designs" do
        get :index_bundle_selection
        assigns(:bundles).should eq(bundles_all)
      end

      it "renders the :index_bundle_selection view" do
        get :index_bundle_selection
        response.should render_template :index_bundle_selection
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :index_bundle_selection
        response.should redirect_to root_path
      end

      it "not render to index_bundle_selection " do
        get :index_bundle_selection
        response.should_not render_template :index_bundle_selection
      end
    end
  end


  #***********************************
  # rspec test  index_items_location_selection
  #***********************************



  describe "GET index_items_location_selection",tag_index_location:true do

    context "is admin user" do
      before do
        @new_section = FactoryGirl.create(:section)
        @new_theme = FactoryGirl.create(:theme)
        @new_bundle = FactoryGirl.create(:bundle,theme_id:@new_theme.id,section_id:@new_section.id)

        @new_location = FactoryGirl.create(:location,section_id:@new_section.id)
        @new_item = FactoryGirl.create(:item)
        FactoryGirl.create(:items_location,location_id:@new_location.id,item_id:@new_item.id)
      end



      it "assigns all bundle_items_designs as @bundles_items_designs" do

        new_items_locations_values = ItemsLocation.order(:section_id).where("locations.section_id = ?",@new_location.section_id).joins(:location)

        get :index_items_location_selection, bundle_id:@new_bundle,section_id:@new_location.section_id

        #assigns(:items_locations).should eq(new_items_locations_values)
        assigns(:bundle).should eq(@new_bundle)
        assigns(:items_locations) == new_items_locations_values

      end

      it "renders the :index_bundle_selection view" do

        get :index_items_location_selection, bundle_id:@new_bundle,section_id:@new_location.section_id

        response.should render_template :index_items_location_selection
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

        @new_section = FactoryGirl.create(:section)
        @new_theme = FactoryGirl.create(:theme)
        @new_bundle = FactoryGirl.create(:bundle,theme_id:@new_theme.id,section_id:@new_section.id)

        @new_location = FactoryGirl.create(:location,section_id:@new_section.id)
        @new_item = FactoryGirl.create(:item)
        FactoryGirl.create(:items_location,location_id:@new_location.id,item_id:@new_item.id)


      end

      it "redirect to root " do

        get :index_items_location_selection, bundle_id:@new_bundle,section_id:@new_location.section_id
        response.should redirect_to root_path
      end

      it "not render to index_bundle_selection " do

        get :index_items_location_selection, bundle_id:@new_bundle,section_id:@new_location.section_id

        response.should_not render_template :index_items_location_selection
      end
    end

  end



  #***********************************
  # rspec test  index_items_design_selection
  #***********************************

  ## GET /index/items_location_selection/:bundle_id/:location_id/:item_id


  describe "GET index_items_design_selection",tag_index_design_selection:true do

    context "is admin user" do
      before do
        @new_section = FactoryGirl.create(:section)
        @new_theme = FactoryGirl.create(:theme)
        @new_bundle = FactoryGirl.create(:bundle,theme_id:@new_theme.id,section_id:@new_section.id)

        @new_location = FactoryGirl.create(:location,section_id:@new_section.id)
        @new_item = FactoryGirl.create(:item)
        @new_items_designs = FactoryGirl.create(:items_design,item_id:@new_item.id)
        FactoryGirl.create(:items_location,location_id:@new_location.id,item_id:@new_item.id)
      end


      it "assigns all items_designs as @items_designs" do


        get :index_items_design_selection, bundle_id:@new_bundle.id,location_id:@new_location.id,item_id:@new_item.id

        #assigns(:items_locations).should eq(new_items_locations_values)
        assigns(:bundle).should eq(@new_bundle)
        assigns(:location).should eq(@new_location)
        assigns(:items_designs) == @new_items_designs

      end

      it "renders the :index_bundle_selection view" do

        get :index_items_design_selection, bundle_id:@new_bundle.id,location_id:@new_location.id,item_id:@new_item.id


        response.should render_template :index_items_design_selection
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

        @new_section = FactoryGirl.create(:section)
        @new_theme = FactoryGirl.create(:theme)
        @new_bundle = FactoryGirl.create(:bundle,theme_id:@new_theme.id,section_id:@new_section.id)

        @new_location = FactoryGirl.create(:location,section_id:@new_section.id)
        @new_item = FactoryGirl.create(:item)
        @new_items_designs = FactoryGirl.create(:items_design,item_id:@new_item.id)
        FactoryGirl.create(:items_location,location_id:@new_location.id,item_id:@new_item.id)

      end

      it "redirect to root " do

        get :index_items_design_selection, bundle_id:@new_bundle.id,location_id:@new_location.id,item_id:@new_item.id
        response.should redirect_to root_path
      end

      it "not render to index_bundle_selection " do
        get :index_items_design_selection, bundle_id:@new_bundle.id,location_id:@new_location.id,item_id:@new_item.id
        response.should_not render_template :index_items_design_selection
      end
    end

  end

  #***********************************
  # rspec test  create_bundle_items_design
  #***********************************

  # POST /create_bundle_items_design/:bundle_id/:location_id/:items_design_id
  #@bundles_items_design = BundlesItemsDesign.new(bundle_id:params[:bundle_id],location_id:params[:location_id],items_design_id:params[:items_design_d])


  #***********************************
  # rspec test create_bundle_items_design
  #***********************************


  describe "POST create_bundle_items_design", tag_create:true  do



    describe "is admin user" do
      before do
        @section = FactoryGirl.create(:section)
        @theme = FactoryGirl.create(:theme)
        @bundle = FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id)

        @location = FactoryGirl.create(:location,section_id:@section.id )
        @item = FactoryGirl.create(:item)
        @items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
        @items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
      end
      context "with valid params" do

        it "creates a new bundle item design" do

          # POST /create_bundle_items_design/:bundle_id/:location_id/:items_design_id
          puts "bundle id --> "+@bundle.id.to_s
          puts "items_location id --> "+@items_location.location_id.to_s
          puts "items_design id --> "+@items_designs.id.to_s

          expect {
            post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id
          }.to change(BundlesItemsDesign, :count).by(1)


        end

        it "assigns a newly created bundles items design as @bundles_items_design" do
          post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id
          assigns(:bundles_items_design).should be_a(BundlesItemsDesign)
          assigns(:bundles_items_design).should be_persisted
        end

        it "redirects to the created themes" do
          post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:@items_designs.id
          response.should redirect_to(BundlesItemsDesign.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create_bundle_items_design,bundle_id:nil,location_id:@items_location.location_id,items_design_id:@items_designs.id
            }.to_not change(BundlesItemsDesign,:count)
            expect{ post :create_bundle_items_design,bundle_id:@bundle.id,location_id:nil,items_design_id:@items_designs.id
            }.to_not change(BundlesItemsDesign,:count)
            expect{ post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:nil
            }.to_not change(BundlesItemsDesign,:count)

          end
          it "re-renders the new method" do
            post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:nil
            response.should redirect_to :bundles_items_designs
          end
        end

      end

    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

        @section = FactoryGirl.create(:section)
        @theme = FactoryGirl.create(:theme)
        @bundle = FactoryGirl.create(:bundle,theme_id:@theme.id,section_id:@section.id)

        @location = FactoryGirl.create(:location,section_id:@section.id )
        @item = FactoryGirl.create(:item)
        @items_location = FactoryGirl.create(:items_location,location_id:@location.id,item_id:@item.id)
        @items_designs = FactoryGirl.create(:items_design,item_id:@item.id)
      end


      it "redirects to root" do
        post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:nil
        response.should redirect_to(root_path)
      end
      it "not redirects to the created bundle item design" do
        post :create_bundle_items_design,bundle_id:@bundle.id,location_id:@items_location.location_id,items_design_id:nil
        response.should_not redirect_to(BundlesItemsDesign.last)
      end
    end


  end






end
