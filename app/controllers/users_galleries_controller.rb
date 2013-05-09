class UsersGalleriesController < ApplicationController

  #***********************************
  # Json methods for the room users
  #***********************************


  # POST insert user image
  #/users_galleries/json/create_users_gallery_by_user_id/:user_id
  #/users_galleries/json/create_users_gallery_by_user_id/206.json
  # Content-Type : multipart/form-data
  # Form Parameters:
  #               :image_name (full path)
  #Return ->
  #success    ->  head  201 create
  def json_create_users_gallery_by_user_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])

            @user_gallery = UsersGallery.new(user_id:params[:user_id],image_name:params[:image_name])

            if @user_gallery.save
              format.json { render json: @user_gallery, status: :created }
            else
              format.json { render json: @user_gallery.errors, status: :unprocessable_entity }
            end
      else
        format.json { render json: 'user not found' , status: :not_found }
      end

    end

  end


  #PUT set the default image = true
  #/users_galleries/json/update_users_gallery_default_image_by_user_id_and_users_gallery_id/:user_id/:users_gallery_id
  #/users_galleries/json/update_users_gallery_default_image_by_user_id_and_users_gallery_id/206/5.json

  #Return ->
  #success    ->  head  200 ok


  #def json_update_users_gallery_default_image_by_user_id_and_users_gallery_id
  #
  #  respond_to do |format|
  #    #validation of the user_id
  #
  #    if User.exists?(id: params[:user_id])
  #      if UsersGallery.exists?(id:params[:users_gallery_id],user_id:params[:user_id])
  #
  #        @user_gallery = UsersGallery.find(params[:users_gallery_id])
  #
  #        ActiveRecord::Base.transaction do
  #          begin
  #
  #            UsersGallery.where('user_id = ? and default_image = true',params[:user_id]).update_all(:default_image => false)
  #
  #            @user_gallery.update_attributes(default_image:true)
  #
  #            format.json { render json: @user_gallery, status: :ok }
  #
  #          rescue ActiveRecord::StatementInvalid
  #            format.json { render json: 'failure to create friends', status: :unprocessable_entity }
  #            raise ActiveRecord::Rollback
  #          end
  #        end
  #      else
  #         format.json { render json: 'user gallery id  not found' , status: :not_found }
  #      end
  #    else
  #      format.json { render json: 'user not found' , status: :not_found }
  #    end
  #
  #  end
  #
  #end



end
