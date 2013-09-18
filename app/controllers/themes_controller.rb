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





end
