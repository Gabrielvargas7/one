require 'spec_helper'

describe ShopController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @item = FactoryGirl.create(:item)
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @item }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET shop index",tag_index:true do

    context "public pages" do
      let(:item_all) { Item.order(:priority_order,:name).all}

      it "assigns all themes as @item" do
        get :index
        assigns(:items).should eq(item_all)
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end

  end



end
