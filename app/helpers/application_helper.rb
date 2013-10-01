module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Mywebroom"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end


  #***********************************
  # Start private Json methods for the room users
  #***********************************


  def json_signed_in_user

    unless signed_in?
      respond_to do |format|
        #format.json { render json: {id: nil, username: nil}, status: :not_found }
        format.json { render json: 'user not sign in ' , status: :not_found }
      end
    end
  end


  def json_correct_user
    @user_json = User.find(params[:user_id])
    unless current_user?(@user_json)
      respond_to do |format|
        format.json { render json: 'user not correct ' , status: :not_found }
      end
    end
  end


  def json_is_my_friend_the_sign_in_by_friend_id

    if signed_in?
      @current_user =  current_user

      # if the user is the same pass
      if  @current_user.id.to_s == params[:user_id].to_s

        return true

      else
          # if I sign in and want to see my friends friends
          if Friend.exists?(user_id:@current_user.id,user_id_friend:params[:user_id])

            return true

          else
            respond_to do |format|
              format.json { render json: 'not friend ' , status: :not_found }
            end
          end
      end
    else
      respond_to do |format|
        format.json { render json: 'user not sign in ' , status: :not_found }
      end
    end

  end






  #***********************************
  # End Json methods for the room users
  #***********************************


  def signed_in_user

    unless signed_in?
      store_location
      #redirect_to signin_url, notice: "Please sign in."

      redirect_to root_path, notice: "Please sign in."

    end

  end

  def correct_user
    if User.exists?(params[:id])
    @user_correct = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user_correct)
    else
      redirect_to(root_path)
    end
  end

  def correct_user_by_user_id

    if User.exists?(params[:user_id])
      @user_correct = User.find(params[:user_id])
      redirect_to(root_path) unless current_user?(@user_correct)
    else
      redirect_to(root_path)
    end
  end


  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end


  def correct_username
    @user = User.find_by_username(params[:username])
    redirect_to(root_path) unless current_user?(@user)
  end





end
