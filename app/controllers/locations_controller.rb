class LocationsController < ApplicationController

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


  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.order(:id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/new
  # GET /locations/new.json
  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.json
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    #@location = Location.find(params[:id])
    #@location.destroy
    #
    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end



    # GET /locations/json/show_location_by_location_id/1.json
  def json_show_location_by_location_id
      @location = Location.find(params[:location_id])

      respond_to do |format|
        format.json { render json: @location }
      end
  end
end