class ShopController < ApplicationController



  # GET /shop
  def index

    #@items = Item.paginate(page: params[:page], :per_page => 10)
    #@items = Item.paginate(page: params[:page]).order('id')

    #@items = Item.order(:priority_order,:name).all

    @items = Item.joins(:items_locations).
        select('items.*,
                  locations.z,
                  locations.x,
                  locations.y,
                  locations.height,
                  locations.width,
                  locations.section_id').
        joins('LEFT OUTER JOIN locations  ON locations.id = items_locations.location_id').
        order(:priority_order,:name).all



    if @items.length < 4
      @item_length = @items.length
    else
      @item_length = 4
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end


  #get all the item designs for the item
  # GET /shop/item/:item_id/:name
  def show_item

    # when is not filter(all filter blank, it should get all the items
    if params[:item_color].blank? && params[:item_brand].blank?&& params[:item_style].blank?&&params[:item_make].blank?&&params[:item_category].blank?
      @items_designs = ItemsDesign.where("item_id = ?",params[:item_id]).order(:updated_at)
    else

      unless params[:item_color].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:item_id])
        .where('lower(color) = ?',params[:item_color])
        .order(:updated_at)
      end
      unless params[:item_brand].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:item_id])
        .where('lower(brand) = ?',params[:item_brand])
        .order(:updated_at)
      end
      unless params[:item_style].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:item_id])
        .where('lower(style) = ?',params[:item_style])
        .order(:updated_at)
      end
      unless params[:item_make].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:item_id])
        .where('lower(make) = ?',params[:item_make])
        .order(:updated_at)
      end

      unless params[:item_category].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:item_id])
        .where('lower(category) = ?',params[:item_category])
        .order(:updated_at)
      end

    end


    if @items_designs.length < 3
      @item_length = @items_designs.length
    else
      @item_length = 3
    end

    @items_by_type             = Item.order(:id).all
    @items_designs_by_color    = ItemsDesign.select("lower(color) as color,max(item_id) as item_id").where("item_id = ?",params[:item_id]).group("lower(color)").order(:color)
    @items_designs_by_brand    = ItemsDesign.select("lower(brand) as brand,max(item_id) as item_id").where("item_id = ?",params[:item_id]).group("lower(brand)").order(:brand)
    @items_designs_by_style    = ItemsDesign.select("lower(style) as style,max(item_id) as item_id").where("item_id = ?",params[:item_id]).group("lower(style)").order(:style)
    @items_designs_by_make     = ItemsDesign.select("lower(make) as make,max(item_id) as item_id").where("item_id = ?",params[:item_id]).group("lower(make)").order(:make)
    @items_designs_by_category = ItemsDesign.select("lower(category) as category,max(item_id) as item_id").where("item_id = ?",params[:item_id]).group("lower(category)").order(:category)


    respond_to do |format|
      format.html # show_item.html.erb

    end

  end

  # GET /shop/items-design/:items_design_id/:name
  def show_items_design

    number_of_enties = 5
    @items_design = ItemsDesign.find(params[:items_design_id])
    @items_designs_rand = ItemsDesign.where('item_id = ?',@items_design.item_id).limit(number_of_enties*2).order("RANDOM()")

    @fb_og_image = @items_design.image_name_selection.url.to_s
    @fb_og_title = @items_design.name.to_s
    @fb_og_description = @items_design.description.to_s
    #@fb_app_id = 330390967090243.to_s
    @fb_app_id = ENV["ROOMS_FACEBOOK_APP_ID"].to_s
    @fb_url = root_url.to_s + 'shop/items-design/' + @items_design.id.to_s+'/'+get_clean_name(@items_design.name.to_s)


    if @items_designs_rand.length < number_of_enties
      @item_length = @items_designs_rand.length
    else
      @item_length = number_of_enties
    end

    respond_to do |format|
      format.html # shop_items_design.html.erb

    end


  end

  # GET /shop/themes
  def index_themes

    # when is not filter(all filter blank, it should get all the themes
    if params[:theme_color].blank? && params[:theme_brand].blank?&& params[:theme_style].blank?&&params[:theme_make].blank?&&params[:theme_location].blank?&&params[:theme_category].blank?
      @themes = Theme.order(:updated_at)
    else

      unless params[:theme_color].blank?
        @themes = Theme
        .where('lower(color) = ?',params[:theme_color])
        .order(:updated_at)
      end
      unless params[:theme_brand].blank?
        @themes = Theme
        .where('lower(brand) = ?',params[:theme_brand])
        .order(:updated_at)
      end
      unless params[:theme_style].blank?
        @themes = Theme
        .where('lower(style) = ?',params[:theme_style])
        .order(:updated_at)
      end
      unless params[:theme_make].blank?
        @themes = Theme
        .where('lower(make) = ?',params[:theme_make])
        .order(:updated_at)

      end
      unless params[:theme_category].blank?
        @themes = Theme
        .where('lower(category) = ?',params[:theme_category])
        .order(:updated_at)
      end
      unless params[:theme_location].blank?
        @themes = Theme
        .where('lower(location) = ?',params[:theme_location])
        .order(:updated_at)
      end
    end

    if @themes.length < 3
      @theme_length = @themes.length
    else
      @theme_length = 3
    end

    @themes_by_color    =   Theme.select("lower(color) as color,max(id) as id").group("lower(color)").order(:color)
    @themes_by_brand    =   Theme.select("lower(brand) as brand,max(id) as id").group("lower(brand)").order(:brand)
    @themes_by_style    =   Theme.select("lower(style) as style,max(id) as id").group("lower(style)").order(:style)
    @themes_by_make     =   Theme.select("lower(make) as make,max(id) as id").group("lower(make)").order(:make)
    @themes_by_category   = Theme.select("lower(category) as category,max(id) as id").group("lower(category)").order(:category)
    @themes_by_location   = Theme.select("lower(location) as location,max(id) as id").group("lower(location)").order(:location)



    respond_to do |format|
      format.html # index_themes.html.erb

    end



  end

  # GET /shop/theme/:id/:name
  def show_theme

    number_of_enties = 5
    @theme = Theme.find(params[:id])
    @themes_rand = Theme.limit(number_of_enties*2).order("RANDOM()")

    @fb_og_image = @theme.image_name_selection.url.to_s
    @fb_og_title = @theme.name.to_s
    @fb_og_description = @theme.description.to_s
    #@fb_app_id = 330390967090243.to_s
    @fb_app_id = ENV["ROOMS_FACEBOOK_APP_ID"].to_s
    @fb_url = root_url.to_s + 'shop/theme/' + @theme.id.to_s+'/'+get_clean_name(@theme.name.to_s)

    if @themes_rand.length < number_of_enties
      @theme_length = @themes_rand.length
    else
      @theme_length = number_of_enties
    end

    respond_to do |format|
      format.html # shop_items_design.html.erb
    end
  end

  # GET /shop/bundles
  def index_bundles

    # when is not filter(all filter blank, it should get all the themes
    if params[:bundle_color].blank? && params[:bundle_brand].blank?&& params[:bundle_style].blank?&&params[:bundle_make].blank?&&params[:bundle_location].blank?&&params[:bundle_category].blank?
      @bundles = Bundle.order(:updated_at)
    else

      unless params[:bundle_color].blank?
        @bundles = Bundle
        .where('lower(color) = ?',params[:bundle_color])
        .order(:updated_at)
      end
      unless params[:bundle_brand].blank?
        @bundles = Bundle
        .where('lower(brand) = ?',params[:bundle_brand])
        .order(:updated_at)
      end
      unless params[:bundle_style].blank?
        @bundles = Bundle
        .where('lower(style) = ?',params[:bundle_style])
        .order(:updated_at)
      end
      unless params[:bundle_make].blank?
        @bundles = Bundle
        .where('lower(make) = ?',params[:bundle_make])
        .order(:updated_at)

      end
      unless params[:bundle_category].blank?
        @bundles = Bundle
        .where('lower(category) = ?',params[:bundle_category])
        .order(:updated_at)
      end
      unless params[:bundle_location].blank?
        @bundles = Bundle
        .where('lower(location) = ?',params[:bundle_location])
        .order(:updated_at)
      end
    end

    if @bundles.length < 3
      @bundle_length = @bundles.length
    else
      @bundle_length = 3
    end

    @bundles_by_color    =   Bundle.select("lower(color) as color,max(id) as id").group("lower(color)").order(:color)
    @bundles_by_brand    =   Bundle.select("lower(brand) as brand,max(id) as id").group("lower(brand)").order(:brand)
    @bundles_by_style    =   Bundle.select("lower(style) as style,max(id) as id").group("lower(style)").order(:style)
    @bundles_by_make     =   Bundle.select("lower(make) as make,max(id) as id").group("lower(make)").order(:make)
    @bundles_by_category   = Bundle.select("lower(category) as category,max(id) as id").group("lower(category)").order(:category)
    @bundles_by_location   = Bundle.select("lower(location) as location,max(id) as id").group("lower(location)").order(:location)



    respond_to do |format|
      format.html # index_themes.html.erb

    end




  end

  # GET /shop/bundle/:bundle_id/:name
  def show_bundle

    number_of_enties = 5
    @bundle = Bundle.find(params[:id])
    @bundles_rand = Bundle.limit(number_of_enties*2).order("RANDOM()")

    @fb_og_image = @bundle.image_name.url.to_s
    @fb_og_title = @bundle.name.to_s
    @fb_og_description = @bundle.description.to_s
    #@fb_app_id = 330390967090243.to_s
    @fb_app_id = ENV["ROOMS_FACEBOOK_APP_ID"].to_s
    @fb_url = root_url.to_s + 'shop/bundle/' + @bundle.id.to_s+'/'+get_clean_name(@bundle.name.to_s)

    if @bundles_rand.length < number_of_enties
      @bundle_length = @bundles_rand.length
    else
      @bundle_length = number_of_enties
    end

    respond_to do |format|
      format.html # shop_items_design.html.erb
    end

  end

  # GET /shop/entire_rooms
  def index_entire_rooms

    # when is not filter(all filter blank, it should get all the themes
    if params[:bundle_color].blank? && params[:bundle_brand].blank?&& params[:bundle_style].blank?&&params[:bundle_make].blank?&&params[:bundle_location].blank?&&params[:bundle_category].blank?
      @bundles = Bundle.order(:updated_at)
    else

      unless params[:bundle_color].blank?
        @bundles = Bundle
        .where('lower(color) = ?',params[:bundle_color])
        .order(:updated_at)
      end
      unless params[:bundle_brand].blank?
        @bundles = Bundle
        .where('lower(brand) = ?',params[:bundle_brand])
        .order(:updated_at)
      end
      unless params[:bundle_style].blank?
        @bundles = Bundle
        .where('lower(style) = ?',params[:bundle_style])
        .order(:updated_at)
      end
      unless params[:bundle_make].blank?
        @bundles = Bundle
        .where('lower(make) = ?',params[:bundle_make])
        .order(:updated_at)

      end
      unless params[:bundle_category].blank?
        @bundles = Bundle
        .where('lower(category) = ?',params[:bundle_category])
        .order(:updated_at)
      end
      unless params[:bundle_location].blank?
        @bundles = Bundle
        .where('lower(location) = ?',params[:bundle_location])
        .order(:updated_at)
      end
    end

    if @bundles.length < 3
      @bundle_length = @bundles.length
    else
      @bundle_length = 3
    end

    @bundles_by_color    =   Bundle.select("lower(color) as color,max(id) as id").group("lower(color)").order(:color)
    @bundles_by_brand    =   Bundle.select("lower(brand) as brand,max(id) as id").group("lower(brand)").order(:brand)
    @bundles_by_style    =   Bundle.select("lower(style) as style,max(id) as id").group("lower(style)").order(:style)
    @bundles_by_make     =   Bundle.select("lower(make) as make,max(id) as id").group("lower(make)").order(:make)
    @bundles_by_category   = Bundle.select("lower(category) as category,max(id) as id").group("lower(category)").order(:category)
    @bundles_by_location   = Bundle.select("lower(location) as location,max(id) as id").group("lower(location)").order(:location)



    respond_to do |format|
      format.html # index_themes.html.erb

    end


  end
  # GET /shop/entire_room/:id/name
  def show_entire_room

    number_of_enties = 5
    @bundle = Bundle.find(params[:id])
    @bundles_rand = Bundle.limit(number_of_enties*2).order("RANDOM()")

    @fb_og_image = @bundle.image_name.url.to_s
    @fb_og_title = @bundle.name.to_s
    @fb_og_description = @bundle.description.to_s
    #@fb_app_id = 330390967090243.to_s
    @fb_app_id = ENV["ROOMS_FACEBOOK_APP_ID"].to_s
    @fb_url = root_url.to_s + 'shop/entire_room/' + @bundle.id.to_s+'/'+get_clean_name(@bundle.name.to_s)

    if @bundles_rand.length < number_of_enties
      @bundle_length = @bundles_rand.length
    else
      @bundle_length = number_of_enties
    end

    respond_to do |format|
      format.html # shop_items_design.html.erb
    end


  end

  # GET /shop/bookmarks
  def index_bookmarks

    # when is not filter(all filter blank, it should get all the themes
    @bookmarks = Bookmark.order(:updated_at)


    if @bookmarks.length < 4
      @bookmark_length = @bookmarks.length
    else
      @bookmark_length = 4
    end
    respond_to do |format|
      format.html # index_themes.html.erb
    end



  end

  # GET /shop/bookmark/:id/name
  def show_bookmark

    number_of_enties = 5
    @bookmark = Bookmark.find(params[:id])
    @bookmark_rand = Bookmark.limit(number_of_enties*2).order("RANDOM()")

    @fb_og_image = @bookmark.image_name_desc.url.to_s
    @fb_og_title = @bookmark.title.to_s
    @fb_og_description = @bookmark.description.to_s
    @fb_app_id = ENV["ROOMS_FACEBOOK_APP_ID"].to_s
    @fb_url = root_url.to_s + 'shop/bookmark/' + @bookmark.id.to_s+'/'+get_clean_name(@bookmark.title.to_s)

    if @bookmark_rand.length < number_of_enties
      @bookmark_length = @bookmark_rand.length
    else
      @bookmark_length = number_of_enties
    end

    respond_to do |format|
      format.html # shop_items_design.html.erb
    end


  end




  #***********************************
  # Json methods for the room users
  #***********************************







end
