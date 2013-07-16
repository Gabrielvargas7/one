class BookmarksController < ApplicationController
  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                      :index_bookmarks_approval,
                      :update_bookmarks_approval_for_a_user,
                      :update_bookmarks_approval_for_all_users
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id
                ]

  before_filter :json_correct_user,
                only:[
                    :json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id
                ]


  before_filter :admin_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                      :index_bookmarks_approval,
                      :update_bookmarks_approval_for_a_user,
                      :update_bookmarks_approval_for_all_users
                ]



  # GET /bookmarks
  # GET /bookmarks.json
  def index

    #@bookmarks = Bookmark.paginate(page: params[:page], :per_page => 30)
    #@bookmarks = Bookmark.paginate(page: params[:page]).order('id')


    @bookmarks = Bookmark.order("item_id","bookmarks_category_id").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookmarks }
    end
  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bookmark }
    end
  end

  # GET /bookmarks/new
  # GET /bookmarks/new.json
  def new
    @bookmark = Bookmark.new
    @bookmark_show_id = nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bookmark }
    end
  end

  # GET /bookmarks/1/edit
  def edit
    @bookmark = Bookmark.find(params[:id])
    @bookmark_show_id = Bookmark.find(params[:id])
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(params[:bookmark])

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully created.' }
        format.json { render json: @bookmark, status: :created, location: @bookmark }
      else
        format.html { render action: "new" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookmarks/1
  # PUT /bookmarks/1.json
  def update
    @bookmark = Bookmark.find(params[:id])

    respond_to do |format|

      if @bookmark.update_attributes(params[:bookmark])
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy

    #@bookmark = Bookmark.find(params[:id])
    #  @bookmark.destroy
    #
    #respond_to do |format|
    #  format.html { redirect_to bookmarks_url }
    #  format.json { head :no_content }
    #end
    #

    @bookmark = Bookmark.find(params[:id])
    @user_bookmark  =  UsersBookmark.find_by_user_id_and_bookmark_id(@bookmark.user_bookmark,@bookmark.id)

    respond_to do |format|
      ActiveRecord::Base.transaction do
        begin

          @bookmark.destroy
          @user_bookmark.destroy unless @user_bookmark.nil?
          format.html { redirect_to bookmarks_url }

        rescue ActiveRecord::StatementInvalid
          format.json { render json: 'failure to destroy bookmark', status: :unprocessable_entity }
          raise ActiveRecord::Rollback
        end

      end


    end
  end



    def index_bookmarks_approval

    @bookmarks = Bookmark.order("item_id","bookmarks_category_id").where("approval = 'n'")

    respond_to do |format|
      format.html  # index_bookmarks_approval.html.erb
      format.json { render json: @bookmarks }
    end
  end

  # PUT bookmark approve for a user the request
  def update_bookmarks_approval_for_a_user

    @bookmark = Bookmark.find(params[:bookmark_id])

    respond_to do |format|

      if @bookmark.update_attributes(approval: 'y')
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end

  end


  # PUT bookmark approve for all users,
  #NOTE: when the user_bookmark is 0, means that everybody can access this bookmark
  def update_bookmarks_approval_for_all_users

    @bookmark = Bookmark.find(params[:bookmark_id])

    respond_to do |format|

      if @bookmark.update_attributes(approval: 'y',user_bookmark: 0)
        format.html { redirect_to @bookmark, notice: 'Bookmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end

  end




  #***********************************
  # Json methods
  #***********************************


  # GET Get all bookmarks with bookmarks category by item id that are approval
  # bookmarks/json/index_bookmarks_with_bookmarks_category_by_item_id/:item_id
  # bookmarks/json/index_bookmarks_with_bookmarks_category_by_item_id/1.json
  # Return head
  # success    ->  head  200 OK

  def json_index_bookmarks_with_bookmarks_category_by_item_id

    respond_to do |format|

      if BookmarksCategory.exists?(item_id:params[:item_id])


        @bookmarks  = Bookmark.
            select('bookmarks.id,
                      bookmarks.item_id,
                      bookmarks_categories.name as bookmarks_category_name,
                      bookmark_url,
                      bookmarks_category_id,
                      description,
                      i_frame,
                      image_name,
                      image_name_desc,
                      title,
                      "like"').
            joins(:bookmarks_category).
            where('bookmarks.item_id = ? and user_bookmark = 0', params[:item_id]).order("bookmarks_category_id,bookmarks.id")

        format.json {render json:
                                @bookmarks.as_json()}

        format.json {render json: @bookmarks}


      else
        format.json { render json: 'not bookmark for this item ', status: :not_found }
      end

    end
  end


  #GET Get all bookmarks that has to be approved,
  #   eg. when that user add a new bookmark, the bookmark has to be approved for the administrator, and after that everybody can see it.
  #        but if it  was not approve, it will be delete
  #bookmarks/json/index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id/:user_id/:item_id
  #bookmarks/json/index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id/1/1.json
  #Return head
  #success    ->  head  200 OK



  def json_index_bookmarks_with_bookmarks_that_need_to_be_approve_by_user_id_and_by_item_id

    respond_to do |format|

      if User.exists?(id:params[:user_id])

        if BookmarksCategory.exists?(item_id:params[:item_id])



          @bookmarks  = Bookmark.
              select('bookmarks.id,
                      bookmarks.item_id,
                      bookmarks_categories.name as bookmarks_category_name,
                      bookmark_url,
                      bookmarks_category_id,
                      description,
                      i_frame,
                      image_name,
                      image_name_desc,
                      title,
                      "like"').
              joins(:bookmarks_category).
              where("bookmarks_categories.item_id = ? and bookmarks.user_bookmark in (0,?)", params[:item_id],params[:user_id]).order("bookmarks_category_id,bookmarks.id")


          format.json {render json:@bookmarks.as_json()}

        else
          format.json { render json: 'not bookmark category for this item ', status: :not_found }
        end
      else
        format.json { render json: 'not user found', status: :not_found }
      end
    end


  end





end
