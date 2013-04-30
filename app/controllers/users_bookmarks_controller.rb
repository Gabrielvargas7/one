class UsersBookmarksController < ApplicationController


  #***********************************
  # Json methods for the room users
  #***********************************



  # POST Create new user's bookmark with position
  #/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/:user_id/:bookmark_id/:item_id
  #/users_bookmarks/json/create_user_bookmark_by_user_id_and_bookmark_id_and_item_id/10000111/101/1.json
  # Form Parameters:
  #               position
  def json_create_user_bookmark_by_user_id_and_bookmark_id_and_item_id

    respond_to do |format|
        #validation of the user_id
        #validation of the bookmark_id and item_id
        #validation of the position

        if User.exists?(id: params[:user_id])

          if Bookmark.exists?(id: params[:bookmark_id],item_id:params[:item_id])

              if UsersBookmark.joins(:bookmark).where('user_id = ? and item_id = ? and position = ?',params[:user_id],params[:item_id],params[:position]).exists?
                 format.json { render json: 'the position of the bookmark already exists' , status: :conflict }
              else
                if UsersBookmark.create!(user_id:params[:user_id],bookmark_id:params[:bookmark_id],position:params[:position])
                    format.json { head :no_content }
                else
                   format.json { render json: 'can not create the new bookmark for the user' , status: :internal_server_error }
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

  def json_destroy_user_bookmark_by_user_id_and_by_bookmark_id_and_position


    respond_to do |format|

        if UsersBookmark.where('user_id = ? and bookmark_id = ? and position = ? ',params[:user_id],params[:bookmark_id],params[:position]).exists?

            @user_bookmark = UsersBookmark.find_by_user_id_and_bookmark_id_and_position(params[:user_id],params[:bookmark_id],params[:position])
            if @user_bookmark.destroy
                format.json { head :no_content }
            else
              format.json { render json: 'can not delete' , status: :internal_server_error }
            end
        else
          format.json { render json: 'user id and bookmark id and position not found' , status: :not_found }
        end


    end

  end


  # GET get all user's Bookmarks
  # users_bookmarks/json/json_index_user_bookmarks_by_user_id/:user_id'
  # users_bookmarks/json/json_index_user_bookmarks_by_user_id/1.json'

  def json_index_user_bookmarks_by_user_id

    respond_to do |format|

      if UsersBookmark.exists?(user_id: params[:user_id])

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title,position').
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

  def json_index_user_bookmarks_by_user_id_and_item_id

  respond_to do |format|

      if Bookmark.joins(:users_bookmarks).where('user_id = ? and item_id = ?',params[:user_id],params[:item_id]).exists?

        @user_bookmarks = Bookmark.
            select('bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title,position').
            joins(:users_bookmarks).
            where('user_id = ? and item_id = ?',params[:user_id],params[:item_id] )

          format.json { render json: @user_bookmarks }
      else
        format.json { render json: 'not found user_id and item id' , status: :not_found }
      end
  end

end


end
