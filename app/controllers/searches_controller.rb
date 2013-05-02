class SearchesController < ApplicationController

  #***********************************
  # Json methods for the room users
  #***********************************

  # GET get user that was found by the keyword with limit and offset(start row)
  # /searches/json/index_searches_user_name_by_keyword_with_limit_and_offset/:keyword/:limit/:offset
  # /searches/json/index_searches_user_name_by_keyword_with_limit_and_offset/gab vargas/10/5
  #Return head
  #success    ->  head  200 OK

  def json_index_searches_user_name_by_keyword_with_limit_and_offset

    respond_to do |format|
        if params[:keyword]

          keyword = params[:keyword]
          keyword.downcase!

         # limit the length of the string to avoid injection
         if keyword.length < 12

           @user = User.where('lower(name) LIKE ?', "%#{keyword}%").limit(params[:limit]).offset(params[:offset])
           format.json { render json: @user.as_json(only:[:id, :name]) }


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
