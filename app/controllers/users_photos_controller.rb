class UsersPhotosController < ApplicationController

  before_filter :signed_in_user,
                  only:[:destroy,
                        :index,
                        :show,
                        :new,
                        :edit,
                        :update,
                        :create,
                        :index_users_photos_by_user_id,
                        :update_users_photos_profile_image_by_user_id_by_users_photo_id,
                        :create_users_photos_by_user_id,
                        :new_users_photos_by_user_id,
                        :destroy_users_photos_by_user_id_by_users_photo_id,
                        :edit_users_photos_by_user_id_by_users_photo_id,
                        :update_users_photos_by_user_id_by_users_photo_id

                  ]

  before_filter :json_signed_in_user,
                only:[
                    :json_create_users_photo_by_user_id,
                    :json_update_users_set_profile_image_by_user_id_and_users_photo_id

                ]

  before_filter :json_correct_user,
               only:[
                    :json_create_users_photo_by_user_id,
                    :json_update_users_set_profile_image_by_user_id_and_users_photo_id

                ]
  before_filter :correct_user_by_user_id, only:[
                    :index_users_photos_by_user_id,
                    :update_users_photos_profile_image_by_user_id_by_users_photo_id,
                    :create_users_photos_by_user_id,
                    :new_users_photos_by_user_id,
                    :destroy_users_photos_by_user_id_by_users_photo_id,
                    :edit_users_photos_by_user_id_by_users_photo_id,
                    :update_users_photos_by_user_id_by_users_photo_id
                ]


  before_filter :admin_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                ]




  # GET /users_photos
  # GET /users_photos.json
  def index
    @users_photos = UsersPhoto.all
    respond_to do |format|

      format.html # index.html.erb
      format.json { render json: @users_photos }
    end
  end




  # GET /users_photos/1
  # GET /users_photos/1.json
  def show
    @users_photo = UsersPhoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users_photo }
    end
  end

  # GET /users_photos/new
  # GET /users_photos/new.json
  def new
    @users_photo = UsersPhoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @users_photo }
    end
  end

  # GET /users_photos/1/edit
  def edit
    @users_photo = UsersPhoto.find(params[:id])
  end

  # POST /users_photos
  # POST /users_photos.json
  def create
    @users_photo = UsersPhoto.new(params[:users_photo])

    respond_to do |format|
      if @users_photo.save
        format.html { redirect_to @users_photo, notice: 'Users photo was successfully created.' }
        format.json { render json: @users_photo, status: :created, location: @users_photo }
      else
        format.html { render action: "new" }
        format.json { render json: @users_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users_photos/1
  # PUT /users_photos/1.json
  def update
    @users_photo = UsersPhoto.find(params[:id])

    respond_to do |format|
      if @users_photo.update_attributes(params[:users_photo])
        format.html { redirect_to @users_photo, notice: 'Users photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @users_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users_photos/1
  # DELETE /users_photos/1.json
  def destroy
    #@users_photo = UsersPhoto.find(params[:id])
    #@users_photo.destroy

    respond_to do |format|
      format.html { redirect_to users_photos_url }
      format.json { head :no_content }
    end
  end


  # GET /users_photos/edit_users_photos_by_user_id_by_users_photo_id/:user_id/:users_photo_id
  def edit_users_photos_by_user_id_by_users_photo_id

    respond_to do |format|
      if User.exists?(params[:user_id])
        @users_photo = UsersPhoto.find(params[:users_photo_id])
        format.html # edit_users_photos_by_user_id_by_users_photo_id.html.erb
      else
        format.html { redirect_to root_path  }
      end
    end
  end

  #POST /users_photos/update_users_photos_by_user_id_by_users_photo_id/:user_id/:users_photo_id
  def update_users_photos_by_user_id_by_users_photo_id

    respond_to do |format|
      if User.exists?(params[:user_id])
      @users_photo = UsersPhoto.find(params[:users_photo_id])
      @photo_user = User.find(@users_photo.user_id)

        if @users_photo.update_attributes(params[:users_photo])
          format.html { redirect_to index_users_photos_by_user_id_path(@photo_user.id), notice: 'Users photo was successfully edited' }
        else
          format.html { redirect_to index_users_photos_by_user_id_path(@photo_user.id), notice: 'Users photo can not be edited' }
        end
      else
        format.html { redirect_to root_path  }
      end

    end


  end

  # DELETE /users_photos/destroy_users_photos_by_user_id_by_users_photo_id/:user_id/:users_photo_id
  def destroy_users_photos_by_user_id_by_users_photo_id

    respond_to do |format|
      if User.exists?(params[:user_id])
        @users_photo = UsersPhoto.find(params[:users_photo_id])
        @photo_user = User.find(@users_photo.user_id)

        if @users_photo.profile_image == 'n'

          @users_photo.destroy
          format.html { redirect_to index_users_photos_by_user_id_path(@photo_user.id), notice: 'Users photo was successfully delete' }
        else
          format.html { redirect_to index_users_photos_by_user_id_path(@photo_user.id), notice: 'Users photo can not be delete ' }
        end
      else
        format.html { redirect_to root_path  }
      end
    end
  end


  # GET /users_photos/index_users_photos/:user_id
  def index_users_photos_by_user_id
    respond_to do |format|

      if User.exists?(params[:user_id])
          @users_photos = UsersPhoto.find_all_by_user_id(params[:user_id])
          @photos_user = User.find(params[:user_id])

          format.html #index_users_photos_by_user_id.html.erb

          if @users_photos.length < 3
            @photo_length = @users_photos.length
          else
            @photo_length = 3
          end

      else
        format.html { redirect_to root_path  }
      end
    end
  end


  # GET /users_photos/new_users_photos_by_user_id/user_id
  def new_users_photos_by_user_id

    respond_to do |format|
      if User.exists?(id: params[:user_id])
        @users_photo = UsersPhoto.new(user_id:params[:user_id])

        format.html # new_users_photos_by_user_id.html.erb

      else
        format.html { redirect_to root_path  }
      end

    end
  end



# PUT update set profile image
#/users_photos/update_users_photos_profile_image_by_user_id_by_users_photo_id/:user_id/:users_photo_id
#/users_photos/update_users_photos_profile_image_by_user_id_by_users_photo_id/30/400.json
#success    ->  head  200 ok

  def update_users_photos_profile_image_by_user_id_by_users_photo_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])
        if UsersPhoto.exists?(id: params[:users_photo_id])

          ActiveRecord::Base.transaction do
            begin
              UsersPhoto.where("user_id = ?",params[:user_id]).update_all("profile_image = 'n'")

              @users_photo = UsersPhoto.find(params[:users_photo_id])
              @users_photo.profile_image = 'y'
              @users_photo.save

              format.html { redirect_to index_users_photos_by_user_id_path(@users_photo.user_id), notice: 'Users photo was successfully updated.' }
            rescue ActiveRecord::StatementInvalid
              format.html { redirect_to index_users_photos_by_user_id_path(@users_photo.user_id),  notice: 'Sorry but it can not set your profile image.' }
              raise ActiveRecord::Rollback
            end
          end
        else
          format.html { redirect_to root_path  }
        end
      else
        format.html { redirect_to root_path  }
      end
    end
  end


# POST insert user image
#/users_photos/create_users_photos_by_user_id/:user_id
#/users_photos/create_users_photos_by_user_id/206.json
# Content-Type : multipart/form-data
# Form Parameters:
#  params[:users_photo])

  def create_users_photos_by_user_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])

        ActiveRecord::Base.transaction do
          begin
            @users_photo = UsersPhoto.new(params[:users_photo])
            @users_photo.profile_image = 'n'
            @users_photo.user_id = params[:user_id]

            @users_photo.save
            format.html { redirect_to index_users_photos_by_user_id_path(params[:user_id]), notice: 'Users photo was successfully add it.' }
          rescue ActiveRecord::StatementInvalid
            format.html { redirect_to index_users_photos_by_user_id_path(params[:user_id]),  notice: 'Sorry but can not upload the photo .' }
            raise ActiveRecord::Rollback
          end
        end

      else
        format.html { redirect_to root_path  }
      end
    end
  end





# POST insert user image
#/users_photos/json/create_users_photos_by_user_id/:user_id
#/users_photos/json/create_users_photos_by_user_id/206.json
# Content-Type : multipart/form-data
# Form Parameters:
#               :image_name (full path)
#               :description
#               :profile_image (y/n)
#Return ->
#success    ->  head  201 create

    def json_create_users_photo_by_user_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])

        ActiveRecord::Base.transaction do
          begin
            @users_photo = UsersPhoto.new(user_id:params[:user_id],image_name:params[:image_name],profile_image:params[:profile_image],description:params[:description])
            if params[:profile_image] = 'y'
               UsersPhoto.where("user_id = ?",params[:user_id]).update_all("profile_image = 'n'")
            end
            @users_photo.save
            format.json { render json: @users_photo, status: :created }
          rescue ActiveRecord::StatementInvalid
          format.json { render json: @users_photo.errors, status: :unprocessable_entity }
            raise ActiveRecord::Rollback
          end
        end

      else
        format.json { render json: 'user not found' , status: :not_found }
      end
    end
  end


  # PUT update set profile image
  #/users_photos/json/update_users_set_profile_image_by_user_id_and_users_photo_id/:user_id/:users_photo_id
  #/users_photos/json/update_users_set_profile_image_by_user_id_and_users_photo_id/30/400.json
  #success    ->  head  200 ok

  def json_update_users_set_profile_image_by_user_id_and_users_photo_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])
        if UsersPhoto.exists?(id: params[:users_photo_id])

          ActiveRecord::Base.transaction do
            begin
              UsersPhoto.where("user_id = ?",params[:user_id]).update_all("profile_image = 'n'")



              @users_photo = UsersPhoto.find(params[:users_photo_id])
              @users_photo.profile_image = 'y'
              @users_photo.save

              format.json { render json: @users_photo, status: :ok }
            rescue ActiveRecord::StatementInvalid
              format.json { render json: @users_photo.errors, status: :unprocessable_entity }
              raise ActiveRecord::Rollback
            end
          end
        else
          format.json { render json: 'user photo not found' , status: :not_found }
        end
      else
        format.json { render json: 'user not found' , status: :not_found }
      end
    end
  end



  #GET Get all users photos

  #/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/:user_id/:limit/:offset
  #/users_photos/json/index_users_photos_by_user_id_by_limit_by_offset/
  #                     #Return head
  #success    ->  head  200 OK

  def json_index_users_photos_by_user_id_by_limit_by_offset

    respond_to do |format|

      if User.exists?(id:params[:user_id])

          @users_photos = UsersPhoto.where("user_id = ?",params[:user_id]).limit(params[:limit]).offset(params[:offset])

          format.json {render json:@users_photos.as_json()}

      else
        format.json { render json: 'not user found', status: :not_found }
      end
    end


  end



end
