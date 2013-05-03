class SearchesController < ApplicationController

  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get user that was found by the keyword with limit and offset(start row)
  # /searches/json/index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword/:user_id/:limit/:offset/:keyword
  # /searches/json/index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword/206/10/0/gabriel var.json
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_user_name_by_user_id_with_limit_and_offset_and_keyword

    respond_to do |format|
        if params[:keyword]

          keyword = params[:keyword]
          keyword.downcase!

         # limit the length of the string to avoid injection
         if keyword.length < 12

           @user = User.select('id,name,image_name').where('lower(name) LIKE ?', "%#{keyword}%").limit(params[:limit]).offset(params[:offset])

           #@user = User.
           #             where('lower(name) LIKE ?', "%#{keyword}%").
           #               limit(params[:limit]).
           #                 offset(params[:offset]).
           #                   includes(:users_galleries)
           #                   #joins(:users_galleries)


           #@search.each do |user|
           #
           #
           #
           #end




           format.json { render json: @user
           #format.json { render json: {user: @user.as_json(only: [:name,:id],include: {users_galleries: {only: [:image_name,:id,:default_image] }} )
           #format.json { render json: @user.as_json(only: [:name,:id],include: {users_galleries: {only: [:image_name,:id,:default_image] }} )

           }




         else
           @user = nil
           format.json { render json: @user }
         end
        else
          @user = nil
          format.json { render json: @user }
        end
    end
  end



end
