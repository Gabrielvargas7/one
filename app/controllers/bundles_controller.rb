class BundlesController < ApplicationController
  # GET /bundles
  # GET /bundles.json
  def index

    #@bundles = Bundle.paginate(page: params[:page], :per_page => 10)
    #@bundles = Bundle.paginate(page: params[:page]).order('id')

    @bundles = Bundle.all

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


  #***********************************
  # Json methods for the room users
  #***********************************


  # GET Get all bundles
  # /bundles/json/index_bundles
  # /bundles/json/index_bundles.json
  #Return head
  #success    ->  head  200 OK

  def json_index_bundles

    @bundles = Bundle.order(:id)
    respond_to do |format|
      format.json { render json: @bundles.as_json(only:[:id,:description, :image_name, :name, :theme_id] )

      }
    end

  end
end
