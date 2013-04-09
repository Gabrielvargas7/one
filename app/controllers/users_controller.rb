class UsersController < ApplicationController

  before_filter :signed_in_user, only:[:index,:edit,:update,:destroy]
  before_filter :correct_user, only:[:edit,:update]
  before_filter :admin_user, only: :destroy

  def show
     @user = User.find(params[:id])

    #if params[:email]
    #  @user  = User.where(email: params[:email]).first
    #  #render 'users/show'
    #else
    #  #redirect_to(root_path)
    #end

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

  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])

    #if params[:name]
    #  @zombie = Zombie.where(:name => params[:name]).first
    #  @tweets = @zombie.tweets
    #else
    #  @tweets = Tweet.all
    #end


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

    #redirect_to signin_url, notice:"Please sign in." unless signed_in?
    # equivalen to up code
    #flash[:notice] = "Please sign in."
    #redirect_to signin_url
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?

  end


end
