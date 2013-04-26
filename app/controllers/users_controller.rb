class UsersController < ApplicationController

  before_filter :signed_in_user, only:[:edit,:update,:destroy]
  before_filter :correct_user, only:[:edit,:update]
  before_filter :admin_user, only:[:destroy,:index]


  def show
     @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the MyWebRoom!"
      redirect_to @user
      # Handle a successful save.
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user

    else
      render 'edit'

    end
  end

  # PUT
  def update_username_by_user_id


    username = clean_username(params[:username])

    if username.eql?(params[:username])
      if User.exists?(username: username)
        head :bad_request
      else
        @user = User.find(params[:user_id])
          respond_to do |format|
            if @user.update_attributes(username:username)
              format.json { head :no_content }
            else
              format.json { render json: @user_theme.errors, status: :unprocessable_entity }
            end
          end
      end
    else
       head :bad_request
    end
  end


  def index

    @users = User.paginate(page: params[:page])

  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url

  end


  private

  def signed_in_user

    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end

  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end


  def admin_user
    redirect_to(root_path) unless current_user.admin?

  end


  def clean_username(username)

    my_username = username
    #remove all non- alphanumeric character (expect dashes '-')
    my_username = my_username.gsub(/[^0-9a-z -]/i, '')

    #remplace dashes() for empty space because if the user add dash mean that it want separate the username
    my_username = my_username.gsub(/[-]/i, ' ')

    #remplace the empty space for one dash by word
    my_username.downcase!
    my_username.strip!
    username_split = my_username.split(' ').join('-')

  end



end
