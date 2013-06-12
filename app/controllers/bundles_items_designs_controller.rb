class BundlesItemsDesignsController < ApplicationController
  # GET /bundles_items_designs
  # GET /bundles_items_designs.json
  def index
    @bundles_items_designs = BundlesItemsDesign.order('bundle_id,items_designs.item_id ').
        joins('LEFT OUTER JOIN items_designs ON items_designs.id = bundles_items_designs.items_design_id')

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
    @bundles_items_design = BundlesItemsDesign.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bundles_items_design }
    end
  end

  # GET /bundles_items_designs/1/edit
  def edit
    @bundles_items_design = BundlesItemsDesign.find(params[:id])
  end

  # POST /bundles_items_designs
  # POST /bundles_items_designs.json
  def create
    @bundles_items_design = BundlesItemsDesign.new(params[:bundles_items_design])

    respond_to do |format|
      if @bundles_items_design.save
        format.html { redirect_to @bundles_items_design, notice: 'Bundles items design was successfully created.' }
        format.json { render json: @bundles_items_design, status: :created, location: @bundles_items_design }
      else
        format.html { render action: "new" }
        format.json { render json: @bundles_items_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bundles_items_designs/1
  # PUT /bundles_items_designs/1.json
  def update
    @bundles_items_design = BundlesItemsDesign.find(params[:id])

    respond_to do |format|
      if @bundles_items_design.update_attributes(params[:bundles_items_design])
        format.html { redirect_to @bundles_items_design, notice: 'Bundles items design was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bundles_items_design.errors, status: :unprocessable_entity }
      end
    end
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
end
