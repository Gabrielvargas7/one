module SeedUpdateUserModule

  def self.InsertNewItemsTooldUser(item,location)
      #item = 28
      #location = 27
    if ItemsLocation.exists?(item_id:item,location_id:location)
          @items_location = ItemsLocation.find_by_item_id_and_location_id(item,location)

          if ItemsDesign.exists?(item_id:@items_location.item_id)

            @items_design = ItemsDesign.find_by_item_id(@items_location.item_id)
            @users = User.all
            @users.each  do |user|
              p user.id
              p user.email

              if  UsersItemsDesign.exists?(user_id:user.id,items_design_id:@items_design.id,location_id:@items_location.location_id)
                p "user item exist on db"
              else
                  @user_item_designs = UsersItemsDesign.create!(user_id:user.id,items_design_id:@items_design.id,hide:'no',location_id:@items_location.location_id)
              end
            end

          end
    else
      p "no item location"
    end
  end

end