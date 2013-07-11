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
    @user_correct = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user_correct)
  end


  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end


  def correct_username
    @user = User.find_by_username(params[:username])
    redirect_to(root_path) unless current_user?(@user)
  end





end
