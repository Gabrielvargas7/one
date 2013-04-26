class UsersItemsDesignsController < ApplicationController


  def update_user_item_design_by_user_id_and_item_design_id

    #validate if the new item design is the same item type
     item_design = ItemsDesign.find(params[:item_design_id])
     item_design_new = ItemsDesign.find(params[:new_item_design_id])

     if item_design.item_id.eql?(item_design_new.item_id)

        @user_item_design = UsersItemsDesign.find_by_user_id_and_items_design_id(params[:user_id],params[:item_design_id])

        respond_to do |format|
          if @user_item_design.update_attributes(user_id: params[:user_id],items_design_id: params[:new_item_design_id])
            format.json { head :no_content }
          else
            format.json { render json: @user_theme.errors, status: :unprocessable_entity }
          end
        end

     else
          head :bad_request
     end

  end


  def update_hide_user_item_design_by_user_id_and_item_design_id

      @user_item_design = UsersItemsDesign.find_by_user_id_and_items_design_id(params[:user_id],params[:item_design_id])

      if @user_item_design.hide.eql?("yes")
        respond_to do |format|
          if @user_item_design.update_attributes(user_id: params[:user_id],items_design_id: params[:item_design_id],hide:'no')
            format.json { head :no_content }
          else
            format.json { render json: @user_theme.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|
          if @user_item_design.update_attributes(user_id: params[:user_id],items_design_id: params[:item_design_id],hide:'yes')
            format.json { head :no_content }
          else
            format.json { render json: @user_theme.errors, status: :unprocessable_entity }
          end
        end

      end
  end


end
