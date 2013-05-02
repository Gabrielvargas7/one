class UsersController < ApplicationController

  before_filter :signed_in_user, only:[:edit,:update,:destroy]
  before_filter :correct_user, only:[:edit,:update]
  before_filter :admin_user, only:[:destroy,:index]


  def show
     @user = User.find(params[:id])

     respond_to do |format|
       format.html # show.html.erb
       format.json { render json: @user.as_json(only:[:name,:email,:username])  }
     end

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

    @users = User.paginate(page: params[:page])

  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url

  end

  #***********************************
  # Json methods for the room users
  #***********************************

  #//# PUT update the username
  #//#  /users/json/update_username_by_user_id/:user_id'
  #//#  /users/json/update_username_by_user_id/1000.json
  #//#  Form Parameters:
  #//#                  :new_username
  #Return ->
  #success    ->  head  200 ok

  def json_update_username_by_user_id

    respond_to do |format|
      #validate if the user exist
      if User.exists?(id:params[:user_id])

          new_username = clean_username(params[:new_username])
          new_username_downcase =  params[:new_username]
          new_username_downcase.downcase!

          # validate the username has to be only alphanumeric characters,therefore,
          # if change after clean, mean that it have no valid characters
          if new_username.eql?(new_username_downcase)

            # validate the username has to be unique
            if User.exists?(username: new_username)
              format.json { render json: 'sorry but the username is already take' , status: :conflict }
            else
              @user = User.find(params[:user_id])
                if @user.update_attributes(username:new_username)
                  #format.json { head :no_content }
                  format.json { render json: @user.as_json(only: [:id,:username]), status: :ok }
                else
                  format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
          else
            format.json { render json: 'invalid username ,only alphanumerical characters ' , status: :not_acceptable }
          end
      else
        format.json { render json: 'not found user id' , status: :not_found }
      end

    end
  end


  #***********************************
  # End Json methods for the room users
  #***********************************




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


  # this function will remove all non-alphanumeric character and
  # replace the empty space for dash eg 'my new username@@' = my-new-username
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
