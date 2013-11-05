class BundlesItemsDesignsController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                      :index_bundle_selection,
                      :index_items_location_selection,
                      :index_items_design_selection,
                      :create_bundle_items_design,
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
                      :index_bundle_selection,
                      :index_items_location_selection,
                      :index_items_design_selection,
                      :create_bundle_items_design,


                ]


  # GET /bundles_items_designs
  # GET /bundles_items_designs.json
  def index

    # when is not filter( it should get first
    if params[:bundle_id].blank?
       @bundle = Bundle.first
    else
       @bundle = Bundle.find(params[:bundle_id])
    end

    @bundles= Bundle.order(:id).all
    @bundles_items_designs = BundlesItemsDesign.order('bundle_id,items_designs.item_id ').
        joins('LEFT OUTER JOIN items_designs ON items_designs.id = bundles_items_designs.items_design_id').
        where('bundles_items_designs.bundle_id = ?',@bundle.id).
        paginate(page: params[:page],:per_page => 200)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bundles_items_designs }
    end
  end

  # GET /bundles_items_designs/1
  # GET /bundles_items_designs/1.json
  def show
    @bundles_items_design = BundlesItemsDesign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bundles_items_design }
    end
  end

  # GET /bundles_items_designs/new
  # GET /bundles_items_designs/new.json
  def new
    #@bundles_items_design = BundlesItemsDesign.new
    #
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @bundles_items_design }
    #end
  end

  # GET /bundles_items_designs/1/edit
  def edit
    #@bundles_items_design = BundlesItemsDesign.find(params[:id])
  end

  # POST /bundles_items_designs
  # POST /bundles_items_designs.json
  def create
    #@bundles_items_design = BundlesItemsDesign.new(params[:bundles_items_design])
    #
    #respond_to do |format|
    #  if @bundles_items_design.save
    #    format.html { redirect_to @bundles_items_design, notice: 'Bundles items design was successfully created.' }
    #    format.json { render json: @bundles_items_design, status: :created, location: @bundles_items_design }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @bundles_items_design.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PUT /bundles_items_designs/1
  # PUT /bundles_items_designs/1.json
  def update
    #@bundles_items_design = BundlesItemsDesign.find(params[:id])
    #
    #respond_to do |format|
    #  if @bundles_items_design.update_attributes(params[:bundles_items_design])
    #    format.html { redirect_to @bundles_items_design, notice: 'Bundles items design was successfully updated.' }
    #    format.json { head :no_content }
    #  else
    #    format.html { render action: "edit" }
    #    format.json { render json: @bundles_items_design.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /bundles_items_designs/1
  # DELETE /bundles_items_designs/1.json
  def destroy
    @bundles_items_design = BundlesItemsDesign.find(params[:id])
    @bundles_items_design.destroy

    respond_to do |format|
      format.html { redirect_to bundles_items_designs_url }
      format.json { head :no_content }
    end
  end

  # GET /index/bundle_selection
  # GET /index/bundle_selection.json
  def index_bundle_selection
    @bundles = Bundle.order(:id).all

    respond_to do |format|
      format.html # index_bundle_selection.html.erb
      format.json { render json: @bundles }
    end
  end

  # GET /index/items_location_selection/:bundle_id/:section_id
  # GET /index/items_location_selection/1/1.json
  def index_items_location_selection

    @items_locations = ItemsLocation.order(:section_id).where("locations.section_id = ?",params[:section_id]).joins(:location)
    @bundle = Bundle.find(params[:bundle_id])

    respond_to do |format|
      format.html # index_items_location_selection.html.erb
      format.json { render json: @items_location }
    end
  end


  # GET /index/items_location_selection/:bundle_id/:location_id/:item_id
  # GET /index/items_location_selection/1/1/1.json
  def index_items_design_selection
  #  past location_id, bundle_id and items_design_id

    @items_designs = ItemsDesign.find_all_by_item_id(params[:item_id])
    @bundle = Bundle.find(params[:bundle_id])
    @location = Location.find(params[:location_id])

    respond_to do |format|
      format.html # index_items_design_selection.html.erb
      format.json { render json: @items_designs }
    end
  end


  # POST /create_bundle_items_design/:bundle_id/:location_id/:items_design_id
  # POST /create_bundle_items_design.json
  def create_bundle_items_design

    #puts "bundle id --> "+params[:bundle_id]
    #puts "items_location id --> "+params[:location_id]
    #puts "items_design id --> "+params[:items_design_id]


    @bundles_items_design = BundlesItemsDesign.new(bundle_id:params[:bundle_id],location_id:params[:location_id],items_design_id:params[:items_design_id])

    respond_to do |format|
      if @bundles_items_design.save
        format.html { redirect_to @bundles_items_design, notice: 'Bundles items design was successfully created.' }
        format.json { render json: @bundles_items_design, status: :created, location: @bundles_items_design }
      else
        format.html { redirect_to bundles_items_designs_url, notice: "Error creating the bundle_item_design" }
        format.json { render json: @bundles_items_design.errors, status: :unprocessable_entity }
      end
    end



  end



end
