class FriendsController < ApplicationController

  #***********************************
  # Json methods
  #***********************************

  #POST create a friend from friend request
  #step 1.- delete the request. 2.- create a two row for friends, to connect all the friend of the user
  # eg  user_id_accept = 11  user_id_request = 99  ---, row1 -> (11,99)  row2 ->(99,11)
  #'/friends/json/create_friend_by_user_id_accept_and_user_id_request/:user_id_accept/:user_id_request'
  #/friends/json/create_friend_by_user_id_accept_and_user_id_request/11/99.json
  # Return head
  # success    ->  head  201 Create
def json_create_friend_by_user_id_accept_and_user_id_request

    respond_to do |format|
      #validation of the users
      if User.exists?(id:params[:user_id_accept])
        if User.exists?(id:params[:user_id_request])

          if FriendRequest.exists?(user_id:params[:user_id_request],user_id_requested:params[:user_id_accept])

            @friend_request = FriendRequest.find_by_user_id_and_user_id_requested(params[:user_id_request],params[:user_id_accept])

            @user_friend_accept = Friend.new(user_id:params[:user_id_accept],user_id_friend:params[:user_id_request])
            @user_friend_request = Friend.new(user_id:params[:user_id_request],user_id_friend:params[:user_id_accept])

            ActiveRecord::Base.transaction do
             begin
                @friend_request.destroy unless @friend_request.nil?
                @user_friend_request.save
                @user_friend_accept.save

                format.json { render json: {user_friend_request: @user_friend_request,
                                            user_friend_accept: @user_friend_accept}, status: :created }

             rescue ActiveRecord::StatementInvalid
                format.json { render json: 'failure to create friends', status: :unprocessable_entity }
                raise ActiveRecord::Rollback
              end

            end

          else
            format.json { render json: 'not found the user friend request ', status: :not_found }
          end

        else
          format.json { render json:'not found user_id_requested ',status: :not_found }
        end
      else
        format.json { render json:'not found user_id ',status: :not_found }
      end
    end

  end


#DELETE delete the two row for the Friend connection
#'/friends/json/destroy_friend_by_user_id_and_user_id_friend/:user_id/:user_id_friend'
#/friends/json/destroy_friend_by_user_id_and_user_id_friend/11/99.json
# Return head
# success    ->  head  204 No content
# 'nothing to destroy '    ->  head  200 OK

def json_destroy_friend_by_user_id_and_user_id_friend

  respond_to do |format|
    #validation of the users
    #User.where('id = ? or id = ?',params[:user_id],params[:user_id_friend] )
    if User.exists?(id:params[:user_id])
      if User.exists?(id:params[:user_id_friend])

        if (Friend.exists?(user_id:params[:user_id],user_id_friend:params[:user_id_friend]) or
           Friend.exists?(user_id:params[:user_id_friend],user_id_friend:params[:user_id]))


          @friend_1 = Friend.find_by_user_id_and_user_id_friend(params[:user_id],params[:user_id_friend])
          @friend_2 = Friend.find_by_user_id_and_user_id_friend(params[:user_id_friend],params[:user_id])

          ActiveRecord::Base.transaction do
            begin

              @friend_1.destroy unless @friend_1.nil?
              @friend_2.destroy unless @friend_2.nil?

              format.json { head :no_content }

            rescue ActiveRecord::StatementInvalid
              format.json { render json: 'failure to destroy friends', status: :unprocessable_entity }
              raise ActiveRecord::Rollback
            end

          end

        else
          format.json { render json: 'nothing to destroy   ', status: :ok }
        end

      else
        format.json { render json:'not found user_id friend ',status: :not_found }
      end
    else
      format.json { render json:'not found user_id ',status: :not_found }
    end
  end

end


end
