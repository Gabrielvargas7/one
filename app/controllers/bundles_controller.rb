class BundlesController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                      :active_update
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
                      :create,
                      :active_update
                ]

  # GET /bundles
  # GET /bundles.json
  def index

    #@bundles = Bundle.paginate(page: params[:page], :per_page => 10)
    #@bundles = Bundle.paginate(page: params[:page]).order('id')

    @bundles = Bundle.order('id').all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bundles }
    end
  end

  # GET /bundles/1
  # GET /bundles/1.json
  def show
    @bundle = Bundle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bundle }
    end
  end

  # GET /bundles/new
  # GET /bundles/new.json
  def new
    @bundle = Bundle.new
    @bundle_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bundle }
    end
  end

  # GET /bundles/1/edit
  def edit
    @bundle = Bundle.find(params[:id])
    @bundle_show_id = Bundle.find(params[:id])
    #@themes = Theme.all

  end

  # POST /bundles
  # POST /bundles.json
  def create
    @bundle = Bundle.new(params[:bundle])

    params[:bundle][:category] = params[:bundle][:category].strip.downcase
    params[:bundle][:style] = params[:bundle][:style].strip.downcase
    params[:bundle][:color] = params[:bundle][:color].strip.downcase
    params[:bundle][:brand] = params[:bundle][:brand].strip.downcase
    params[:bundle][:make] = params[:bundle][:make].strip.downcase
    params[:bundle][:location] = params[:bundle][:location].strip.downcase


    respond_to do |format|
      if @bundle.save
        format.html { redirect_to @bundle, notice: 'Bundle was successfully created.' }
        format.json { render json: @bundle, status: :created, location: @bundle }
      else
        format.html { render action: "new" }
        format.json { render json: @bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bundles/1
  # PUT /bundles/1.json
  def update
    @bundle = Bundle.find(params[:id])


    respond_to do |format|
      params[:bundle][:category] = params[:bundle][:category].strip.downcase
      params[:bundle][:style] = params[:bundle][:style].strip.downcase
      params[:bundle][:color] = params[:bundle][:color].strip.downcase
      params[:bundle][:brand] = params[:bundle][:brand].strip.downcase
      params[:bundle][:make] = params[:bundle][:make].strip.downcase
      params[:bundle][:location] = params[:bundle][:location].strip.downcase

      if @bundle.update_attributes(params[:bundle])
        format.html { redirect_to @bundle, notice: 'Bundle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bundle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bundles/1
  # DELETE /bundles/1.json
  def destroy
    # sorry but not delete is not allow
    #@bundle = Bundle.find(params[:id])
    #@bundle.destroy

    respond_to do |format|
      format.html { redirect_to bundles_url }
      format.json { head :no_content }
    end
  end

  # PUT /active_bundles/1
  # PUT /active_bundles/1.json
  def active_update
    respond_to do |format|
      if Bundle.exists?(id:params[:id])
        @bundle = Bundle.find(params[:id])

        if BundlesItemsDesign.exists?(bundle_id:params[:id])

          @bundle.active = 'y'
          if @bundle.save!
            format.html { redirect_to @bundle, notice: 'Bundle was successfully updated.' }
          else
            format.html { redirect_to @bundle, notice: 'something go wrong.' }
          end
        else
          format.html { redirect_to @bundle, notice:  "Bundle item design doesn't exist yet, you need to have a least one." }
        end
      else
        format.json { render json: @bundle.errors, status: :unprocessable_entity }

      end
    end
  end




  #***********************************
  # Json methods for the room users
  #***********************************

  # GET Get all bundles
  # /bundles/json/index_bundles
  # /bundles/json/index_bundles.json
  #Return head
  #success    ->  head  200 OK

  #public api

  def json_index_bundles

    @bundles = Bundle.where("active = 'y'").order(:id)
    respond_to do |format|
      format.json { render json: @bundles.as_json()

      }
    end

  end


  # GET Get all bundles categories group
  # /bundles/json/index_bundles_categories'
  # /bundles/json/index_bundles_categories.json'
  # Return head
  # success    ->  head  200 OK

  def json_index_bundles_categories

    respond_to do |format|


      @bundles_categories = Bundle.select("DISTINCT(LOWER(LTRIM(RTRIM(category)))) as category").where("active = 'y'")


      @bundles_brands = Bundle.select("DISTINCT(LOWER(LTRIM(RTRIM(brand)))) as brand").where("active = 'y'")


      @bundles_styles = Bundle.select("DISTINCT(LOWER(LTRIM(RTRIM(style)))) as style").where("active = 'y'")


      @bundles_colors = Bundle.select("DISTINCT(LOWER(LTRIM(RTRIM(color)))) as color").where("active = 'y'")


      @bundles_makes = Bundle.select("DISTINCT(LOWER(LTRIM(RTRIM(make)))) as make").where("active = 'y'")


      @bundles_locations = Bundle.select("DISTINCT(LOWER(LTRIM(RTRIM(location)))) as location").where("active = 'y'")



      format.json { render json:{ bundles_categories:@bundles_categories,
                                  bundles_brands:@bundles_brands,
                                  bundles_styles:@bundles_styles,
                                  bundles_colors:@bundles_colors,
                                  bundles_makes:@bundles_makes,
                                  bundles_locations:@bundles_locations
      }}
    end
  end



    # GET Get all bundles filter by category, item_id and keyword
  # /bundles/json/index_bundles_filter_by_category_by_keyword_and_limit_and_offset/:category/:keyword/:limit/:offset'
  # /bundles/json/index_bundles_filter_by_category_by_keyword_and_limit_and_offset/color/green/10/0.json'

  # Return head
  # success    ->  head  200 OK

  def json_index_bundles_filter_by_category_by_keyword_and_limit_and_offset


    respond_to do |format|

      # limit the length of the string to avoid injection
      if params[:keyword].length < 12 and params[:category].length < 12


        keyword = params[:keyword].strip.downcase
        category = params[:category].strip.downcase


        @bundles = Bundle.
            where("LOWER(LTRIM(RTRIM("+category+"))) LIKE ? ", "%#{keyword}%").
            where("active = 'y'").
            limit(params[:limit]).
            offset(params[:offset])


        format.json { render json: @bundles
        }

      else
        format.json { render json: 'keyword or category to long ' , status: :not_found }
      end

    end

  end


# GET Get seo_url of bundle
# /bundles/json/show_bundle_seo_url_by_bundle_id/:bundle_id'
# /bundles/json/show_bundle_seo_url_by_bundle_id/1.json'
# Return head
# success    ->  head  200 OK

  def json_show_bundle_seo_url_by_bundle_id

    respond_to do |format|
      if Bundle.where("active = 'y'").exists?(id:params[:bundle_id])
        @bundle = Bundle.where("active = 'y'").where('id=?',params[:bundle_id]).first

        seo_url = Hash.new
        seo_url["seo_url"] = shop_show_bundle_url(@bundle.id,get_clean_name(@bundle.name))

        format.json { render json: seo_url }
      else
        format.json { render json: 'not found bundle id' , status: :not_found }
      end
    end
  end


# GET Get seo_url of entire room
# /bundles/json/show_entire_room_seo_url_by_bundle_id/:bundle_id'
# /bundles/json/show_entire_room_seo_url_by_bundle_id/1.json'
# Return head
# success    ->  head  200 OK

  def json_show_entire_room_seo_url_by_bundle_id

    respond_to do |format|

      if Bundle.where("active = 'y'").exists?(id:params[:bundle_id])
        @bundle = Bundle.where("active = 'y'").where('id=?',params[:bundle_id]).first

        seo_url = Hash.new
        seo_url["seo_url"] = shop_show_bundle_url(@bundle.id,get_clean_name(@bundle.name))

        format.json { render json: seo_url }
      else
        format.json { render json: 'not found bundle id' , status: :not_found }
      end
    end
  end



end
