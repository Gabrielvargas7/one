class BookmarksCategoriesController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create
                ]

  before_filter :json_signed_in_user,
                only:[

                ]

  before_filter :json_correct_user,
                only:[

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



  # GET /bookmarks_categories
  # GET /bookmarks_categories.json
  def index
    @bookmarks_categories = BookmarksCategory.order("item_id,id").all

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
    @bookmarks_category_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bookmarks_category }
    end
  end

  # GET /bookmarks_categories/1/edit
  def edit

    @bookmarks_category = BookmarksCategory.find(params[:id])
    @bookmarks_category_show_id = BookmarksCategory.find(params[:id])
    @bookmarks_categories_count = BookmarksCategory.where("item_id = ?",@bookmarks_category.item_id).count

    respond_to do |format|
    #  if @bookmarks_categories_count > 1
        format.html
      #else
      #  flash[:success] = "Sorry: a least one category must exist for item"
      #  format.html { redirect_to bookmarks_categories_url }
      #
      #end
    end

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

    @bookmarks_categories_count = BookmarksCategory.where("item_id = ?",@bookmarks_category.item_id).count

    respond_to do |format|
      if @bookmarks_categories_count > 1

            if @bookmarks_category.update_attributes(params[:bookmarks_category])
                format.html { redirect_to @bookmarks_category, notice: 'Bookmarks category was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @bookmarks_category.errors, status: :unprocessable_entity }
            end

      else
            if params[:bookmarks_category][:item_id].to_s == @bookmarks_category.item_id.to_s
              if @bookmarks_category.update_attributes(params[:bookmarks_category])
                  format.html { redirect_to @bookmarks_category, notice: 'Bookmarks category was successfully updated.' }
                  format.json { head :no_content }
              else
                  format.html { render action: "edit" }
                  format.json { render json: @bookmarks_category.errors, status: :unprocessable_entity }
              end

            else
                flash[:success] = "Sorry: a least one category must exist for item"
                format.html { redirect_to bookmarks_categories_url }
            end


      end
    end
  end

  # DELETE /bookmarks_categories/1
  # DELETE /bookmarks_categories/1.json
  def destroy
    # the category must have a least one category

    respond_to do |format|

      @bookmarks_category = BookmarksCategory.find(params[:id])

      @bookmarks_categories_count = BookmarksCategory.where("item_id = ?",@bookmarks_category.item_id).count

      # if the bookmark category have bookmarks, can no be destroy
      if @bookmarks_categories_count > 1
         #@bookmarks_category.destroy

         flash[:success] = "Destroy is successful"
         format.html { redirect_to bookmarks_categories_url }
      else
        flash[:success] = "Sorry: a least one category must exist for item"
        format.html { redirect_to bookmarks_categories_url }

      end


    end
  end

  #***********************************
  # Json methods
  #***********************************


  # GET Get all bookmarks category by item id
  # bookmarks_categories/json/index_bookmarks_categories_by_item_id/:item_id
  # bookmarks_categories/json/index_bookmarks_categories_by_item_id/1.json
  #Return head
  # success    ->  head  200 OK

  def json_index_bookmarks_categories_by_item_id

      respond_to do |format|

        if BookmarksCategory.exists?(item_id:params[:item_id])

          @bookmarks_categories =  BookmarksCategory.find_all_by_item_id(params[:item_id])

          format.json {render json:  @bookmarks_categories.as_json() }

        else
          #format.json { render json: 'not bookmark category for this item ', status: :no_content }
          format.json { render json:'[]'}
        end

      end
  end




end
