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
    # the category must have a least one category

    respond_to do |format|

      @bookmarks_category = BookmarksCategory.find(params[:id])

      @bookmarks_categories_count = BookmarksCategory.where("item_id = ?",@bookmarks_category.item_id).count

      if @bookmarks_categories_count > 1
         @bookmarks_category.destroy

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


  # GET Get all bookmarks category with bookmarks by item id
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
          format.json { render json: 'not bookmark category for this item ', status: :not_found }
        end

      end
  end

  # GET Get all bookmarks that has to be approved,
  #   eg. when that user add a new bookmark, the bookmark has to be approved for the administrator, and after that everybody can see it.
  #        but if is not approved, it will be delete
  # bookmarks_categories/json/index_bookmarks_categories_with_bookmarks_been_approved_by_user_id_and_by_item_id/:user_id/:item_id
  # bookmarks_categories/json/index_bookmarks_categories_with_bookmarks_been_approved_by_user_id_and_by_item_id/1/1.json
  #Return head
  # success    ->  head  200 OK

  #def json_index_bookmarks_categories_with_bookmarks_been_approved_by_user_id_and_by_item_id
  #
  #  respond_to do |format|
  #
  #    if User.exists?(id:params[:user_id])
  #
  #      if BookmarksCategory.exists?(item_id:params[:item_id])
  #
  #        @bookmarks_category  = BookmarksCategory.
  #                                includes(:bookmarks).
  #                                  where('bookmarks_categories.item_id = ? and bookmarks.approval in (0,?)', params[:item_id],params[:user_id])
  #        format.json {render json:@bookmarks_category.
  #                              as_json(include:
  #                                          {bookmarks: {only: [:id, :bookmark_url, :bookmarks_category_id, :description, :i_frame, :image_name, :image_name_desc, :item_id, :title]}}) }
  #
  #      else
  #        format.json { render json: 'not bookmark category for this item ', status: :not_found }
  #      end
  #    else
  #      format.json { render json: 'not user found', status: :not_found }
  #    end
  #  end
  #
  #
  #end
  #




end
