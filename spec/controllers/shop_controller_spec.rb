require 'spec_helper'

describe ShopController do


  before(:all){ create_init_data }
  after(:all){ delete_init_data }

  before  do
    @item = FactoryGirl.create(:item)
    @items_design1 = FactoryGirl.create(:items_design,item_id:@item.id)
    @items_design2 = FactoryGirl.create(:items_design,item_id:@item.id,color:"color1",brand:"brand1",style:"style1",make:"make1")
    #puts "Admin user signin cookie: "+cookies[:remember_token].to_s
  end


  #the (subject)line declare the variable that is use in all the test
  subject { @item }


  #***********************************
  # rspec test  index
  #***********************************

  describe "GET shop index",tag_index:true do

    context "public pages" do
      let(:items_all) { Item.joins(:items_locations).select('items.*,
                          locations.z,
                          locations.x,
                          locations.y,
                          locations.height,
                          locations.width,
                          locations.section_id').
                      joins('LEFT OUTER JOIN locations  ON locations.id = items_locations.location_id').
                      order(:priority_order,:name).all}

      it "assigns all items as @item" do

        get :index
        assigns(:items).should eq(items_all)
      end

      it "renders the :index view" do

        get :index
        response.should render_template :index
      end
    end

  end



  ##***********************************
  ## rspec test  show
  ##***********************************


  describe "GET shop show", tag_show:true do


    context "is public pages " do

      let(:items_design_all) { ItemsDesign.where("item_id = ?",@item.id).order(:updated_at)}
      let(:items_by_type_all) { Item.order(:id).all }
      let(:items_design_by_color_all) { ItemsDesign.select("lower(color) as color,max(item_id) as item_id").where("item_id = ?",@item.id).group("lower(color)").order(:color) }
      let(:items_design_by_brand_all) { ItemsDesign.select("lower(brand) as brand,max(item_id) as item_id").where("item_id = ?",@item.id).group("lower(brand)").order(:brand) }
      let(:items_design_by_style_all) { ItemsDesign.select("lower(style) as style,max(item_id) as item_id").where("item_id = ?",@item.id).group("lower(style)").order(:style) }
      let(:items_design_by_make_all) { ItemsDesign.select("lower(make) as make,max(item_id) as item_id").where("item_id = ?",@item.id).group("lower(make)").order(:make) }

      it "assigns the requested shop items designs as shop @items designs" do
        get :show, id: @item.id
        assigns(:items_designs).to_a.should match_array items_design_all
        assigns(:items_by_type).to_a.should match_array items_by_type_all
        assigns(:items_designs_by_color).should.as_json eq(items_design_by_color_all.as_json)
        assigns(:items_designs_by_brand).should.as_json eq(items_design_by_brand_all.as_json)
        assigns(:items_designs_by_style).should.as_json eq(items_design_by_style_all.as_json)
        assigns(:items_designs_by_make).should.as_json eq(items_design_by_make_all.as_json)
      end

      it "renders the #show view" do
        get :show, id: @item.id
        response.should render_template :show
      end

      let(:items_design_all_color) { ItemsDesign.where("item_id = ?",@item.id)
      .where('lower(color) = ?',@items_design2.color)
      .order(:updated_at) }

      let(:items_design_all_brand) { ItemsDesign.where("item_id = ?",@item.id)
      .where('lower(brand) = ?',@items_design2.brand)
      .order(:updated_at) }

      let(:items_design_all_make) { ItemsDesign.where("item_id = ?",@item.id)
      .where('lower(make) = ?',@items_design2.make)
      .order(:updated_at) }

      let(:items_design_all_style) { ItemsDesign.where("item_id = ?",@item.id)
      .where('lower(style) = ?',@items_design2.style)
      .order(:updated_at) }


      it "assigns the requested shop items designs as shop items designs with color params " do

        get :show, id: @item.id ,item_color:@items_design2.color
        assigns(:items_designs).to_a.should match_array items_design_all_color

      end

      it "assigns the requested shop items designs as shop items designs with brand params " do

        get :show, id: @item.id ,item_brand:@items_design2.brand
        assigns(:items_designs).to_a.should match_array items_design_all_brand

      end

      it "assigns the requested shop items designs as shop items designs with style params " do

        get :show, id: @item.id ,item_style:@items_design2.style
        assigns(:items_designs).to_a.should match_array items_design_all_style
      end

      it "assigns the requested shop items designs as shop items designs with make params " do

        get :show, id: @item.id ,item_make:@items_design2.make
        assigns(:items_designs).to_a.should match_array items_design_all_make
      end

    end
  end



end
