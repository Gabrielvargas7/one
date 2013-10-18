class ItemsDesignsController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create
                ]

  before_filter :json_signed_in_user,
                only:[
                ]

  before_filter :admin_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create
                ]


  # GET /items_designs
  # GET /items_designs.json
  def index

    @items_designs = ItemsDesign.order(:item_id,:id).all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items_designs }
    end
  end


  # GET /items_designs/1
  # GET /items_designs/1.json
  def show
    @items_design = ItemsDesign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @items_design }
    end
  end

  # GET /items_designs/new
  # GET /items_designs/new.json
  def new
    @items_design = ItemsDesign.new
    @items_design_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @items_design }
    end
  end

  # GET /items_designs/1/edit
  def edit
    @items_design = ItemsDesign.find(params[:id])
    @items_design_show_id = ItemsDesign.find(params[:id])
  end

  # POST /items_designs
  # POST /items_designs.json
  def create
    @items_design = ItemsDesign.new(params[:items_design])

    params[:items_design][:category] = params[:items_design][:category].strip.downcase
    params[:items_design][:style] = params[:items_design][:style].strip.downcase
    params[:items_design][:color] = params[:items_design][:color].strip.downcase
    params[:items_design][:brand] = params[:items_design][:brand].strip.downcase
    params[:items_design][:make] = params[:items_design][:make].strip.downcase


    respond_to do |format|
      if @items_design.save
        format.html { redirect_to @items_design, notice: 'Items design was successfully created.' }
        format.json { render json: @items_design, status: :created, location: @items_design }
      else
        format.html { render action: "new" }
        format.json { render json: @items_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items_designs/1
  # PUT /items_designs/1.json
  def update
    @items_design = ItemsDesign.find(params[:id])

    params[:items_design][:category] = params[:items_design][:category].strip.downcase
    params[:items_design][:style] = params[:items_design][:style].strip.downcase
    params[:items_design][:color] = params[:items_design][:color].strip.downcase
    params[:items_design][:brand] = params[:items_design][:brand].strip.downcase
    params[:items_design][:make] = params[:items_design][:make].strip.downcase


    respond_to do |format|
      if @items_design.update_attributes(params[:items_design])
        format.html { redirect_to @items_design, notice: 'Items design was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @items_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items_designs/1
  # DELETE /items_designs/1.json
  def destroy
    # sorry but not delete is not allow
    #@items_design = ItemsDesign.find(params[:id])
    #@items_design.destroy

    respond_to do |format|
      format.html { redirect_to items_designs_url }
      format.json { head :no_content }
    end
  end


  #***********************************
  # Json methods for the room users
  #***********************************


  # GET Get all items_designs by item_id
  # /items_designs/json/index_items_designs_by_item_id/:item_id'
  # /items_designs/json/index_items_designs_by_item_id/1.json
  # Return head
  # success    ->  head  200 OK

  def json_index_items_designs_by_item_id

    respond_to do |format|
      if ItemsDesign.exists?(item_id:params[:item_id])
        @items_designs = ItemsDesign.where('item_id=?',params[:item_id]).order("id")

        format.json { render json: @items_designs }
      else
        format.json { render json: 'not found item id' , status: :not_found }
      end
    end
  end


  # GET Get random items_designs
  # /items_designs/json/index_random_items_by_limit_by_offset/:limit/:offset.json
  # /items_designs/json/index_random_items_by_limit_by_offset/10/0.json
  # Return head
  # success    ->  head  200 OK

  def json_index_random_items_by_limit_by_offset

    respond_to do |format|

        @items_designs = ItemsDesign.order("RANDOM()").limit(params[:limit]).offset(params[:offset])
        format.json { render json: @items_designs }

    end
  end

  # GET Get all items_designs of bundle by bundle_id
  # /items_designs/json/index_items_designs_of_bundle_by_bundle_id/:bundle_id'
  # /items_designs/json/index_items_designs_of_bundle_by_bundle_id/1.json
  # Return head
  # success    ->  head  200 OK

  def json_index_items_designs_of_bundle_by_bundle_id

    respond_to do |format|

      if Bundle.exists?(id:params[:bundle_id])

        @bundles_items_designs = ItemsDesign.
                    select('items_designs.id ,
                            items_designs.name,
                            items_designs.item_id,
                            items_designs.description,
                            items_designs.category,
                            items_designs.style,
                            items_designs.brand,
                            items_designs.color,
                            items_designs.make,
                            items_designs.special_name,
                            items_designs.like,
                            items_designs.image_name,
                            items_designs.image_name_logo,
                            items_designs.image_name_hover,
                            items_designs.image_name_selection').
                    joins(:bundles_items_designs).
                    where('bundles_items_designs.bundle_id=?',params[:bundle_id]).
                    order('items_designs.item_id')

        format.json { render json: @bundles_items_designs }
      else
        format.json { render json: 'not found bundle id' , status: :not_found }
      end


    end
  end



  # GET Get all items_designs categories group
  # /items_designs/json/index_items_designs_categories_by_item_id/:item_id'
  # /items_designs/json/index_items_designs_categories_by_item_id/1.json'
  # Return head
  # success    ->  head  200 OK

  def json_index_items_designs_categories_by_item_id

    respond_to do |format|

      if ItemsDesign.exists?(item_id:params[:item_id])

        @items_designs_categories = ItemsDesign.select("DISTINCT(LOWER(LTRIM(RTRIM(category)))) as category, item_id ").
            where("item_id = ?",params[:item_id])

        @items_designs_brands = ItemsDesign.select("DISTINCT(LOWER(LTRIM(RTRIM(brand)))) as brand, item_id ").
            where("item_id = ?",params[:item_id])

        @items_designs_styles = ItemsDesign.select("DISTINCT(LOWER(LTRIM(RTRIM(style)))) as style, item_id ").
            where("item_id = ?",params[:item_id])

        @items_designs_colors = ItemsDesign.select("DISTINCT(LOWER(LTRIM(RTRIM(color)))) as color, item_id ").
            where("item_id = ?",params[:item_id])

        @items_designs_makes = ItemsDesign.select("DISTINCT(LOWER(LTRIM(RTRIM(make)))) as make, item_id ").
            where("item_id = ?",params[:item_id])



        format.json { render json:{ items_designs_categories:@items_designs_categories,
                                     items_designs_brands:@items_designs_brands,
                                     items_designs_styles:@items_designs_styles,
                                     items_designs_colors:@items_designs_colors,
                                     items_designs_makes:@items_designs_makes
        }}

      else
        format.json { render json: 'not found item id' , status: :not_found }
      end

    end

  end



  # GET Get all items_designs filter by category, item_id and keyword and limit and offset
  # /items_designs/json/index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset/:category/:item_id/:keyword/:limit/:offset'
  # /items_designs/json/index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset/color/11/green/10/0.json'

  # Return head
  # success    ->  head  200 OK

  def json_index_items_designs_filter_by_category_by_item_id_by_keyword_and_limit_and_offset


    respond_to do |format|

      # limit the length of the string to avoid injection
      if params[:keyword].length < 12 and params[:category].length < 12

          if ItemsDesign.exists?(item_id:params[:item_id])

          keyword = params[:keyword].strip.downcase
          category = params[:category].strip.downcase

          @items_designs = ItemsDesign.
              where("LOWER(LTRIM(RTRIM("+category+"))) LIKE ? and item_id = ? ", "%#{keyword}%",params[:item_id]).
              limit(params[:limit]).
              offset(params[:offset])


          format.json { render json: @items_designs
          }

        else
          format.json { render json: 'not found item id' , status: :not_found }
        end
      else
        format.json { render json: 'keyword or category to long ' , status: :not_found }
      end

    end

  end

end
