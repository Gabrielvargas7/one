class Mywebroom.Collections.ShowRoomByUserIdCollection extends Backbone.Collection

  url: (userId) ->
    '/rooms/json/show_room_by_user_id/' + userId + '.json'

  parse: (response) ->
    
    ###
    USER MODEL
    ###
    user = response.user
    user.type = "USER"
    
    
    ###
    PHOTO MODEL
    ###
    photo = response.user_photos
    photo.type = "PHOTO"
    
    
    ###
    PROFILE MODEL
    ###
    profile = response.user_profile
    profile.type = "PROFILE"
    
    
    
    ###
    THEME "COLLECTION" (SIZE = 1)
    ###
    themes = _.map(response.user_theme, (model) ->
                obj = model
                obj.type = "THEME"
                return obj
              )
              
   
    
    ###
    DESIGN COLLECTION
    ###
    designs = _.map(response.user_items_designs, (model) ->
                obj = model
                obj.type = "DESIGN"
                return obj
              )

    ###
    ITEMS COLLECTION
    ###
    items = _.map(response.user_items, (model) ->
              obj = model
              obj.type = "ITEM"
              return obj
            )
              
              
    obj = {
      user:               user
      user_photos:        photo
      user_profile:       profile
      user_theme:         themes
      user_items_designs: designs
      user_items:         items
    }
    
    return obj
