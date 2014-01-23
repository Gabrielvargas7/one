class StaticContentsController < ApplicationController

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


  # GET /static_contents
  # GET /static_contents.json
  def index
    @static_contents = StaticContent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @static_contents }
    end
  end

  # GET /static_contents/1
  # GET /static_contents/1.json
  def show
    @static_content = StaticContent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @static_content }
    end
  end

  # GET /static_contents/new
  # GET /static_contents/new.json
  def new
    @static_content = StaticContent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @static_content }
    end
  end

  # GET /static_contents/1/edit
  def edit
    @static_content = StaticContent.find(params[:id])
  end

  # POST /static_contents
  # POST /static_contents.json
  def create

    params[:static_content][:name] = get_clean_name(params[:static_content][:name])

    @static_content = StaticContent.new(params[:static_content])

    respond_to do |format|
      if @static_content.save
        format.html { redirect_to @static_content, notice: 'Static content was successfully created.' }
        format.json { render json: @static_content, status: :created, location: @static_content }
      else
        format.html { render action: "new" }
        format.json { render json: @static_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /static_contents/1
  # PUT /static_contents/1.json
  def update
    @static_content = StaticContent.find(params[:id])

    params[:static_content][:name] = get_clean_name(params[:static_content][:name])

    respond_to do |format|
      if @static_content.update_attributes(params[:static_content])
        format.html { redirect_to @static_content, notice: 'Static content was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @static_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /static_contents/1
  # DELETE /static_contents/1.json
  def destroy
    #@static_content = StaticContent.find(params[:id])
    #@static_content.destroy
    #
    #respond_to do |format|
    #  format.html { redirect_to static_contents_url }
    #  format.json { head :no_content }
    #end
  end


  #***********************************
  # Json methods for the room users
  #***********************************


  # Get all static content
  # GET 'static_contents/json/index_static_contents'
  #     'static_contents/json/index_static_contents.json'
  #Return head 200 OK
  def json_index_static_contents

    @static_contents = StaticContent.all
    respond_to do |format|

      format.json { render json: @static_contents }
    end
  end


  # Get a static content by name
  # GET 'static_contents/json/show_static_content_by_name/:name'
  #     'static_contents/json/show_static_content_by_name/:name.json'
  #Return head 200 OK
  def json_show_static_content_by_name

    @static_content = StaticContent.find_by_name(params[:name])
    respond_to do |format|
      format.json { render json: @static_content }
    end
  end



end
