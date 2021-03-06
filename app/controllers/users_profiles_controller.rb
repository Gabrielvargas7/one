class UsersProfilesController < ApplicationController


  before_filter :signed_in_user,
                only:[:destroy,
                      :index,
                      :show,
                      :new,
                      :edit,
                      :update,
                      :create,
                      :edit_users_profiles_by_user_id,
                      :update_users_profiles_by_user_id

                ]


  before_filter :correct_user, only:[
                    :edit_users_profiles_by_user_id,
                    :update_users_profiles_by_user_id
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

  before_filter :json_signed_in_user,
                only:[
                    :json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step

                ]

  before_filter :json_correct_user,
                only:[
                    :json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step
                ]






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
    #@users_profile = UsersProfile.new
    #
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.json { render json: @users_profile }
    #end
  end

  # GET /users_profiles/1/edit
  def edit
    @users_profile = UsersProfile.find(params[:id])
    #@date_last = Date.today.year
    @start_date = Time.now.year - 100
    @end_date = Time.now.year

  end

  # POST /users_profiles
  # POST /users_profiles.json
  def create

    # NOTE: without a corresponding view, this action will fail
    #       If we aren't providing a view, don't we need
    #       to redirect somewhere?


    #@users_profile = UsersProfile.new(params[:users_profile])
    #
    #respond_to do |format|
    #  if @users_profile.save
    #    format.html { redirect_to @users_profile, notice: 'Users profile was successfully created.' }
    #    format.json { render json: @users_profile, status: :created, location: @users_profile }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @users_profile.errors, status: :unprocessable_entity }
    #  end
    #end
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
    #@users_profile = UsersProfile.find(params[:id])
    #@users_profile.destroy

    respond_to do |format|
      format.html { redirect_to users_profiles_url }
      format.json { head :no_content }
    end
  end


  # GET /users_profiles/show_by_user_id/:id
  #def show_users_profiles_by_user_id
  #  @users_profile = UsersProfile.find_all_by_user_id(params[:id]).first
  #  @users_photo = UsersPhoto.find_by_user_id_and_profile_image(params[:id],'y')
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @users_profile }
  #  end
  #end

  # GET /users_profiles/edit_by_user_id/:id
  def edit_users_profiles_by_user_id

    @start_date = Time.now.year - 100
    @end_date = Time.now.year
    @users_profile = UsersProfile.find_all_by_user_id(params[:id]).first
    @users_photo = UsersPhoto.find_by_user_id_and_profile_image(params[:id],'y')


  end

  # PUT /users_profiles/update_by_user_id/:id <-- although :id is the only param being passed in the route, another param, :users_profile, is also being passed
  def update_users_profiles_by_user_id
    @users_profile = UsersProfile.find_all_by_user_id(params[:id]).first


    respond_to do |format|
      if @users_profile.update_attributes(params[:users_profile])
        format.html { redirect_to edit_users_profiles_by_user_id_path(@users_profile.user_id), notice: 'Users profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit_users_profiles_by_user_id" }
        format.json { render json: @users_profile.errors, status: :unprocessable_entity }
      end
    end
  end



  #***********************************
  # Json methods for the room users
  #***********************************

  # PUT change tutorial step
  #  /users_profiles/json/update_users_profiles_tutorial_step_by_user_id_and_tutorial_step/:user_id/:tutorial_step
  #  /users_profiles/json/update_users_profiles_tutorial_step_by_user_id_and_tutorial_step/24/1.json
  # Return ->
  # Success    ->  head  200 ok


  def json_update_users_profiles_tutorial_step_by_user_id_and_tutorial_step


    respond_to do |format|
      if UsersProfile.exists?(user_id:params[:user_id])
        @user_profile = UsersProfile.find_by_user_id(params[:user_id])

        if @user_profile.update_attributes(tutorial_step:params[:tutorial_step])

          format.json { render json: @user_profile.as_json(only: [:user_id, :tutorial_step]), status: :ok }

        else
          format.json { render json: @user_profile.errors, status: :unprocessable_entity }
        end


      end
    end
  end


  # Get tutorial steps
  # GET /users_profiles/json/show_users_profile_tutorial_step_by_user_id/:user_id
  # GET /users_profiles/json/show_users_profile_tutorial_step_by_user_id/28.json
  #Return head 200 OK
  def json_show_users_profile_tutorial_step_by_user_id

    respond_to do |format|
      if UsersProfile.exists?(user_id: params[:user_id])
        @user_profile = UsersProfile.find_by_user_id(params[:user_id])
        format.json { render json: @user_profile.as_json(only: [:user_id, :tutorial_step]), status: :ok }

      end
    end
  end



end
