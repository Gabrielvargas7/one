require 'spec_helper'


describe FeedbacksController do

  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @feedback = FactoryGirl.create(:feedback)
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end

  #the (subject)line declare the variable that is use in all the test
  subject { @feedback }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET index",tag_index:true do

    context "is admin user" do
      let(:feedback_all) { Feedback.all }

      it "assigns all feedback as @feedback" do
        get :index
        assigns(:feedbacks).should eq(feedback_all)
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

      it "assigns the requested feedbacks as @feedbacks" do
        get :show, id: @feedback
        assigns(:feedback).should eq(@feedback)

      end

      it "renders the #show view" do

        get :show, id: @feedback
        response.should render_template :show
      end

    end

    context "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirect to root " do
        get :show, id:@feedback
        response.should redirect_to root_path
      end

      it "not render to show " do
        get :show, id:@feedback
        response.should_not render_template :show
      end

    end

  end

  ##***********************************
  ## rspec test  new
  ##***********************************

  describe "GET new",tag_new:true do

    context "is admin user"  do
      it "assigns a new feedback as @feedback" do

        new_feedback = FactoryGirl.create(:feedback)
        Feedback.should_receive(:new).and_return(new_feedback)
        get :new
        assigns[:feedback].should eq(new_feedback)
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

      it "assigns the requested feedback as @feedback" do

        new_feedback = FactoryGirl.create(:feedback)
        get :edit, id: new_feedback
        assigns[:feedback].should eq(new_feedback)
      end
    end

    context "is not admin user" do

      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user

      end

      it "redirect to root " do
        new_feedback = FactoryGirl.create(:feedback)
        get :edit, id: new_feedback
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

        it "creates a new feedback" do

          expect {
            post :create,feedback: FactoryGirl.attributes_for(:feedback)
          }.to change(Feedback, :count).by(1)


        end

        it "assigns a newly created feedback as @feedback" do
          post :create,feedback: FactoryGirl.attributes_for(:feedback)
          assigns(:feedback).should be_a(Feedback)
          assigns(:feedback).should be_persisted
        end

        it "redirects to the created themes" do
          post :create, feedback: FactoryGirl.attributes_for(:feedback)
          response.should redirect_to(Feedback.last)
        end
      end

    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root" do
        post :create, feedback: FactoryGirl.attributes_for(:feedback)
        response.should redirect_to(root_path)
      end
      it "not redirects to the created feedback" do
        post :create, feedback: FactoryGirl.attributes_for(:feedback)
        response.should_not redirect_to(Feedback.last)
      end
    end


  end

  #***********************************
  # rspec test  update
  #***********************************

  describe "PUT update", tag_update:true do

    describe "is admin user" do

      context "valid attributes" do
        it "located the requested @feedback" do
          put :update, id: @feedback, feedback: FactoryGirl.attributes_for(:feedback)
          assigns(:feedback).should eq(@feedback)
        end
      end

      it "changes @feedback's attributes" do
        put :update, id: @feedback, feedback: FactoryGirl.attributes_for(:feedback, name: "new feedback", description: "yes new")
        @feedback.reload
        @feedback.name.should eq("new feedback")
        @feedback.description.should eq("yes new")
      end

      it "redirects to the updated theme" do
        put :update, id: @feedback, feedback: FactoryGirl.attributes_for(:feedback)
        response.should redirect_to @feedback
      end

    end

    describe "is not admin user" do
      before do
        @user  = FactoryGirl.create(:user)
        sign_in @user
      end

      it "redirects to root " do
        put :update, id: @feedback, feedback: FactoryGirl.attributes_for(:feedback)
        response.should redirect_to root_path
      end
    end

  end

  #***********************************
  #rspec test  destroy
  #***********************************


  describe 'DELETE destroy', tag_destroy:true do

    it "deletes the contact" do
      expect{
        delete :destroy, id: @feedback
      }.to change(Feedback,:count).by(-1)
    end
    it "redirects to contacts#index" do
      delete :destroy, id:  @feedback
      response.should redirect_to feedbacks_url
    end
  end


  #***********************************
  # rspec test json_create_feedback
  #***********************************


  describe "POST json_create_feedback", tag_json_create:true  do
    describe "is public api" do

      before do
        @new_name = "new feedback"
        @new_email = "new email"
        @new_desc = "new desc"
        @new_user_id = 1
        sign_out
      end


        describe "is admin user" do
          context "with valid params" do

            it "creates a new feedback" do

              expect {
                post :json_create_feedback,name:@new_name,email:@new_email,description:@new_desc,user_id:@new_user_id, :format => :json
              }.to change(Feedback, :count).by(1)
            end

            it "assigns a newly created feedback as @feedback" do
              post :json_create_feedback,name:@new_name,email:@new_email,description:@new_desc,user_id:@new_user_id, :format => :json
              assigns(:feedback).should be_a(Feedback)
              assigns(:feedback).should be_persisted
            end

            it "response should be success" do
              post :json_create_feedback,name:@new_name,email:@new_email,description:@new_desc,user_id:@new_user_id, :format => :json
              response.should be_success
            end

            it "has a 201 status code" do
              post :json_create_feedback,name:@new_name,email:@new_email,description:@new_desc,user_id:@new_user_id, :format => :json
              expect(response.status).to eq(201)
            end

            context "return json values " do
              it "should return json_create_feedback in json" do # depend on what you return in action
                post :json_create_feedback,name:@new_name,email:@new_email,description:@new_desc,user_id:@new_user_id, :format => :json
                body = JSON.parse(response.body)
                body["name"].should == @new_name
                body["description"].should == @new_desc
                body["user_id"].should == @new_user_id
                body["email"].should == @new_email
              end
            end

          end
        end

    end

  end



end
