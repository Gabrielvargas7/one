require 'spec_helper'


describe BookmarksController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @item  = FactoryGirl.create(:item)
    @bookmarks_category = FactoryGirl.create(:bookmarks_category,item_id:@item.id)
    @bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category.id)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end



  subject { @bookmark }

  #***********************************
  # rspec test  index
  #***********************************


  describe "GET index",tag_index:true do

    context "is admin user" do
      let!(:bookmarks_all) { Bookmark.joins(:bookmarks_category).
        where("bookmarks_categories.item_id=?",Item.first.id).
        order('bookmarks_categories.item_id,bookmarks_category_id')}

      it "has the same attributes assigned to the first row in :bookmarks" do
        get :index
        assigns(:bookmarks).first.attributes.should eq(bookmarks_all.first.attributes)
        #NOTE: is there a better test we could do here? To test most bookmarks attributes?
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_out
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

      it "assigns the requested bookmarks  as @bookmark " do
        get :show, id: @bookmark
        assigns(:bookmark).should eq(@bookmark)

      end

      it "renders the #show view" do

        get :show, id: @bookmark
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@bookmark
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@bookmark
        response.should_not render_template :show
      end

    end
  end

  #***********************************
  # rspec test  new
  #***********************************


  describe "GET new",tag_new:true do



    context "is admin user"  do
      let(:bookmarks_category_new){BookmarksCategory.first}
      it "assigns a new bookmarks as @bookmark" do
        #puts bookmarks_category_new.id.to_s
        #puts bookmarks_category_new.item_id.to_s

        new_bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
        Bookmark.should_receive(:new).and_return(new_bookmark)
        get :new
        assigns[:bookmark].should eq(new_bookmark)
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

    let(:bookmarks_category_new){BookmarksCategory.first}
    context "is admin user"  do

      it "assigns the requested bookmarks as @bookmark " do


        new_bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
        get :edit, id: new_bookmark
        assigns[:bookmark].should eq(new_bookmark)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_bookmark = FactoryGirl.create(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
        get :edit, id: new_bookmark
        response.should redirect_to root_path
      end
    end
  end

  #***********************************
  # rspec test  create
  #***********************************

  describe "POST create", tag_create:true  do

    let(:bookmarks_category_new){BookmarksCategory.first}
    describe "is admin user" do
      context "with valid params" do

        it "creates a new bookmark" do

          expect {

            post :create,bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
          }.to change(Bookmark, :count).by(1)

        end

        context "with newly created bookmark"
          before(:each) do
            post :create, bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
          end


          it "assigns a newly created bookmark as @bookmark" do
            assigns(:bookmark).should be_a(Bookmark)
            assigns(:bookmark).should be_persisted
          end

          it "redirects to the created bookmark" do
            response.should redirect_to(Bookmark.last)
          end
      end

      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new contact" do

            #expect{ post :create, bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
            #}.to_not change(Bookmark,:count)

            expect{ post :create, bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:nil)
            }.to_not change(Bookmark,:count)

          end
          it "re-renders the new method" do
            post :create, bookmarks: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:nil)
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
        post :create, bookmark:  FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created bookmarks_category" do
        post :create, bookmark:  FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:bookmarks_category_new.id)
        response.should_not redirect_to(Bookmark.last)
      end
    end
  end


  #***********************************
  # rspec test  update
  #***********************************

  describe "PUT update", tag_update:true do

    describe "is admin user" do
      context "has valid attributes" do
        before(:each) do
          FactoryGirl.create(:item)
          FactoryGirl.create(:bookmarks_category,item_id:Item.last.id)
        end

        it "located the requested @bookmark" do
          
          put :update, id: @bookmark, bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:BookmarksCategory.last.id)
          assigns(:bookmark).should eq(@bookmark)
        end
        
        context "and has changed attributes" do
          before(:each) do
            put :update, id: @bookmark, bookmark:FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:BookmarksCategory.last.id)
          end
        
          it "changes @bookmarks's attributes" do
            @bookmark.reload
            @bookmark.bookmarks_category_id.should eq(BookmarksCategory.last.id)
          end
        
          it "redirects to the updated bookmarks" do
            put :update, id: @bookmark, bookmark:FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:BookmarksCategory.last.id)
            response.should redirect_to @bookmark
          end
        end
      end




      context "invalid attributes" do
        # Create a new variable with the same data but with a nil id
        let(:bookmark_same){ @bookmark.dup}

        it "locates the requested @bookmarks" do
          put :update, id: @bookmark, bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:nil)
          assigns(:bookmark).should eq(@bookmark)
        end

        it "re-renders the edit method" do
          put :update, id: @bookmark, bookmark:FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:nil)
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
        put :update, id: @bookmark, bookmark: FactoryGirl.attributes_for(:bookmark,bookmarks_category_id:BookmarksCategory.last.id)
        response.should redirect_to root_path
      end

    end

  end




  #***********************************
  # rspec test  index_bookmarks_approval
  #***********************************


  describe "GET index_bookmarks_approval",tag_index_approval:true do

    before do
      @item_approval  = FactoryGirl.create(:item)
      @bookmarks_category_approval = FactoryGirl.create(:bookmarks_category,item_id:@item_approval.id)
      @bookmark_approval = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category_approval.id,approval:'n')

    end


    context "is admin user" do
      let(:bookmarks_all) { Bookmark.joins(:bookmarks_category).where("approval = 'n'").order('bookmarks_categories.item_id,bookmarks_category_id').all }

      before(:each){get :index_bookmarks_approval}

      it "assigns all bookmark as :bookmark" do
        #puts "what is a id to approve "+Bookmark.where("approval = 'n'").order("item_id","bookmarks_category_id").first.id.to_s
        assigns(:bookmarks).should eq(bookmarks_all)
      end

      it "renders the :index_bookmarks_approval view" do
        #get :index_bookmarks_approval
        response.should render_template :index_bookmarks_approval
      end
    end
    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :index_bookmarks_approval
        response.should redirect_to root_path
      end

      it "not render to index " do
        get :index_bookmarks_approval
        response.should_not render_template :index_bookmarks_approval
      end
    end
  end





  #***********************************
  # rspec test  update_bookmarks_approval_for_a_user
  #***********************************

  describe "PUT update_bookmarks_approval_for_a_user", tag_update_approval:true do

    before do
      @user = FactoryGirl.create(:user)
      @item_approval  = FactoryGirl.create(:item)
      @bookmarks_category_approval = FactoryGirl.create(:bookmarks_category,item_id:@item_approval.id)
      @bookmark_approval = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category_approval.id,approval:'n',user_bookmark:@user.id)

    end


    describe "is admin user" do
      context "valid attributes" do
        it "located the requested @bookmark" do

          put :update_bookmarks_approval_for_a_user, bookmark_id: @bookmark_approval
          assigns(:bookmark).should eq(@bookmark_approval)
        end
      end

      it "changes @bookmarks's approval to 'y'" do

        put :update_bookmarks_approval_for_a_user,bookmark_id: @bookmark_approval
        @bookmark_approval.reload
        @bookmark_approval.approval.should eq('y')
        @bookmark_approval.user_bookmark.should eq(@user.id)

      end
      it "redirects to the updated bookmarks" do
        put :update_bookmarks_approval_for_a_user,bookmark_id: @bookmark_approval
        response.should redirect_to @bookmark_approval
      end

    end


    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :update_bookmarks_approval_for_a_user,bookmark_id: @bookmark_approval
        response.should redirect_to root_path
      end

    end

  end


  #***********************************
  # rspec test update_bookmarks_approval_for_all_users
  #***********************************

  describe "PUT update_bookmarks_approval_for_all_users", tag_update_approval_all:true do

    before do
      @user = FactoryGirl.create(:user)
      @item_approval  = FactoryGirl.create(:item)
      @bookmarks_category_approval = FactoryGirl.create(:bookmarks_category,item_id:@item_approval.id)
      @bookmark_approval = FactoryGirl.create(:bookmark,bookmarks_category_id:@bookmarks_category_approval.id,approval:'n',user_bookmark:@user.id)

    end


    describe "is admin user" do
      context "valid attributes" do
        it "located the requested @bookmark" do

          put :update_bookmarks_approval_for_all_users, bookmark_id: @bookmark_approval
          assigns(:bookmark).should eq(@bookmark_approval)
        end
      end

      it "changes @bookmarks's approval to 'y'" do

        put :update_bookmarks_approval_for_all_users,bookmark_id: @bookmark_approval
        @bookmark_approval.reload
        @bookmark_approval.approval.should eq('y')
        @bookmark_approval.user_bookmark.should eq(0)

      end
      it "redirects to the updated bookmarks" do
        put :update_bookmarks_approval_for_all_users,bookmark_id: @bookmark_approval
        response.should redirect_to @bookmark_approval
      end

    end


    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :update_bookmarks_approval_for_all_users,bookmark_id: @bookmark_approval
        response.should redirect_to root_path
      end

    end

  end




  #***********************************
  # rspec test  #json_index_bookmarks_with_bookmarks_category_by_item_id
  #***********************************

  describe "api #json_index_bookmarks_with_bookmarks_category_by_item_id/:item_id.json",tag_json_index:true do

    describe "is public api" do
      before do
        sign_out
        get :json_index_bookmarks_with_bookmarks_category_by_item_id,item_id: @bookmarks_category.item_id, :format => :json
      end

      it "should be successful" do
        response.should be_success
      end


      it "has a 200 status code" do
        expect(response.status).to eq(200)
      end

      context "get all values " do

        #let(:bookmarks_all){Bookmark.find_all_by_item_id(@bookmarks_category.item_id).order("bookmarks_category_id,bookmarks.id")}

        it "should return json_index_bookmarks_with_bookmarks_category_by_item_id in json" do
          # depend on what you return in action

          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body bookmark_id ----> " + body[0]["id"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "body image name desc ----> " + body[0]["image_name_desc"].to_s


          body.each do |body_bookmark|
            @bookmark_json = Bookmark.find(body_bookmark["id"])
            @bookmarks_category_json = BookmarksCategory.find(body_bookmark["bookmarks_category_id"])

            body_bookmark["id"].should == @bookmark_json.id
            body_bookmark["bookmark_url"].should == @bookmark_json.bookmark_url
            body_bookmark["bookmarks_category_id"].should == @bookmark_json.bookmarks_category_id
            body_bookmark["description"].should == @bookmark_json.description
            body_bookmark["i_frame"].should == @bookmark_json.i_frame
            body_bookmark["title"].should == @bookmark_json.title
            body_bookmark["image_name"]["url"].should == @bookmark_json.image_name.to_s
            body_bookmark["image_name_desc"]["url"].should == @bookmark_json.image_name_desc.to_s
            body_bookmark["like"].should == @bookmark_json.like

            body_bookmark["bookmarks_category_name"].should == @bookmarks_category_json.name
            body_bookmark["item_id"].should == @bookmarks_category_json.item_id.to_s

          end
        end
      end
    end
  end



  #***********************************
  # rspec test  #json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id
  #***********************************


  describe "api #json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id/:user_id/:item_id.json",tag_json_index:true do

    context "with correct sign in user " do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "should be successful with correct user id" do
        get :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id,user_id:@user.id,item_id: @bookmarks_category.item_id, :format => :json
        response.should be_success
      end


      it "has a 200 status code" do
        get :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id,user_id:@user.id,item_id: @bookmarks_category.item_id, :format => :json
        expect(response.status).to eq(200)
      end

      describe "get all values " do

        it "should return json_index_bookmarks_with_bookmarks_category_by_item_id in json" do
          # depend on what you return in action
          get :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id,user_id:@user.id,item_id: @bookmarks_category.item_id, :format => :json

          body = JSON.parse(response.body)
          #puts "body ---- > "+body.to_s
          #puts "theme ----> "+@theme.as_json.to_s
          #puts "body bookmark_id ----> " + body[0]["id"].to_s
          #puts "body image name ----> " + body[0]["image_name"]["url"].to_s
          #puts "body image name desc ----> " + body[0]["image_name_desc"].to_s


          body.each do |body_bookmark|
            @bookmark_json = Bookmark.find(body_bookmark["id"])
            @bookmarks_category_json = BookmarksCategory.find(body_bookmark["bookmarks_category_id"])

            body_bookmark["id"].should == @bookmark_json.id
            body_bookmark["bookmark_url"].should == @bookmark_json.bookmark_url

            body_bookmark["bookmarks_category_id"].should == @bookmark_json.bookmarks_category_id
            body_bookmark["bookmarks_category_name"].should == @bookmarks_category_json.name
            body_bookmark["description"].should == @bookmark_json.description
            body_bookmark["i_frame"].should == @bookmark_json.i_frame
            body_bookmark["title"].should == @bookmark_json.title

            body_bookmark["image_name"]["url"].should == @bookmark_json.image_name.to_s
            body_bookmark["image_name_desc"]["url"].should == @bookmark_json.image_name_desc.to_s
            body_bookmark["like"].should == @bookmark_json.like

          end
        end
      end
    end

    context "with the 'wrong' signed in user" do
      before do
        #Create a different user and try to get that user's info while signed in with @user.
        @different_user  = FactoryGirl.create(:user)
        get :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id,user_id:@different_user.id,item_id: @bookmarks_category.item_id, :format => :json
      end
      it "should have status 404" do
        #get json with different_user_id
        #get :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id,user_id:different_user_id,item_id: @bookmarks_category.item_id, :format => :json
        expect(response.status).to eq(404)
        #puts response.body #says 'user not correct'
      end



    end

    context "with no signed in user " do
      before do
        sign_out
      end

      it "response should be 404 " do

        get :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id,user_id:User.first.id,item_id: @bookmarks_category.item_id, :format => :json
        expect(response.status).to eq(404)
      end
    end
  end

### These are user_bookmarks related and should be in user_bookmarks_controller_spec
  # describe "api #json_show_bookmarks_seo_url_by_bookmark_id",tag_json_category:true do
    
  #   context "with signed in user" do
  #   end

  #   context "with wrong signed in user" do
  #   end

  #   context "with no signed in uesr" do
  #   end


  # end



  # describe "#json/index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset" do
  #   pending "add some examples to (or delete) #{__FILE__}"
  # end




end
