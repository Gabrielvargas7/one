class RoomsController < ApplicationController
  before_filter :correct_user, only:[:show]

  def show

    @user = User.select("id , name,email").where("id = ?",params[:id]).first

    @user_theme = Theme.
        select("themes.id,name,description,image_name").
        joins(:users_themes).
        where("user_id = ?",@user.id)
    @user_items_designs = ItemsDesign.
        select("items_designs.id ,name,item_id,description,image_name").
        joins(:users_items_designs).
        where("user_id = ?",@user.id)

    @user_bookmarks = Bookmark.
        select("bookmarks.id, bookmark_url, bookmarks_category_id, description, i_frame, image_name, image_name_desc, item_id, title").
        joins(:users_bookmarks).
        where("user_id = ?",@user.id)



    respond_to do |format|
      format.html # rooms.html.erb
      format.json { render json: { user:               @user,
                                   user_theme:         @user_theme,
                                   user_items_designs: @user_items_designs.as_json(:include => {:item => {:only => [:name,:id,:x,:y,:z,:clickable,:height,:width ] }}),
                                   user_bookmarks:      @user_bookmarks.as_json(:include => {:bookmarks_category => {:only => :name }}),
      }}

    end

  end


  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end


end
