class UsersItemsDesignsController < ApplicationController

  #***********************************
  # Json methods for the room users
  #***********************************

  #//# PUT change the user's items design by user id and item design id
  #//#  /users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id'
  #//#  /users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id/10000001/1000.json
  #//#  Form Parameters:
  #//#                  :new_items_design_id = 1
 def json_update_user_items_design_by_user_id_and_items_design_id

   respond_to do |format|
         #validate if exist the items design
         if ItemsDesign.exists?(id: params[:items_design_id]) and ItemsDesign.exists?(id: params[:new_items_design_id])

           #validate if the items type is the same
           items_design = ItemsDesign.where('id = ?',params[:items_design_id]).first
           items_design_new = ItemsDesign.where('id = ?',params[:new_items_design_id]).first

           if items_design.item_id.eql?(items_design_new.item_id)

              #  validate if exists on the user
              if UsersItemsDesign.exists?(user_id:params[:user_id],items_design_id:params[:items_design_id])

                  @user_items_design = UsersItemsDesign.find_by_user_id_and_items_design_id(params[:user_id],params[:items_design_id])
                  #respond_to do |format|
                    if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:new_items_design_id])
                      format.json { head :no_content }
                    else
                      format.json { render json: @user_items_design.errors, status: :unprocessable_entity }
                    end
                  #end
              else
                format.json { render json: 'user id with items design id not found ' , status: :not_found }
              end
           else
             format.json { render json: 'new and old items type are different' , status: :forbidden }
           end
         else
              format.json { render json: 'new and old items_design_id not found' , status: :not_found }
         end
     end
  end

 #   PUT toggle the user items design with (yes to no to yes)
 #  /users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id
 #  /users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id/10000001/1000.json
 #     //   toggle operation -> yes -> no

  def json_update_hide_user_items_design_by_user_id_and_items_design_id

    respond_to do |format|
      #  validate if exists on the user
      if UsersItemsDesign.exists?(user_id:params[:user_id],items_design_id:params[:items_design_id])

             @user_items_design = UsersItemsDesign.find_by_user_id_and_items_design_id(params[:user_id],params[:items_design_id])

            if @user_items_design.hide.eql?("yes")
                if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:items_design_id],hide:'no')
                  format.json { head :no_content }
                else
                  format.json { render json: @user_theme.errors, status: :unprocessable_entity }
                end
            else
                if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:items_design_id],hide:'yes')
                  format.json { head :no_content }
                else
                  format.json { render json: @user_items_design.errors, status: :unprocessable_entity }
                end
            end
      else
        format.json { render json: 'not found user id with items design' , status: :not_found }
      end
    end
  end


  #   GET get all the Item design of the user
  #  /users_items_designs/json/index_user_items_designs_by_user_id/:user_id
  #  /users_items_designs/json/index_user_items_designs_by_user_id/10000001.json

 def json_index_user_items_designs_by_user_id

   respond_to do |format|

      # validate if the user exist
      if UsersItemsDesign.exists?(user_id: params[:user_id])

        @user_items_designs = ItemsDesign.
                                select('items_designs.id ,name,item_id,description,image_name,users_items_designs.hide').
                                  joins(:users_items_designs).
                                    where('user_id = ?',params[:user_id])

        format.json { render json: @user_items_designs }

      else
        format.json { render json: 'not found user id', status: :not_found }
      end
   end
  end

  # GET get one item design of the user
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id
  #  /users_items_designs/json/show_user_items_designs_by_user_id_and_items_design_id/10000001/100.json

 def json_show_user_items_design_by_user_id_and_items_design_id


   respond_to do |format|
      if UsersItemsDesign.exists?(user_id: params[:user_id],items_design_id: params[:items_design_id] )

        @user_items_designs = ItemsDesign.
                                select('items_designs.id ,name,item_id,description,image_name,users_items_designs.hide').
                                  joins(:users_items_designs).
                                    where('user_id = ? and items_design_id = ?',params[:user_id] , params[:items_design_id] )

        format.json { render json: @user_items_designs }

      else
         format.json { render json: 'not found user id and items design id ', status: :not_found }
      end
   end
 end



end
