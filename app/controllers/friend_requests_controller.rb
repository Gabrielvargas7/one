class FriendRequestsController < ApplicationController


  before_filter :json_signed_in_user,
                only:[
                    :json_create_friend_request_by_user_id_and_user_id_requested,
                    :json_index_friend_request_make_from_your_friend_to_you_by_user_id,
                    :json_destroy_friend_request_by_user_id_and_user_id_that_make_request
                    ]


  before_filter :json_correct_user,
                only:[
                    :json_create_friend_request_by_user_id_and_user_id_requested,
                    :json_destroy_friend_request_by_user_id_and_user_id_that_make_request,
                    :json_index_friend_request_make_from_your_friend_to_you_by_user_id
                ]





  #***********************************
  # Json methods
  #***********************************


  #POST set a request for the friend
  # /friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/:user_id/:user_id_requested
  # /friend_requests/json/create_friend_request_by_user_id_and_user_id_requested/100001/999.json
  #Return
  #success          ->  head  201 create
  #already create  ->  head  200 OK

  def json_create_friend_request_by_user_id_and_user_id_requested

    respond_to do |format|

      #validation of the users
      if User.exists?(id:params[:user_id])
          if User.exists?(id:params[:user_id_requested])

            # validate if the user and requested exist
            if FriendRequest.exists?(user_id:params[:user_id],user_id_requested:params[:user_id_requested])

              format.json { render json:'already exist ',status: :ok }

            else
                @friend_request = FriendRequest.new(user_id:params[:user_id],user_id_requested:params[:user_id_requested])

                if @friend_request.save

                   #send a email
                   user = User.find(params[:user_id])
                   user_requested = User.find(params[:user_id_requested])
                   UsersMailer.friend_request_email(user,user_requested).deliver

                  format.json { render json: @friend_request, status: :created }
                else
                  format.json { render json: @friend_request.errors, status: :unprocessable_entity }
                end
            end

          else
            format.json { render json:'not found user_id_requested ',status: :not_found }
          end
      else
        format.json { render json:'not found user_id ',status: :not_found }
      end
    end
  end


  #DELETE if the user deny the request, it will be destroy
  # /friend_requests/json/destroy_friend_request_by_user_id_and_user_id_that_make_request/:user_id/:user_id_that_make_request
  # /friend_requests/json/destroy_friend_request_by_user_id_and_user_id_that_make_request/100001/999.json
  #Return head
  # success          ->  head  204 no content
  # already destroy  ->  head  200 OK
  def json_destroy_friend_request_by_user_id_and_user_id_that_make_request

    respond_to do |format|

      #validation of the users
      if User.exists?(id:params[:user_id])
        if User.exists?(id:params[:user_id_that_make_request])

          # validate if the user and requested exist
          if FriendRequest.exists?(user_id:params[:user_id_that_make_request],user_id_requested:params[:user_id])

            @friend_request = FriendRequest.find_by_user_id_and_user_id_requested(params[:user_id_that_make_request],params[:user_id])

            if @friend_request.destroy
                format.json { head :no_content }
            else
                format.json { render json: @friend_request.errors, status: :unprocessable_entity }
            end

          else
            format.json { render json:'already destroy ',status: :ok }
          end

        else
          format.json { render json:'not found user_id_requested ',status: :not_found }
        end
      else
        format.json { render json:'not found user_id ',status: :not_found }
      end
     end
  end


  #GET get all the request that your friends make to you
  #  /friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/:user_id
  #  /friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/206.json
  #  //# success    ->  head  200 OK
  def json_index_friend_request_make_from_your_friend_to_you_by_user_id

    respond_to do |format|

      if User.exists?(id:params[:user_id])

        @friend_requests = FriendRequest.where('user_id_requested = ?',params[:user_id])

        @user_friend_requested =
              UsersPhoto.select(
               'users_photos.user_id,
                users_photos.image_name,
                users_photos.profile_image,
                users_profiles.firstname,
                users_profiles.lastname,
                users.username'
              ).where(:user_id => @friend_requests.map {|b| b.user_id})
               .where("users_photos.profile_image = 'y'")
               .joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id')
              .joins('LEFT OUTER JOIN users  ON users.id = users_photos.user_id')
        format.json { render json: @user_friend_requested }

      else
        format.json { render json:'not found user_id ',status: :not_found }
      end
    end


  end







end
