class ItemsLocationsController < ApplicationController
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


  # GET /items_locations
  # GET /items_locations.json
  def index
    @items_locations = ItemsLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items_locations }
    end
  end

  # GET /items_locations/1
  # GET /items_locations/1.json
  def show
    @items_location = ItemsLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @items_location }
    end
  end

  # GET /items_locations/new
  # GET /items_locations/new.json
  def new
    @items_location = ItemsLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @items_location }
    end
  end

  # GET /items_locations/1/edit
  def edit
    @items_location = ItemsLocation.find(params[:id])
  end

  # POST /items_locations
  # POST /items_locations.json
  def create
    @items_location = ItemsLocation.new(params[:items_location])

    respond_to do |format|

      #if @items_location.save
      #
      #  format.html { redirect_to @items_location, notice: 'Items location was successfully created.' }
      #  format.json { render json: @items_location, status: :created, location: @items_location }
      #else
      #  format.html { render action: "new" }
      #  format.json { render json: @items_location.errors, status: :unprocessable_entity }
      #end

      if ItemsDesign.exists?(item_id:@items_location.item_id)

        #ActiveRecord::Base.transaction do
        #begin

             if @items_location.save

                format.html { redirect_to @items_location, notice: 'Items location was successfully created.' }

             else
               format.html { render action: "new" }
             end

        #rescue ActiveRecord::StatementInvalid
        #  format.html { render action: "new" }
        #  raise ActiveRecord::Rollback
        #  end
        #end

      else
        format.html { render action: "new",notice: 'Error: you need to create a least one item design for the item element ' }
      end
    end
  end

  # PUT /items_locations/1
  # PUT /items_locations/1.json
  def update
    #@items_location = ItemsLocation.find(params[:id])

    respond_to do |format|
      if @items_location.update_attributes(params[:items_location])
        format.html { redirect_to @items_location, notice: 'Items location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @items_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items_locations/1
  # DELETE /items_locations/1.json
  def destroy
    #@items_location = ItemsLocation.find(params[:id])
    #@items_location.destroy

    respond_to do |format|
      format.html { redirect_to items_locations_url }
      format.json { head :no_content }
    end
  end
end
