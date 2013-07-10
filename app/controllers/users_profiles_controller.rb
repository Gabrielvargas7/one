class UsersProfilesController < ApplicationController
  # GET /users_profiles
  # GET /users_profiles.json
  def index
    @users_profiles = UsersProfile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users_profiles }
    end
  end

  # GET /users_profiles/1
  # GET /users_profiles/1.json
  def show
    @users_profile = UsersProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users_profile }
    end
  end

  # GET /users_profiles/new
  # GET /users_profiles/new.json
  def new
    @users_profile = UsersProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @users_profile }
    end
  end

  # GET /users_profiles/1/edit
  def edit
    @users_profile = UsersProfile.find(params[:id])
  end

  # POST /users_profiles
  # POST /users_profiles.json
  def create
    @users_profile = UsersProfile.new(params[:users_profile])

    respond_to do |format|
      if @users_profile.save
        format.html { redirect_to @users_profile, notice: 'Users profile was successfully created.' }
        format.json { render json: @users_profile, status: :created, location: @users_profile }
      else
        format.html { render action: "new" }
        format.json { render json: @users_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users_profiles/1
  # PUT /users_profiles/1.json
  def update
    @users_profile = UsersProfile.find(params[:id])

    respond_to do |format|
      if @users_profile.update_attributes(params[:users_profile])
        format.html { redirect_to @users_profile, notice: 'Users profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @users_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users_profiles/1
  # DELETE /users_profiles/1.json
  def destroy
    @users_profile = UsersProfile.find(params[:id])
    @users_profile.destroy

    respond_to do |format|
      format.html { redirect_to users_profiles_url }
      format.json { head :no_content }
    end
  end
end
