require 'spec_helper'

describe StaticContentsController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @static_content = FactoryGirl.create(:static_content)

    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end


  # the (subject) line declares the variable that is used in all the tests
  subject { @static_content }



  #***********************************
  # rspec test  index
  #***********************************

  describe "GET static content index", tag_index: true do

    context "admin" do
      let(:static_contents_all){ StaticContent.all }

      it "assigns all static contents as @static_contents" do
        get :index
        assigns(:static_contents).should eq(static_contents_all)
      end

      it "returns json when requested" do
        get :index, :format => :json
        expect(response).to be_success
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end



    context "non-admin" do
      before do
        sign_out
      end

      it "redirects to root" do
        get :index
        expect(response).to redirect_to root_path
      end
    end

  end






  #***********************************
  # rspec test  show
  #***********************************

  describe "GET show", tag_show: true do

    context "is admin user" do

      it "assigns the requested static content as @static_content" do
        get :show, id: @static_content
        assigns(:static_content).should eq(@static_content)

      end

      it "renders the #show view" do

        get :show, id: @static_content
        expect(response).to render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root" do
        get :show, id: @static_content
        expect(response).to redirect_to root_path
      end

      it "not render to show" do
        get :show, id: @static_content
        expect(response).to_not render_template :show
      end

    end

  end




  #***********************************
  # rspec test  new
  #***********************************

  describe "GET new", tag_new: true do

    context "is admin user"  do
      it "assigns a new item as @static_content" do

        new_static_content = FactoryGirl.create(:static_content)
        StaticContent.should_receive(:new).and_return(new_static_content)

        get :new
        expect(assigns[:static_content]).to eq(new_static_content)
      end
    end

    context "is not admin user"  do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root" do
        get :new
        expect(response).to redirect_to root_path
      end
    end

  end




  #***********************************
  # rspec test  edit
  #***********************************

  describe "GET edit", tag_edit: true do

    context "is admin user"  do

      it "assigns the requested item design as @item design" do
        new_static_content = FactoryGirl.create(:static_content)
        get :edit, id: new_static_content
        assigns[:static_content].should eq(new_static_content)
      end
    end

    context "is not admin user"  do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root" do
        new_static_content = FactoryGirl.create(:static_content)
        get :new, id: new_static_content
        expect(response).to redirect_to root_path
      end
    end

  end





  #***********************************
  # rspec test  create
  #***********************************

  describe "POST create", tag_create: true  do


    describe "is admin user" do
      context "with valid params" do

        it "creates a new Items design" do
          expect {
            post :create, static_content: FactoryGirl.attributes_for(:static_content)
          }.to change(StaticContent, :count).by(1)
        end

        it "assigns a newly created static content as @static_content" do
          post :create, static_content: FactoryGirl.attributes_for(:static_content)
          assigns(:static_content).should be_a(StaticContent)
          assigns(:static_content).should be_persisted
        end

        it "redirects to the created static content" do
          post :create, static_content: FactoryGirl.attributes_for(:static_content)
          response.should redirect_to(StaticContent.last)
        end
      end


      context "with invalid params" do

        context "with invalid attributes" do
          it "does not save the new static content" do
            expect{ post :create, static_content: FactoryGirl.attributes_for(:static_content, name: nil)
            }.to_not change(StaticContent, :count)
          end
          it "re-renders the new method" do
            post :create, static_content: FactoryGirl.attributes_for(:static_content, name: nil)
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
        post :create, static_content: FactoryGirl.attributes_for(:static_content)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created items design" do
        post :create, static_content: FactoryGirl.attributes_for(:static_content)
        response.should_not redirect_to(StaticContent.last)
      end
    end

  end



  #***********************************
  # rspec test  update
  #***********************************

  describe "PUT update", tag_update: true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @static_content" do

          @static_content = FactoryGirl.create(:static_content)
          put :update, id: @static_content, static_content: FactoryGirl.attributes_for(:static_content)

          assigns(:static_content).should eq(@static_content)
        end
      end

      it "changes @static_content attributes" do
        put :update, id: @static_content, static_content: FactoryGirl.attributes_for(:static_content, name: 'bob', description: "bob's static content")
        @static_content.reload
        @static_content.name.should eq('bob')
        @static_content.description.should eq("bob's static content")
      end

      it "redirects to the updated static content" do
        put :update, id: @static_content, static_content: FactoryGirl.attributes_for(:static_content, name: 'bob', description: "bob's static content")
        response.should redirect_to @static_content
      end

      context "invalid attributes" do

        it "locates the requested @static_content" do
          put :update, id: @static_content, static_content: FactoryGirl.attributes_for(:static_content, name: nil, description: "bob's static content")
          expect(assigns(:static_content)).to eq(@static_content)
        end
        it "does not change @static_content's attributes" do
          put :update, id:@static_content, static_content: FactoryGirl.attributes_for(:static_content, name: nil, description: "bob's static content")
          @static_content.reload
          @static_content.name.should_not eq(nil)
          @static_content.description.should_not eq("bob's static content")
        end
        it "re-renders the edit method" do
          put :update, id: @static_content, static_content: FactoryGirl.attributes_for(:static_content, name: nil, description: "bob's static content")
          response.should render_template :edit
        end
      end
    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        put :update, id: @static_content, static_content: FactoryGirl.attributes_for(:static_content, name: 'bob', description: "bob's static content")
        response.should redirect_to root_path
      end
    end

  end



  #***********************************
  # rspec test  destroy <-- no-op, missing template
  #***********************************







  #***********************************
  # rspec test  json_index_static_contents
  #***********************************
  describe "GET static content index", tag_json_index: true do

    context "is a public api" do
      before { sign_out }
      let(:static_contents_all){ StaticContent.all }

      it "fetches all static contents" do
        get :json_index_static_contents, :format => :json
        expect(response).to be_success

        body = JSON.parse(response.body)

        expect(body.length).to eq(static_contents_all.length)
        expect(body[0]["description"]).to eq(static_contents_all[0].description)
        expect(body[0]["name"]).to eq(static_contents_all[0].name)
      end
    end
  end





  #***********************************
  # rspec test  json_show_static_content_by_name
  #***********************************
  describe "GET static content index", tag_json_index: true do

    context "is a public api" do
      before { sign_out }
      let(:static_contents){ StaticContent.find_by_name(@static_content.name) }

      it "fetches 1 static content by name" do
        get :json_index_static_contents, name: @static_content.name, :format => :json
        expect(response).to be_success

        body = JSON.parse(response.body)

        expect(body[0]["description"]).to eq(static_contents.description)
        expect(body[0]["name"]).to eq(static_contents.name)
      end
    end
  end



end
