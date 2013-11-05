class UsersItemsDesignsController < ApplicationController
  before_filter :signed_in_user,
                only:[
                ]

  before_filter :json_signed_in_user,
                only:[
                    :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
                    :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
                    :json_update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id
                ]

  before_filter :json_correct_user,
                only:[
                    :json_update_user_items_design_by_user_id_and_items_design_id_and_location_id,
                    :json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id,
                    :json_update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id

                ]


  before_filter :correct_user, only:[]
  before_filter :admin_user, only:[]


  #***********************************
  # Json methods for the room users
  #***********************************

  #//# PUT change the user's items design by user id and item design id
  #//#  /users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id'
  #//#  /users_items_designs/json/update_user_items_design_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
  #//#  Form Parameters:
  #//#                  :new_items_design_id = 1
  #Return ->
  #success    ->  head  200 OK

  def json_update_user_items_design_by_user_id_and_items_design_id_and_location_id

   respond_to do |format|
         #validate if exist the items design
         if ItemsDesign.exists?(id: params[:items_design_id]) and ItemsDesign.exists?(id: params[:new_items_design_id])

           #validate if the items type is the same
           items_design = ItemsDesign.where('id = ?',params[:items_design_id]).first
           items_design_new = ItemsDesign.where('id = ?',params[:new_items_design_id]).first

           if items_design.item_id.eql?(items_design_new.item_id)

              #  validate if exists on the user
              if UsersItemsDesign.exists?(user_id:params[:user_id],items_design_id:params[:items_design_id],location_id:params[:location_id])

                  @user_items_design = UsersItemsDesign.find_by_user_id_and_items_design_id_and_location_id(params[:user_id],params[:items_design_id],params[:location_id])

                    if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:new_items_design_id],location_id:params[:location_id])

                      format.json { render json: @user_items_design, status: :ok }
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

 #   PUT (hide the item)toggle the user items design with (yes to no to yes)
 #  /users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id
 #  /users_items_designs/json/update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
 #       toggle operation -> yes -> no
 #Return ->
 #success    ->  head  200 OK

  def json_update_hide_user_items_design_by_user_id_and_items_design_id_and_location_id

    respond_to do |format|
      #  validate if exists on the user
      if UsersItemsDesign.exists?(user_id:params[:user_id],items_design_id:params[:items_design_id])

             @user_items_design = UsersItemsDesign.find_by_user_id_and_items_design_id_and_location_id(params[:user_id],params[:items_design_id],params[:location_id])

            if @user_items_design.hide.eql?("yes")
                if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:items_design_id],hide:'no',location_id:params[:location_id] )
                  format.json { render json: @user_items_design, status: :ok }
                else
                  format.json { render json: @user_items_design.errors, status: :unprocessable_entity }
                end
            else
                if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:items_design_id],hide:'yes')

                   format.json { render json: @user_items_design, status: :ok }
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
  # Return ->
  # success    ->  head  200 OK
  def json_index_user_items_designs_by_user_id

   respond_to do |format|

      # validate if the user exist
      if UsersItemsDesign.exists?(user_id: params[:user_id])

        @user_items_designs = ItemsDesign.
                                select('items_designs.id ,
                                        items_designs.name,
                                        items_designs.item_id,
                                        items_designs.description,
                                        items_designs.image_name,
                                            items_designs.category,
                                            items_designs.style,
                                            items_designs.brand,
                                            items_designs.color,
                                            items_designs.make,
                                            items_designs.special_name,
                                            items_designs.like,

                                        users_items_designs.hide,
                                        users_items_designs.location_id,
                                        locations.section_id').
                                  joins(:users_items_designs).
                                  joins('LEFT OUTER JOIN locations  ON locations.id = users_items_designs.location_id').
                                  where('user_id = ?',params[:user_id])

        format.json { render json: @user_items_designs }

      else
        format.json { render json: 'not found user id', status: :not_found }
      end
   end
  end

  # GET get one item design of the user
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/:user_id/:items_design_id
  #  /users_items_designs/json/show_user_items_design_by_user_id_and_items_design_id/10000001/100.json
  #Return ->
  #success    ->  head  200 OK
  def json_show_user_items_design_by_user_id_and_items_design_id


   respond_to do |format|
      if UsersItemsDesign.exists?(user_id: params[:user_id],items_design_id: params[:items_design_id] )

        @user_items_designs = ItemsDesign.
                                    select('items_designs.id ,
                                            items_designs.name,
                                            items_designs.item_id,
                                            items_designs.description,
                                            items_designs.image_name,
                                            items_designs.category,
                                            items_designs.style,
                                            items_designs.brand,
                                            items_designs.color,
                                            items_designs.make,
                                            items_designs.special_name,
                                            items_designs.like,
                                            users_items_designs.hide,
                                            users_items_designs.location_id,
                                            locations.section_id').
                                    joins(:users_items_designs).
                                    joins('LEFT OUTER JOIN locations  ON locations.id = users_items_designs.location_id').
                                    where('user_id = ? and items_design_id = ?',params[:user_id] , params[:items_design_id] )

        format.json { render json: @user_items_designs }

      else
         format.json { render json: 'not found user id and items design id ', status: :not_found }
      end
   end
  end




  #   GET get all the Item design of the user and section id
  #  /users_items_designs/json/index_user_items_designs_by_user_id_and_section_id/:user_id/:section_id
  #  /users_items_designs/json/index_user_items_designs_by_user_id/23/1.json
  # Return ->
  # success    ->  head  200 OK
  def json_index_user_items_designs_by_user_id_and_section_id

    respond_to do |format|

      # validate if the user exist
      if UsersItemsDesign.exists?(user_id: params[:user_id])

        @user_items_designs = ItemsDesign.
            select('items_designs.id ,
                                        items_designs.name,
                                        items_designs.item_id,
                                        items_designs.description,
                                        items_designs.image_name,
                                            items_designs.category,
                                            items_designs.style,
                                            items_designs.brand,
                                            items_designs.color,
                                            items_designs.make,
                                            items_designs.special_name,
                                            items_designs.like,

                                        users_items_designs.hide,
                                        users_items_designs.location_id,
                                        locations.section_id').
            joins(:users_items_designs).
            joins('LEFT OUTER JOIN locations  ON locations.id = users_items_designs.location_id').
            where('user_id = ? and locations.section_id = ?',params[:user_id],params[:section_id])

        format.json { render json: @user_items_designs }

      else
        format.json { render json: 'not found user id', status: :not_found }
      end
    end
  end


  #   PUT update the user items design first time click to no (n)
  #  /users_items_designs/json/update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id/:user_id/:items_design_id/:location_id
  #  /users_items_designs/json/update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id/10000001/1000/1.json
  #       toggle operation -> yes -> no
  #Return ->
  #success    ->  head  200 OK

  def json_update_user_items_design_first_time_click_to_not_by_user_id_and_items_design_id_and_location_id

    respond_to do |format|
      #  validate if exists on the user
      if UsersItemsDesign.exists?(user_id:params[:user_id],items_design_id:params[:items_design_id])
         @user_items_design = UsersItemsDesign.find_by_user_id_and_items_design_id_and_location_id(params[:user_id],params[:items_design_id],params[:location_id])

          if @user_items_design.update_attributes(user_id: params[:user_id],items_design_id: params[:items_design_id],first_time_click:'n',location_id:params[:location_id] )
            format.json { render json: @user_items_design, status: :ok }

          else
            format.json { render json: @user_items_design.errors, status: :unprocessable_entity }
          end
      else
        format.json { render json: 'not found user id with items design' , status: :not_found }
      end
    end
  end



end
