
class UsersBookmarksController < ApplicationController


  before_filter :signed_in_user,
                only:[
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
                    :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
                    :json_create_user_bookmark_custom_by_user_id ,
                    :json_show_user_bookmark_by_user_id_and_bookmark_id


                ]

  before_filter :json_correct_user,
                only:[
                    :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
                    :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
                    :json_create_user_bookmark_custom_by_user_id,
                    :json_show_user_bookmark_by_user_id_and_bookmark_id
                ]


  before_filter :correct_user, only:[]
  before_filter :admin_user, only:[]



  #***********************************
  # Json methods for the room users
  #***********************************


  # POST Create new user's bookmark with position
  #/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/:user_id/:bookmark_id/:item_id
  #/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/10000111/101/1.json
  # Form Parameters:
  #               :position
  #Return ->
  #success    ->  head  201 create
  #'already exist'    ->  head  200 ok

  def json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id


    respond_to do |format|
        #validation of the user_id
        #validation of the bookmark_id and item_id
        #validation of the position

        if User.exists?(id: params[:user_id])

          if Bookmark.
              joins(:bookmarks_category).
              where('bookmarks.id = ? and bookmarks_categories.item_id in (0,?)', params[:bookmark_id],params[:item_id]).exists?

              if UsersBookmark.
                  joins(:bookmark).
                  joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
                  where('user_id = ? and bookmarks_categories.item_id = ? and position = ?',params[:user_id],params[:item_id],params[:position]).exists?

                 format.json { render json: 'the position of the bookmark already exists' , status: :ok }

              else

                @user_bookmark = UsersBookmark.new(user_id:params[:user_id],bookmark_id:params[:bookmark_id],position:params[:position])

                if @user_bookmark.save
                    format.json { render json: @user_bookmark, status: :created }
                else
                    format.json { render json: @user_bookmark.errors, status: :unprocessable_entity }
                end

              end
          else
            format.json { render json: 'bookmark and items not found' , status: :not_found }
          end
        else
          format.json { render json: 'user not found' , status: :not_found }
        end

    end

  end


  # DELETE delete user bookmark
  #/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/:user_id/:bookmark_id/:position
  #/users_bookmarks/json/destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position/10000111/101/1.json
  #Return ->
  #success    ->  head  204 No Content
  #already destroy  ->  head  201 ok

  def json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position


    respond_to do |format|

        if UsersBookmark.where('user_id = ? and bookmark_id = ? and position = ? ',params[:user_id],params[:bookmark_id],params[:position]).exists?

            @user_bookmark = UsersBookmark.find_by_user_id_and_bookmark_id_and_position(params[:user_id],params[:bookmark_id],params[:position])
            if @user_bookmark.destroy
                format.json { head :no_content }
            else
              format.json { render json: @user_bookmark.errors , status: :internal_server_error }
            end
        else
          format.json { render json: 'already destroy' , status: :ok }
        end

    end

  end


  # GET get all user's Bookmarks
  # users_bookmarks/json_index_user_bookmarks_by_user_id/:user_id'
  # users_bookmarksjson_index_user_bookmarks_by_user_id/1.json'
  #Return ->
  #Success    ->  head  200 OK

  def json_index_user_bookmarks_by_user_id

    respond_to do |format|

      if UsersBookmark.exists?(user_id: params[:user_id])

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? ',params[:user_id])

        format.json { render json: @user_bookmarks }

      else
        format.json { render json: 'not found user_id ' , status: :not_found }
      end
    end

  end


  # GET get all user's Bookmarks by item id
  # /users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id/:user_id/:item_id
  # /users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id/10000011/1.json
  #Return ->
  #Success    ->  head  200 OK

  def json_index_user_bookmarks_by_user_id_and_item_id

  respond_to do |format|

      if Bookmark.
          joins(:users_bookmarks).
          joins(:bookmarks_category).
          where('user_id = ? and bookmarks_categories.item_id = ?',params[:user_id],params[:item_id]).exists?

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? and bookmarks_categories.item_id = ?',params[:user_id],params[:item_id] )

          format.json { render json: @user_bookmarks }
      else
        format.json { render json: 'not found user_id and item id' , status: :not_found }
      end
  end

  end


  # POST create a custom bookmark, set all the values decode.
  #  /users_bookmarks/json/create_user_bookmark_custom_by_user_id/:user_id'
  #  /users_bookmarks/json/create_user_bookmark_custom_by_user_id/1000.json
  # Content-Type : multipart/form-data
  #  Form Parameters:
  #             :bookmark_url,
  #             :bookmarks_category_id,
  #             :image_name, (full path)
  #             :title
  #             :position
  #Return ->
  #success    ->  head  200 ok

  def json_create_user_bookmark_custom_by_user_id

    respond_to do |format|
      #validation of the user_id
      #validation of the bookmark_id
      #validation of the position

      if User.exists?(id: params[:user_id])

        if BookmarksCategory.exists?(id: params[:bookmarks_category_id])

          if UsersBookmark.
              joins(:bookmark).
              joins('inner join bookmarks_categories ON bookmarks_categories.id = bookmarks.bookmarks_category_id').
              where('user_id = ? and  bookmarks_categories.item_id = ? and position = ?',params[:user_id],params[:item_id],params[:position]).exists?

            format.json { render json: 'the position of the bookmark already exists' , status: :ok }
          else

            ActiveRecord::Base.transaction do
             begin
               @bookmark = Bookmark.new(title:params[:title],
                                        bookmark_url:params[:bookmark_url],
                                        bookmarks_category_id:params[:bookmarks_category_id],
                                        image_name:params[:image_name],
                                        approval:'n',
                                        i_frame:'y',
                                        user_bookmark:params[:user_id],
                                        like:1
               )
               @bookmark.save
               @user_bookmark = UsersBookmark.new(user_id:params[:user_id],bookmark_id:@bookmark.id,position:params[:position])
               @user_bookmark.save

               format.json { render json: {user_bookmark: @user_bookmark,
                                           bookmark: @bookmark}, status: :created }
             rescue
               format.json { render json: @user_bookmark.errors, status: :unprocessable_entity }
             end
            end
          end
        else
          format.json { render json: 'bookmark category and items not found' , status: :not_found }
        end
      else
        format.json { render json: 'user not found' , status: :not_found }
      end

    end

  end

  # GET get a bookmark of the user
  # /users_bookmarks/json/show_user_bookmark_by_user_id_and_bookmark_id/:user_id/:bookmark_id
  # /users_bookmarks/json/show_user_bookmark_by_user_id_and_bookmark_id/10000011/1.json
  #Return ->
  #Success    ->  head  200 OK

  def json_show_user_bookmark_by_user_id_and_bookmark_id

    respond_to do |format|

      if Bookmark.
          joins(:users_bookmarks).
          joins(:bookmarks_category).
          where('user_id = ? and bookmarks.id = ?',params[:user_id],params[:bookmark_id]).exists?

        @user_bookmark = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? and bookmarks.id = ?',params[:user_id],params[:bookmark_id]).first

        format.json { render json: @user_bookmark }
      else
        format.json { render json: 'not found user_id and bookmark id' , status: :not_found }
      end
    end

  end


  # GET get all user's Bookmarks by item id and limit and offset
  # /users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset/:user_id/:item_id/:limit/:offset
  # /users_bookmarks/json/index_user_bookmarks_by_user_id_and_item_id/10000011/1/10/0.json
  #Return ->
  #Success    ->  head  200 OK

  def json_index_user_bookmarks_by_user_id_and_item_id_by_limit_and_offset

    respond_to do |format|

      if Bookmark.
          joins(:users_bookmarks).
          joins(:bookmarks_category).
          where('user_id = ? and bookmarks_categories.item_id = ?',params[:user_id],params[:item_id]).exists?

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, bookmarks_categories.item_id, title,position,"like"').
            joins(:users_bookmarks).
            joins(:bookmarks_category).
            where('user_id = ? and bookmarks_categories.item_id = ?',params[:user_id],params[:item_id]).
            limit(params[:limit]).
            offset(params[:offset])

        format.json { render json: @user_bookmarks }
      else
        format.json { render json: 'not found user_id and item id' , status: :not_found }
      end
    end

  end





end
