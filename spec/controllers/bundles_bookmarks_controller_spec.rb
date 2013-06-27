require 'spec_helper'


describe BundlesBookmarksController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before do
    @item = @item = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
    @bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @bundles_bookmark }



  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:bundles_bookmark_all) { BundlesBookmark.all }

      it "assigns all bundles_bookmark as @bundle_bookmark" do
        get :index
        assigns(:bundles_bookmarks).should eq(bundles_bookmark_all)
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

      it "assigns the requested bundles_bookmark as @bundle_bookmark" do
        get :show, id: @bundles_bookmark
        assigns(:bundles_bookmark).should eq(@bundles_bookmark)

      end

      it "renders the #show view" do

        get :show, id: @bundles_bookmark
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@bundles_bookmark
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@bundles_bookmark
        response.should_not render_template :show
      end

    end

  end

  #***********************************
  # rspec test  new
  #***********************************

  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new bundle bookmark as @bundle bookmark" do
        @item = @item = FactoryGirl.create(:item)
        @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
        @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
        @bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)

        #new_bundles_bookmark = FactoryGirl.create(:bundles_bookmark)

        BundlesBookmark.should_receive(:new).and_return(@bundles_bookmark)
        get :new
        assigns[:bundles_bookmark].should eq(@bundles_bookmark)
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

      it "assigns the requested bundle bookmarks as @bundle bookmarks" do

        @item = @item = FactoryGirl.create(:item)
        @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
        @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
        @bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)


        get :edit, id: @bundles_bookmark
        assigns[:bundles_bookmark].should eq(@bundles_bookmark)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        @item = @item = FactoryGirl.create(:item)
        @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
        @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
        @bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)

        get :edit, id: @bundles_bookmark
        response.should redirect_to root_path
      end
    end

  end


  #***********************************
  # rspec test create
  #***********************************


  describe "POST create", tag_create:true  do
    before do

      @item = @item = FactoryGirl.create(:item)
      @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
      @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
      #@bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
    end

    describe "is admin user" do
      context "with valid params" do

        it "creates a new Theme" do

          expect {
            post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
          }.to change(BundlesBookmark, :count).by(1)


        end

        it "assigns a newly created themes as @themes" do
          post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
          assigns(:bundles_bookmark).should be_a(BundlesBookmark)
          assigns(:bundles_bookmark).should be_persisted
        end

        it "redirects to the created themes" do
          post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
          response.should redirect_to(BundlesBookmark.last)
        end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do
            expect{ post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:nil,bookmark_id:@bookmark.id)
            }.to_not change(BundlesBookmark,:count)

            expect{ post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:nil)
            }.to_not change(BundlesBookmark,:count)
          end
          it "re-renders the new method" do
            post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:nil)
            response.should render_template :new

            post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:nil,bookmark_id:@bookmark.id)
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
        post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created bundle bookmark" do
        post :create,bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
        response.should_not redirect_to(BundlesBookmark.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************


  describe "PUT update", tag_update:true do
    before do
      @item = @item = FactoryGirl.create(:item)
      @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
      @bookmark = FactoryGirl.create(:bookmark,item_id:@item.id,bookmarks_category_id:@bookmarks_category.id)
      #@new_bundles_bookmark = FactoryGirl.create(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
    end

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @bundle bookmark" do
          put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
          assigns(:bundles_bookmark).should eq(@bundles_bookmark)
        end
      end

      it "changes @theme's attributes" do

        put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
        @bundles_bookmark.reload
        @bundles_bookmark.item_id.should eq(@item.id)
        @bundles_bookmark.bookmark_id.should eq(@bookmark.id)
      end

      it "redirects to the updated theme" do
        put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
        response.should redirect_to @bundles_bookmark
      end

      context "invalid attributes" do

        it "locates the requested @theme" do
          put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:nil,bookmark_id:@bookmark.id)
          assigns(:bundles_bookmark).should eq(@bundles_bookmark)
          put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:nil)
          assigns(:bundles_bookmark).should eq(@bundles_bookmark)
        end

        it "does not change @theme's attributes" do

          put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:nil)

          @bundles_bookmark.reload
          @bundles_bookmark.item_id.should_not eq(@item.id)
          @bundles_bookmark.bookmark_id.should_not eq(nil)
        end
        it "re-renders the edit method" do
          put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:nil)
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
        put :update, id: @bundles_bookmark, bundles_bookmark: FactoryGirl.attributes_for(:bundles_bookmark,item_id:@item.id,bookmark_id:@bookmark.id)
        response.should redirect_to root_path
      end
    end

  end

    #***********************************
    # rspec test  destroy
    #***********************************


      describe 'DELETE destroy', tag_destroy:true do

        it "deletes the contact" do
          expect{
            delete :destroy, id: @bundles_bookmark
          }.to change(BundlesBookmark,:count).by(-1)
        end
        it "redirects to contacts#index" do
          delete :destroy, id:  @bundles_bookmark
          response.should redirect_to bundles_bookmarks_url
        end
      end




end
