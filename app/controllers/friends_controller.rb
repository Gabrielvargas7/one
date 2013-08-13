class FriendsController < ApplicationController

  before_filter :json_signed_in_user,
                only:[
                    :json_create_friend_by_user_id_accept_and_user_id_request,
                    :json_destroy_friend_by_user_id_and_user_id_friend,
                    :json_index_friend_by_user_id,
                    :json_index_friend_by_user_id_by_limit_by_offset,
                    :json_index_friends_suggestion_by_user_id_by_limit_by_offset

                ]


  before_filter :json_correct_user,
                only:[
                    :json_create_friend_by_user_id_accept_and_user_id_request,
                    :json_destroy_friend_by_user_id_and_user_id_friend,
                    :json_index_friend_by_user_id,
                    :json_index_friend_by_user_id_by_limit_by_offset,
                    :json_index_friends_suggestion_by_user_id_by_limit_by_offset

                ]


  #***********************************
  # Json methods
  #***********************************

    #POST create a friend from friend request
    #step 1.- delete the request. 2.- create a two row for friends, to connect all the friend of the user
    # eg  user_id_accept = 11  user_id_request = 99  ---, row1 -> (11,99)  row2 ->(99,11)
    #'/friends/json/create_friend_by_user_id_accept_and_user_id_request/:user_id/:user_id_request'
    #/friends/json/create_friend_by_user_id_accept_and_user_id_request/11/99.json
    # Return head
    # success    ->  head  201 Create
    def json_create_friend_by_user_id_accept_and_user_id_request

      respond_to do |format|
        #validation of the users
        if User.exists?(id:params[:user_id])
          if User.exists?(id:params[:user_id_request])

            if FriendRequest.exists?(user_id:params[:user_id_request],user_id_requested:params[:user_id])

              @friend_request = FriendRequest.find_by_user_id_and_user_id_requested(params[:user_id_request],params[:user_id])

              @user_friend_accept = Friend.new(user_id:params[:user_id],user_id_friend:params[:user_id_request])
              @user_friend_request = Friend.new(user_id:params[:user_id_request],user_id_friend:params[:user_id])

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
          if User.exists?(id:params[:user_id_friend])or
             UsersProfile.exists?(user_id:params[:user_id]) or
             UsersProfile.exists?(user_idid:params[:user_id_friend])

             if (Friend.exists?(user_id:params[:user_id],user_id_friend:params[:user_id_friend]) or
                Friend.exists?(user_id:params[:user_id_friend],user_id_friend:params[:user_id]))


              @friend_1 = Friend.find_by_user_id_and_user_id_friend(params[:user_id],params[:user_id_friend])
              @friend_2 = Friend.find_by_user_id_and_user_id_friend(params[:user_id_friend],params[:user_id])

              @user_profile_1 = UsersProfile.find_all_by_user_id(params[:user_id]).first
              @user_profile_2 = UsersProfile.find_all_by_user_id(params[:user_id_friend]).first


              ActiveRecord::Base.transaction do
                begin
                  @user_profile_1.friends_number -=1
                  @user_profile_2.friends_number -=1

                  @user_profile_1.save
                  @user_profile_2.save

                  @friend_1.destroy unless @friend_1.nil?
                  @friend_2.destroy unless @friend_2.nil?

                  #format.json { head :no_content }
                  format.json { render json: 'nothing to destroy   ', status: :ok }

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


  #GET get all user friend
  #  /friends/json/index_friend_by_user_id/:user_id'
  #  /friends/json/index_friend_by_user_id/206.json'
  #  //# success    ->  head  200 OK


    def json_index_friend_by_user_id
    respond_to do |format|


      if User.exists?(id:params[:user_id])

           @friends = Friend.where('user_id = ?',params[:user_id])
           #@user_friend =  User.select('id,name,image_name').where(:id => @friends.map {|b| b.user_id_friend})

           @user_friend =
               UsersPhoto.select(
               'users_photos.user_id,
                users_photos.image_name,
                users_photos.profile_image,
                users_profiles.firstname,
                users_profiles.lastname'
               ).where(:user_id => @friends.map {|b| b.user_id_friend})
               .where("users_photos.profile_image = 'y'")
               .joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id')

            format.json { render json: @user_friend }

      else
        format.json { render json:'not found user_id ',status: :not_found }
      end



    end
    end

    # GET get all user friend by limit and offset
    # Limit is the number of user that you want it
    # Offset is where you want to start
    #  /friends/json/index_friend_by_user_id_by_limit_by_offset/:user_id/:limit/:offset'
    #  /friends/json/index_friend_by_user_id_by_limit_by_offset/206/10/0.json'
    #  //# success    ->  head  200 OK
    def json_index_friend_by_user_id_by_limit_by_offset
      respond_to do |format|


        if User.exists?(id:params[:user_id])


          @friends = Friend.where('user_id = ?',params[:user_id]).limit(params[:limit]).offset(params[:offset])

          #@user_friend =  User.select('id,name,image_name').where(:id => @friends.map {|b| b.user_id_friend})

          @user_friend =
              UsersPhoto.select(
                  'users_photos.user_id,
                users_photos.image_name,
                users_photos.profile_image,
                users_profiles.firstname,
                users_profiles.lastname'
              ).where(:user_id => @friends.map {|b| b.user_id_friend})
              .where("users_photos.profile_image = 'y'")
              .joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id')

          format.json { render json: @user_friend }

          #format.json { render json: @friends }
          format.json { render json: @user_friend }

        else
          format.json { render json:'not found user_id ',status: :not_found }
        end



      end
    end





    # GET get all user friend by limit and offset
    # Limit is the number of user that you want it
    # Offset is where you want to start
    #  /friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/:user_id/:limit/:offset'
    #  /friends/json/index_friends_suggestion_by_user_id_by_limit_by_offset/206/10/0.json'
    #  //# success    ->  head  200 OK

  def json_index_friends_suggestion_by_user_id_by_limit_by_offset

    user_id = params[:user_id]
    limit   = params[:limit]
    offset  = params[:offset]

    respond_to do |format|

      if User.exists?(id:user_id)
            sql = "SELECT user_id_friend, count(user_id_friend) suggestion_friend
                    FROM friends
                    WHERE user_id  in (select user_id_friend from friends where user_id="+user_id.to_s+") and
                        user_id_friend not in (select user_id_friend from friends where user_id="+user_id.to_s+") and
                        user_id_friend not in ("+user_id.to_s+")
                    group by user_id_friend
                    order by suggestion_friend desc limit "+limit+" offset "+offset


              @suggestions = Friend.find_by_sql(sql)

              #@suggestions_friends = Array.new
              #
              #@suggestions.each  do |i|
              #  @suggestions_friends.push User.select('id,image_name,name').where(id:i.user_id_friend).as_json
              #
              #end

            @suggestions_friends =
                UsersPhoto.select(
                    'users_photos.user_id,
                users_photos.image_name,
                users_photos.profile_image,
                users_profiles.firstname,
                users_profiles.lastname'
                ).where(:user_id => @suggestions.map {|b| b.user_id_friend})
                .where("users_photos.profile_image = 'y'")
                .joins('LEFT OUTER JOIN users_profiles  ON users_profiles.user_id = users_photos.user_id')


              format.json { render json: @suggestions_friends }

      else
        format.json { render json:'not found user_id ',status: :not_found }
      end
    end



  end




end
