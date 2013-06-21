class SearchesController < ApplicationController

  before_filter :json_signed_in_user,
                only:[
                    :json_index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword

                ]

  before_filter :json_correct_user,
                only:[
                    :json_index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword
                ]






  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get user that was found by the keyword with limit and offset
  # Limit is the number of user that you want it
  # Offset is where you want to start
  # /searches/json/index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword/:user_id/:limit/:offset/:keyword
  # /searches/json/index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword/206/10/0/gabriel var.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword

    respond_to do |format|
        if params[:keyword]

          keyword = params[:keyword]
          keyword.downcase!

         # limit the length of the string to avoid injection
         if keyword.length < 12

           @user = User.
               select('id,name,image_name').
               where('lower(name) LIKE ? and id != ?', "%#{keyword}%",params[:user_id]).
               limit(params[:limit]).
               offset(params[:offset])



           @search = Hash.new
           @user.each  do |i|



             @search[i.id] = Hash.new()
             @search[i.id]['user'] = i
             @search[i.id]['friend'] = Friend.select('user_id').where(user_id:params[:user_id],user_id_friend: i.id)
             @search[i.id]['request'] = FriendRequest.select('user_id').where(user_id:params[:user_id],user_id_requested: i.id)
             @search[i.id]['requested'] = FriendRequest.select('user_id').where(user_id_requested:params[:user_id],user_id: i.id)
           end

           format.json { render json: @search

           }

         else
           @user = nil
           format.json { render json: @user }
         end
        else
          @user = nil
          format.json { render json: @user }
        end
    end
  end



end
