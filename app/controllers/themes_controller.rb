class ThemesController < ApplicationController

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



  # GET /themes
  # GET /themes.json
  def index
    @themes = Theme.order(:id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @themes.as_json(only: [:id,:description, :image_name, :name ,:image_name_selection]) }
    end
  end

  # GET /themes/1
  # GET /themes/1.json
  def show
    @theme = Theme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @theme }
    end
  end

  # GET /themes/new
  # GET /themes/new.json
  def new
    @theme = Theme.new
    @theme_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @theme }
    end
  end

  # GET /themes/1/edit
  def edit
    @theme = Theme.find(params[:id])
    @theme_show_id = Theme.find(params[:id])
  end

  # POST /themes
  # POST /themes.json
  def create
    @theme = Theme.new(params[:theme])

    respond_to do |format|
      params[:theme][:category] = params[:theme][:category].strip.downcase
      params[:theme][:style] = params[:theme][:style].strip.downcase
      params[:theme][:color] = params[:theme][:color].strip.downcase
      params[:theme][:brand] = params[:theme][:brand].strip.downcase
      params[:theme][:make] = params[:theme][:make].strip.downcase
      params[:theme][:location] = params[:theme][:location].strip.downcase

      if @theme.save
        format.html { redirect_to @theme, notice: 'Theme was successfully created.' }
        format.json { render json: @theme, status: :created, location: @theme }
      else
        format.html { render action: "new" }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /themes/1
  # PUT /themes/1.json
  def update
    @theme = Theme.find(params[:id])

    respond_to do |format|
      params[:theme][:category] = params[:theme][:category].strip.downcase
      params[:theme][:style] = params[:theme][:style].strip.downcase
      params[:theme][:color] = params[:theme][:color].strip.downcase
      params[:theme][:brand] = params[:theme][:brand].strip.downcase
      params[:theme][:make] = params[:theme][:make].strip.downcase
      params[:theme][:location] = params[:theme][:location].strip.downcase


      if @theme.update_attributes(params[:theme])
        format.html { redirect_to @theme, notice: 'Theme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /themes/1
  # DELETE /themes/1.json
  def destroy
    # sorry but not delete is not allow
    #@theme = Theme.find(params[:id])
    #@theme.destroy

    respond_to do |format|
      format.html { redirect_to themes_url }
      format.json { head :no_content }
    end
  end


  #***********************************
  # Json methods for the room users
  #***********************************


  # Get all themes
  # GET 'themes/json/index_themes'
  #     'themes/json/index_themes.json'
  #Return head 200 OK
  def json_index_themes
    @themes = Theme.order(:id)
    respond_to do |format|
      format.json { render json: @themes }
    end
  end

  # GET get one theme by theme id
  # GET themes/json/show_theme_by_theme_id/:theme_id
  #     themes/json/show_theme_by_theme_id/1.json
  #Return head 200 OK
  def json_show_theme_by_theme_id

    @theme = Theme.find(params[:theme_id])
    respond_to do |format|
      format.json { render json: @theme }
    end
  end


  # GET Get all themes categories group
  # /themes/json/index_themes_categories'
  # /themes/json/index_themes_categories.json'
  # Return head
  # success    ->  head  200 OK

  def json_index_themes_categories

    respond_to do |format|


        @themes_categories = Theme.select("DISTINCT(LOWER(LTRIM(RTRIM(category)))) as category")


        @themes_brands = Theme.select("DISTINCT(LOWER(LTRIM(RTRIM(brand)))) as brand")


        @themes_styles = Theme.select("DISTINCT(LOWER(LTRIM(RTRIM(style)))) as style")


        @themes_colors = Theme.select("DISTINCT(LOWER(LTRIM(RTRIM(color)))) as color")


        @themes_makes = Theme.select("DISTINCT(LOWER(LTRIM(RTRIM(make)))) as make")


        @themes_locations = Theme.select("DISTINCT(LOWER(LTRIM(RTRIM(location)))) as location")



        format.json { render json:{ themes_categories:@themes_categories,
                                    themes_brands:@themes_brands,
                                    themes_styles:@themes_styles,
                                    themes_colors:@themes_colors,
                                    themes_makes:@themes_makes,
                                    themes_locations:@themes_locations
        }}
    end

  end

  # GET Get all bundles filter by category, item_id and keyword
  # /themes/json/index_themes_filter_by_category_by_keyword_and_limit_and_offset/:category/:keyword/:limit/offset'
  # /themes/json/index_themes_filter_by_category_by_keyword_and_limit_and_offset/color/green/10/0.json'

  # Return head
  # success    ->  head  200 OK

  def json_index_themes_filter_by_category_by_keyword_and_limit_and_offset

    respond_to do |format|
      # limit the length of the string to avoid injection
      if params[:keyword].length < 12 and params[:category].length < 12

          keyword = params[:keyword].strip.downcase
          category = params[:category].strip.downcase

             if category_exist?(params[:category])
                @themes = Theme.
                    where("LOWER(LTRIM(RTRIM("+category+"))) LIKE ? ", "%#{keyword}%").
                    limit(params[:limit]).
                    offset(params[:offset])

                format.json { render json: @themes  }
             else
               format.json { render json: '[]' }
             end

      else
        #format.json { render json: 'keyword or category to long ' , status: :not_found }
        format.json { render json: '[]' }

      end

    end

  end

  # GET Get seo_url of theme
  # /themes/json/show_theme_seo_url_by_theme_id/:theme_id'
  # /themes/json/show_theme_seo_url_by_theme_id/106.json'

  # Return head
  # success    ->  head  200 OK

  def json_show_theme_seo_url_by_theme_id

    respond_to do |format|
      if Theme.exists?(id:params[:theme_id])
        @theme = Theme.where('id=?',params[:theme_id]).first

        seo_url = Hash.new
        seo_url["seo_url"] = shop_show_theme_url(@theme.id,get_clean_name(@theme.name))

        format.json { render json: seo_url }

      else
        #format.json { render json: 'not found theme id' , status: :not_found }
        format.json { render json: '{}' }
      end
    end

  end


  # Get themes by limit and offset
  # GET 'themes/json/index_themes_by_limit_and_offset/:limit/:offset'
  #     'themes/json/index_themes_by_limit_and_offset/10/0.json'
  #Return head 200 OK
  def json_index_themes_by_limit_and_offset
    @themes = Theme.order(:id).
              limit(params[:limit]).
              offset(params[:offset])

    respond_to do |format|
      format.json { render json: @themes }
    end
  end







end
