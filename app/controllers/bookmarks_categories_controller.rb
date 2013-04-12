class BookmarksCategoriesController < ApplicationController
  # GET /bookmarks_categories
  # GET /bookmarks_categories.json
  def index
    @bookmarks_categories = BookmarksCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookmarks_categories }
    end
  end

  # GET /bookmarks_categories/1
  # GET /bookmarks_categories/1.json
  def show
    @bookmarks_category = BookmarksCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bookmarks_category }
    end
  end

  # GET /bookmarks_categories/new
  # GET /bookmarks_categories/new.json
  def new
    @bookmarks_category = BookmarksCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bookmarks_category }
    end
  end

  # GET /bookmarks_categories/1/edit
  def edit
    @bookmarks_category = BookmarksCategory.find(params[:id])
  end

  # POST /bookmarks_categories
  # POST /bookmarks_categories.json
  def create
    @bookmarks_category = BookmarksCategory.new(params[:bookmarks_category])

    respond_to do |format|
      if @bookmarks_category.save
        format.html { redirect_to @bookmarks_category, notice: 'Bookmarks category was successfully created.' }
        format.json { render json: @bookmarks_category, status: :created, location: @bookmarks_category }
      else
        format.html { render action: "new" }
        format.json { render json: @bookmarks_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookmarks_categories/1
  # PUT /bookmarks_categories/1.json
  def update
    @bookmarks_category = BookmarksCategory.find(params[:id])

    respond_to do |format|
      if @bookmarks_category.update_attributes(params[:bookmarks_category])
        format.html { redirect_to @bookmarks_category, notice: 'Bookmarks category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookmarks_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks_categories/1
  # DELETE /bookmarks_categories/1.json
  def destroy
    @bookmarks_category = BookmarksCategory.find(params[:id])
    @bookmarks_category.destroy

    respond_to do |format|
      format.html { redirect_to bookmarks_categories_url }
      format.json { head :no_content }
    end
  end
end
