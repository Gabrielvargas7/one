class UsersPhotosController < ApplicationController

  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_create_users_photo_by_user_id
                ]

  before_filter :json_correct_user,
               only:[
                    :json_create_users_photo_by_user_id
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
    @users_photo = UsersPhoto.find(params[:id])
    @users_photo.destroy

    respond_to do |format|
      format.html { redirect_to users_photos_url }
      format.json { head :no_content }
    end
  end

  # POST insert user image
  #/users_photos/json/create_users_photos_by_user_id/:user_id
  #/users_photos/json/create_users_photos_by_user_id/206.json
  # Content-Type : multipart/form-data
  # Form Parameters:
  #               :image_name (full path)
  #               :description
  #Return ->
  #success    ->  head  201 create
  def json_create_users_photo_by_user_id

    respond_to do |format|
      #validation of the user_id

      if User.exists?(id: params[:user_id])

        @user_photo = UsersPhoto.new(user_id:params[:user_id],image_name:params[:image_name],profile_image:'n',description:params[:description])

        if @user_photo.save
          format.json { render json: @user_photo, status: :created }
        else
          format.json { render json: @user_photo.errors, status: :unprocessable_entity }
        end
      else
        format.json { render json: 'user not found' , status: :not_found }
      end

    end

  end




end
