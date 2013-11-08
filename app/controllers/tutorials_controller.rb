class TutorialsController < ApplicationController

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


  # GET /tutorials
  # GET /tutorials.json
  def index
    @tutorials = Tutorial.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tutorials }
    end
  end

  # GET /tutorials/1
  # GET /tutorials/1.json
  def show
    @tutorial = Tutorial.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tutorial }
    end
  end

  # GET /tutorials/new
  # GET /tutorials/new.json
  def new
    @tutorial = Tutorial.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tutorial }
    end
  end

  # GET /tutorials/1/edit
  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  # POST /tutorials
  # POST /tutorials.json
  def create
    @tutorial = Tutorial.new(params[:tutorial])

    respond_to do |format|
      if @tutorial.save
        format.html { redirect_to @tutorial, notice: 'Tutorial was successfully created.' }
        format.json { render json: @tutorial, status: :created, location: @tutorial }
      else
        format.html { render action: "new" }
        format.json { render json: @tutorial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tutorials/1
  # PUT /tutorials/1.json
  def update
    @tutorial = Tutorial.find(params[:id])

    respond_to do |format|
      if @tutorial.update_attributes(params[:tutorial])
        format.html { redirect_to @tutorial, notice: 'Tutorial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tutorial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutorials/1
  # DELETE /tutorials/1.json
  def destroy
    #@tutorial = Tutorial.find(params[:id])
    #@tutorial.destroy
    #
    #respond_to do |format|
    #  format.html { redirect_to tutorials_url }
    #  format.json { head :no_content }
    #end
  end

  # Get tutorial by limit and offset
  # GET 'tutorials/json/index_tutorials_by_limit_and_offset/:limit/:offset'
  #     'tutorials/json/index_tutorials_by_limit_and_offset/10/0.json'
  #Return head 200 OK
  def json_index_tutorials_by_limit_and_offset

    @themes = Theme.order(:id).
        limit(params[:limit]).
        offset(params[:offset])

    respond_to do |format|
      format.json { render json: @themes }
    end
  end


end
