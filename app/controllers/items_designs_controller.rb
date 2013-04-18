class ItemsDesignsController < ApplicationController
  # GET /items_designs
  # GET /items_designs.json
  def index

    #@items_designs = ItemsDesign.paginate(page: params[:page], :per_page => 22)
    @items_designs = ItemsDesign.paginate(page: params[:page])

    #@items_designs = ItemsDesign.all
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @items_designs }
    #end
  end

  # GET /items_designs/1
  # GET /items_designs/1.json
  def show
    @items_design = ItemsDesign.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @items_design }
    end
  end

  # GET /items_designs/new
  # GET /items_designs/new.json
  def new
    @items_design = ItemsDesign.new
    @items_design_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @items_design }
    end
  end

  # GET /items_designs/1/edit
  def edit
    @items_design = ItemsDesign.find(params[:id])
    @items_design_show_id = ItemsDesign.find(params[:id])
  end

  # POST /items_designs
  # POST /items_designs.json
  def create
    @items_design = ItemsDesign.new(params[:items_design])

    respond_to do |format|
      if @items_design.save
        format.html { redirect_to @items_design, notice: 'Items design was successfully created.' }
        format.json { render json: @items_design, status: :created, location: @items_design }
      else
        format.html { render action: "new" }
        format.json { render json: @items_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /items_designs/1
  # PUT /items_designs/1.json
  def update
    @items_design = ItemsDesign.find(params[:id])

    respond_to do |format|
      if @items_design.update_attributes(params[:items_design])
        format.html { redirect_to @items_design, notice: 'Items design was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @items_design.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items_designs/1
  # DELETE /items_designs/1.json
  def destroy
    @items_design = ItemsDesign.find(params[:id])
    @items_design.destroy

    respond_to do |format|
      format.html { redirect_to items_designs_url }
      format.json { head :no_content }
    end
  end
end
