class ItemsController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create
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



  # GET /items
  # GET /items.json
  def index

    #@items = Item.paginate(page: params[:page], :per_page => 10)
    #@items = Item.paginate(page: params[:page]).order('id')

    #@items = Item.order(:id).all
    @items = Item.order(:priority_order,:name).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
    @item_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  # GET /items/1/edit
  def edit

    @item = Item.find(params[:id])
    @item_show_id = Item.find(params[:id])
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    # sorry but not delete is not allow
    #@item = Item.find(params[:id])
    #@item.destroy

    respond_to do |format|
      format.html { redirect_to items_url }
      format.json { head :no_content }
    end
  end


  # GET Get random items_designs
  # /items/json/index_items.json
  # Return head
  # success    ->  head  200 OK

  def json_index_items

    respond_to do |format|
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

      format.json { render json: @items }

    end
  end


end


