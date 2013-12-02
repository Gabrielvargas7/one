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

    # when is not filter( it should get first
    if params[:item_id].blank?
      @item = Item.first
    else
      @item = Item.find(params[:item_id])
    end

    @items= Item.order(:id).all

    @items_designs = ItemsDesign.where("item_id = ?",@item.id).order(:item_id,:id).paginate(page: params[:page],:per_page => 200)


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
    #this is temporal

    #respond_to do |format|
    #    if ItemsDesign.exists?(params[:id])
    #      @items_design = ItemsDesign.find(params[:id])
    #
    #      if ItemsDesign.where('item_id=?',@items_design.item_id).count > 1
    #
    #         ActiveRecord::Base.transaction do
    #            begin
    #
    #              @user_items_designs = UsersItemsDesign.find_by_items_design_id(params[:id])
    #              @items_designs_new = ItemsDesign.where('item_id=? and id != ?',@items_design.item_id,params[:id])
    #
    #              @items_design_new = @items_designs_new.first
    #
    #              UsersItemsDesign.where('items_design_id =?',@items_design.id).update_all({:items_design_id =>@items_design_new.id,:hide =>'yes'})
    #              BundlesItemsDesign.where('items_design_id =?',@items_design.id).update_all({:items_design_id =>@items_design_new.id})
    #
    #
    #              @items_design.destroy
    #
    #              format.html { redirect_to items_designs_url, notice: 'Items design was successfully delete' }
    #
    #            rescue ActiveRecord::StatementInvalid
    #              format.html { redirect_to items_designs_url, notice: 'Error deleting Items design'  }
    #              raise ActiveRecord::Rollback
    #            end
    #         end
    #
    #      else
    #        format.html { redirect_to items_designs_url, notice: 'Error deleting Items design'  }
    #      end
    #    else
    #      format.html { redirect_to items_designs_url, notice: 'Error deleting Items design'  }
    #    end
    #end
  end

  #***********************************
  # Json methods for the room users
  #***********************************


  # GET Get item_design by id
  # /items_designs/json/show_item_design_by_id/:id'
  # /items_designs/json/show_item_design_by_id/1.json
  # Return head
  # success    ->  head  200 OK
  
  def json_show_item_design_by_id
    @items_design = ItemsDesign.find(params[:id])

    respond_to do |format|
      format.json { render json: @items_design }
    end
  end


  # GET Get  items_designs by item_id, limit and offset
  # /items_designs/json/index_items_designs_by_item_id_and_limit_offset/:item_id/:limit/:offset
  # /items_designs/json/index_items_designs_by_item_id/1/10/0.json
  # Return head
  # success    ->  head  200 OK
  def json_index_items_designs_by_item_id_and_limit_offset

    respond_to do |format|
      if ItemsDesign.exists?(item_id:params[:item_id])

        @items_designs = ItemsDesign.
            where('item_id=?',params[:item_id]).order("id").
            limit(params[:limit]).
            offset(params[:offset])

        format.json { render json: @items_designs }
      else
        format.json { render json: 'not found item id' , status: :not_found }
      end
    end
  end


  # GET Get  items_designs by item_id
  # /items_designs/json/index_items_designs_by_item_id_and_limit_offset/:item_id/:limit/:offset
  # /items_designs/json/index_items_designs_by_item_id/1/10/0.json
  # Return head
  # success    ->  head  200 OK
  def json_index_items_designs_by_item_id

    respond_to do |format|
      if ItemsDesign.exists?(item_id:params[:item_id])

        @items_designs = ItemsDesign.
            where('item_id=?',params[:item_id]).order("id")


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




# GET Get seo_url of items_design
# /items_designs/json/show_items_design_seo_url_by_items_design_id/:items_design_id'
# /items_designs/json/show_items_design_seo_url_by_items_design_id/106.json'

# Return head
# success    ->  head  200 OK

  def json_show_items_design_seo_url_by_items_design_id

    respond_to do |format|
      if ItemsDesign.exists?(id:params[:items_design_id])
        @items_design = ItemsDesign.where('id=?',params[:items_design_id]).first

        seo_url = Hash.new
        seo_url["seo_url"] = shop_show_items_design_url(@items_design.id,get_clean_name(@items_design.name))

        format.json { render json: seo_url }
      else
        format.json { render json: 'not found item designs id' , status: :not_found }
      end
    end

  end

end

