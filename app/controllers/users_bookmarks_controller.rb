
class UsersBookmarksController < ApplicationController


  before_filter :signed_in_user,
                only:[
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
                    :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
                    :json_index_user_bookmarks_by_user_id,
                    :json_index_user_bookmarks_by_user_id_and_item_id,
                    :json_create_user_bookmark_custom_by_user_id

                ]

  before_filter :json_correct_user,
                only:[
                    :json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id,
                    :json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position,
                    :json_index_user_bookmarks_by_user_id,
                    :json_index_user_bookmarks_by_user_id_and_item_id,
                    :json_create_user_bookmark_custom_by_user_id
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

          if Bookmark.exists?(id: params[:bookmark_id],item_id:params[:item_id])

              if UsersBookmark.joins(:bookmark).where('user_id = ? and item_id = ? and position = ?',params[:user_id],params[:item_id],params[:position]).exists?

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
  # users_bookmarks/json/json_index_user_bookmarks_by_user_id/:user_id'
  # users_bookmarks/json/json_index_user_bookmarks_by_user_id/1.json'
  #Return ->
  #Success    ->  head  200 OK

  def json_index_user_bookmarks_by_user_id

    respond_to do |format|

      if UsersBookmark.exists?(user_id: params[:user_id])

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title,position,"like"').
            joins(:users_bookmarks).
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

      if Bookmark.joins(:users_bookmarks).where('user_id = ? and item_id = ?',params[:user_id],params[:item_id]).exists?

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title,position,"like"').
            joins(:users_bookmarks).
            where('user_id = ? and item_id = ?',params[:user_id],params[:item_id] )

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
  #             :item_id,
  #             :title
  #             :position
  #Return ->
  #success    ->  head  200 ok

  def json_create_user_bookmark_custom_by_user_id

    respond_to do |format|
      #validation of the user_id
      #validation of the bookmark_id and item_id
      #validation of the position

      if User.exists?(id: params[:user_id])

        if BookmarksCategory.exists?(id: params[:bookmarks_category_id])

          if UsersBookmark.joins(:bookmark).where('user_id = ? and item_id = ? and position = ?',params[:user_id],params[:item_id],params[:position]).exists?

            format.json { render json: 'the position of the bookmark already exists' , status: :ok }
          else

            ActiveRecord::Base.transaction do
             begin
               @bookmark = Bookmark.new(title:params[:title],
                                        bookmark_url:params[:bookmark_url],
                                        bookmarks_category_id:params[:bookmarks_category_id],
                                        image_name:params[:image_name],
                                        item_id:params[:item_id],
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




end
