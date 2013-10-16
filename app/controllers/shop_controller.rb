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

  # GET /shop/1
  # GET /shop/1.json
  def show

    # when is not filter(all filter blank, it should get all the items
    if params[:item_color].blank? && params[:item_brand].blank?&& params[:item_style].blank?&&params[:item_make].blank?
      @items_designs = ItemsDesign.where("item_id = ?",params[:id]).order(:updated_at)
    else

      unless params[:item_color].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:id])
        .where('lower(color) = ?',params[:item_color])
        .order(:updated_at)
      end
      unless params[:item_brand].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:id])
        .where('lower(brand) = ?',params[:item_brand])
        .order(:updated_at)
      end
      unless params[:item_style].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:id])
        .where('lower(style) = ?',params[:item_style])
        .order(:updated_at)
      end
      unless params[:item_make].blank?
        @items_designs = ItemsDesign.where("item_id = ?",params[:id])
        .where('lower(make) = ?',params[:item_make])
        .order(:updated_at)
      end

    end

    if @items_designs.length < 3
      @item_length = @items_designs.length
    else
      @item_length = 3
    end

    @items_by_type = Item.order(:id).all
    @items_designs_by_color = ItemsDesign.select("lower(color) as color,max(item_id) as item_id").where("item_id = ?",params[:id]).group("lower(color)").order(:color)
    @items_designs_by_brand  = ItemsDesign.select("lower(brand) as brand,max(item_id) as item_id").where("item_id = ?",params[:id]).group("lower(brand)").order(:brand)
    @items_designs_by_style  = ItemsDesign.select("lower(style) as style,max(item_id) as item_id").where("item_id = ?",params[:id]).group("lower(style)").order(:style)
    @items_designs_by_make  = ItemsDesign.select("lower(make) as make,max(item_id) as item_id").where("item_id = ?",params[:id]).group("lower(make)").order(:make)


    respond_to do |format|
      format.html # show.html.erb

    end
  end

  # GET /shop/show/items-design/:items_design_id
  def shop_show_items_design

    @items_design = ItemsDesign.find(params[:items_design_id])
    @items_designs_rand = ItemsDesign.where('item_id = ?',@items_design.item_id).limit(6).order("RANDOM()")

    @fb_og_image = @items_design.image_name_selection.url.to_s
    @fb_og_title = @items_design.name.to_s
    @fb_og_description = @items_design.description.to_s
    @fb_app_id = 330390967090243.to_s
    @fb_url = root_url.to_s + 'shop/show/items-design/' + @items_design.id.to_s
    #get root url, then chop it with / , then get base


    if @items_designs_rand.length < 3
      @item_length = @items_designs_rand.length
    else
      @item_length = 3
    end


    respond_to do |format|
      format.html # shop_show_items_design.html.erb

    end
  end


end
