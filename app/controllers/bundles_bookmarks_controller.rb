class BundlesBookmarksController < ApplicationController

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


  # GET /bundles_bookmarks
  # GET /bundles_bookmarks.json
  def index
    @bundles_bookmarks = BundlesBookmark.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bundles_bookmarks }
    end
  end

  # GET /bundles_bookmarks/1
  # GET /bundles_bookmarks/1.json
  def show
    @bundles_bookmark = BundlesBookmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bundles_bookmark }
    end
  end

  # GET /bundles_bookmarks/new
  # GET /bundles_bookmarks/new.json
  def new
    @bundles_bookmark = BundlesBookmark.new
    @bundles_bookmark_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bundles_bookmark }
    end
  end

  # GET /bundles_bookmarks/1/edit
  def edit
    @bundles_bookmark = BundlesBookmark.find(params[:id])
    @bundles_bookmark_show_id = BundlesBookmark.find(params[:id])
  end

  # POST /bundles_bookmarks
  # POST /bundles_bookmarks.json
  def create
    @bundles_bookmark = BundlesBookmark.new(params[:bundles_bookmark])

    respond_to do |format|
      if @bundles_bookmark.save
        format.html { redirect_to @bundles_bookmark, notice: 'Bundles bookmark was successfully created.' }
        format.json { render json: @bundles_bookmark, status: :created, location: @bundles_bookmark }
      else
        format.html { render action: "new" }
        format.json { render json: @bundles_bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bundles_bookmarks/1
  # PUT /bundles_bookmarks/1.json
  def update
    @bundles_bookmark = BundlesBookmark.find(params[:id])

    respond_to do |format|
      if @bundles_bookmark.update_attributes(params[:bundles_bookmark])
        format.html { redirect_to @bundles_bookmark, notice: 'Bundles bookmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bundles_bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bundles_bookmarks/1
  # DELETE /bundles_bookmarks/1.json
  def destroy

    @bundles_bookmark = BundlesBookmark.find(params[:id])
    @bundles_bookmark.destroy

    respond_to do |format|
      format.html { redirect_to bundles_bookmarks_url }
      format.json { head :no_content }
    end
  end
end
