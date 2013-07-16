class BundlesController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                      :active_update
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
                      :active_update
                ]

  # GET /bundles
  # GET /bundles.json
  def index

    #@bundles = Bundle.paginate(page: params[:page], :per_page => 10)
    #@bundles = Bundle.paginate(page: params[:page]).order('id')

    @bundles = Bundle.order('id').all

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

  # PUT /active_bundles/1
  # PUT /active_bundles/1.json
  def active_update
    respond_to do |format|
      if Bundle.exists?(id:params[:id])
        @bundle = Bundle.find(params[:id])

        if BundlesItemsDesign.exists?(bundle_id:params[:id])

          @bundle.active = 'y'
          if @bundle.save!
            format.html { redirect_to @bundle, notice: 'Bundle was successfully updated.' }
          else
            format.html { redirect_to @bundle, notice: 'something go wrong.' }
          end
        else
          format.html { redirect_to @bundle, notice:  "Bundle item design doesn't exist yet, you need to have a least one." }
        end
      else
        format.json { render json: @bundle.errors, status: :unprocessable_entity }

      end
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

  #public api

  def json_index_bundles

    @bundles = Bundle.where("active = 'y'").order(:id)
    respond_to do |format|
      format.json { render json: @bundles.as_json()

      }
    end

  end
end
