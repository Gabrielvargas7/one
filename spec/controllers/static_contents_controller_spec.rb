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

  describe "GET show", tag_show:true do

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

  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new item as @static_content" do

        new_static_content = FactoryGirl.create(:static_content)
        Item.should_receive(:new).and_return(new_static_content)
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
  # rspec test  show
  #***********************************

  describe "GET edit" do
    xit "assigns the requested static_content as @static_content" do
      static_content = StaticContent.create! valid_attributes
      get :edit, {:id => static_content.to_param}, valid_session
      assigns(:static_content).should eq(static_content)
    end
  end




  #***********************************
  # rspec test  show
  #***********************************

  describe "POST create" do
    describe "with valid params" do
      xit "creates a new StaticContent" do
        expect {
          post :create, {:static_content => valid_attributes}, valid_session
        }.to change(StaticContent, :count).by(1)
      end

      xit "assigns a newly created static_content as @static_content" do
        post :create, {:static_content => valid_attributes}, valid_session
        assigns(:static_content).should be_a(StaticContent)
        assigns(:static_content).should be_persisted
      end

      xit "redirects to the created static_content" do
        post :create, {:static_content => valid_attributes}, valid_session
        response.should redirect_to(StaticContent.last)
      end
    end

    describe "with invalid params" do
      xit "assigns a newly created but unsaved static_content as @static_content" do
        # Trigger the behavior that occurs when invalid params are submitted
        StaticContent.any_instance.stub(:save).and_return(false)
        post :create, {:static_content => { "name" => "invalid value" }}, valid_session
        assigns(:static_content).should be_a_new(StaticContent)
      end

      xit "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        StaticContent.any_instance.stub(:save).and_return(false)
        post :create, {:static_content => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end



  #***********************************
  # rspec test  show
  #***********************************

  describe "PUT update" do
    describe "with valid params" do
      xit "updates the requested static_content" do
        static_content = StaticContent.create! valid_attributes
        # Assuming there are no other static_contents in the database, this
        # specifies that the StaticContent created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        StaticContent.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
        put :update, {:id => static_content.to_param, :static_content => { "name" => "MyString" }}, valid_session
      end

      xit "assigns the requested static_content as @static_content" do
        static_content = StaticContent.create! valid_attributes
        put :update, {:id => static_content.to_param, :static_content => valid_attributes}, valid_session
        assigns(:static_content).should eq(static_content)
      end

      xit "redirects to the static_content" do
        static_content = StaticContent.create! valid_attributes
        put :update, {:id => static_content.to_param, :static_content => valid_attributes}, valid_session
        response.should redirect_to(static_content)
      end
    end

    describe "with invalid params" do
      xit "assigns the static_content as @static_content" do
        static_content = StaticContent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        StaticContent.any_instance.stub(:save).and_return(false)
        put :update, {:id => static_content.to_param, :static_content => { "name" => "invalid value" }}, valid_session
        assigns(:static_content).should eq(static_content)
      end

      xit "re-renders the 'edit' template" do
        static_content = StaticContent.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        StaticContent.any_instance.stub(:save).and_return(false)
        put :update, {:id => static_content.to_param, :static_content => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end



  #***********************************
  # rspec test  show
  #***********************************
  describe "DELETE destroy" do
    xit "destroys the requested static_content" do
      static_content = StaticContent.create! valid_attributes
      expect {
        delete :destroy, {:id => static_content.to_param}, valid_session
      }.to change(StaticContent, :count).by(-1)
    end

    xit "redirects to the static_contents list" do
      static_content = StaticContent.create! valid_attributes
      delete :destroy, {:id => static_content.to_param}, valid_session
      response.should redirect_to(static_contents_url)
    end
  end







  #***********************************
  # rspec test  json_index_static_contents
  #***********************************






  #***********************************
  # rspec test  json_show_static_content_by_name
  #***********************************


end
