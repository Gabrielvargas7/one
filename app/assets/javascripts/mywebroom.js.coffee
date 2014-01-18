window.Mywebroom = {

  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Helpers: {}
  State: {}
  App: {}
  Data: {}
  Start: {}

}




Mywebroom.Data = {
  ItemModels: {} # format -> 2: Backbone.Model
  ItemNames:  {} # format -> 3: "string"
  ItemIds:    Object.create(null) # *see note below # format -> 7: true
  Editor: {
    paginate: false
    contentPath: false # INITIAL, SEARCH
    contentType: false
    keyword: false
    offset: 0
    limit: 20
    location: false
  }
  searchNum: -1
  FriendItemPopupUrls: {
    1:   "" #sofa
    2:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348300/birdcage-Friend-Pop-Up-Object_gxaui5.png" #birdcage
    3:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348427/bookstand-Friend-Pop-Up-Object_up9cyp.png" #bookcase
    4:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348575/chair-Friend-Pop-Up-Object_wagoi1.png" #chair
    5:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348940/newspaper-Friend-Pop-Up-Object_nhybid.png" #newspaper
    6:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348860/map-Friend-Pop-Up-Object_gp3jlo.png" #world map
    7:   "" #tv stand
    8:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348727/dresser-Friend-Pop-Up-Object_mwf3fb.png" #dresser
    9:   "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383594435/shoppingbag-Friend-Pop-Up-Object.png" #shopping bag
    10:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349273/socialcanvas-Friend-Pop-Up-Object_pvzhz4.png" #social canvas
    11:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349372/wallshelf-Friend-Pop-Up-Object_ylcro0.png" #wall shelf
    12:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348903/music-Friend-Pop-Up-Object_n4bmwf.png" #music player
    13:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349332/tv-Friend-Pop-Up-Object_ufnnkq.png" #tv
    14:  "" #desk
    15:  "" #nightstand
    16:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349004/notebook-Friend-Pop-Up-Object_xmertw.png" #notebook
    17:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348606/computer-Friend-Pop-Up-Object_n8smns.png" #computer
    18:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349077/phone-Friend-Pop-Up-Object_a43ejg.png" #phone
    19:  "" #lamp
    20:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349151/pinboard-Friend-Pop-Up-Object_iztyad.png" #pinboard
    21:  "" #portrait
    22:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349306/sport-Friend-Pop-Up-Object_yxtfe5.png" #sports
    23:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349438/window-Friend-Pop-Up-Object_gbupwg.png" #window
    24:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348514/box-Friend-Pop-Up-Object_eixd0j.png" #box
    25:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348798/games-Friend-Pop-Up-Object_qphqgk.png" #games
    26:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348829/hobbies-Friend-Pop-Up-Object_x4ev1a.png" #hobbies
    27:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349110/photography-Friend-Pop-Up-Object_izyrpc.png" #photography
    28:  "" #table
    29:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383348775/food-Friend-Pop-Up-Object_t3g7ir.png" #food
    30:  "" #stool
    31:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349192/poster-Friend-Pop-Up-Object_dsplbv.png" #poster
    32:  "//res.cloudinary.com/hpdnx5ayv/image/upload/v1383349037/pets-Friend-Pop-Up-Object_xtsvfq.png" #pet
    33:  "" #chandelier
    34:  "" #rug
    35:  "" #carpet
    ##DECOR? https://res.cloudinary.com/hpdnx5ayv/image/upload/v1383348640/decor-Friend-Pop-Up-Object_phompc.png
  }
}

###
*Note about ItemIds: To create a true set [http://en.wikipedia.org/wiki/Set_(mathematics)],
we want an object that doesn't already have any properties on it.

http://stackoverflow.com/questions/7958292/mimicking-sets-in-javascript
http://www.devthought.com/2012/01/18/an-object-is-not-a-hash/

Since this program speaks coffee, we use "of" to query instead of "in".

http://stackoverflow.com/questions/6408726/iterate-over-associative-array-in-coffeescript/6408784#6408784
###




$(document).ready( ->




  # Instantiate a state model
  Mywebroom.State = new Mywebroom.Models.DefaultStateModel()



  # Listen for changes to the state model
  Mywebroom.State.on('change:tabContentItems', ->

    #console.log('change:tabContentItems')

    data = Mywebroom.State.get('tabContentItems')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'ITEMS')

  )




  Mywebroom.State.on('change:tabContentThemes', ->

    #console.log('change:tabContentThemes')

    data = Mywebroom.State.get('tabContentThemes')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'THEMES')

  )




  Mywebroom.State.on('change:tabContentBundles', ->

    #console.log('change:tabContentBundles')

    data = Mywebroom.State.get('tabContentBundles')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'BUNDLES')

  )




  Mywebroom.State.on('change:tabContentEntireRooms', ->

    #console.log('change:tabContentEntireRooms')

    data = Mywebroom.State.get('tabContentEntireRooms')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'ENTIRE ROOMS')

  )




  Mywebroom.State.on('change:tabContentHidden', ->

    #console.log('change:tabContentHidden')

    data = Mywebroom.State.get('tabContentHidden')
    Mywebroom.Helpers.EditorHelper.appendCollection(data, 'HIDDEN')

  )




  # Create the Marionette App Object
  Mywebroom.App = new Backbone.Marionette.Application()




  # Define Marionette Regions
  Mywebroom.App.addRegions({
    xroom_main_container               : "#xroom_main_container"
    xroom_scroll_left                  : "#xroom_scroll_left"
    xroom_store_menu_save_cancel_remove: "#xroom_store_menu_save_cancel_remove"
    xroom_profile                      : "#xroom_profile"
    xroom_storepage                    : "#xroom_storepage"
    xroom_bookmarks                    : "#xroom_bookmarks"
    xroom_bookmarks_browse_mode        : "#xroom_bookmarks_browse_mode"
    xroom_footer                       : "#xroom_footer"
    xroom_scroll_right                 : "#xroom_scroll_right"
    xroom                              : "#xroom"
    xroom_items_0                      : "#xroom_items_0"
    xroom_items_1                      : "#xroom_items_1"
    xroom_itmes_2                      : "#xroom_items_2"
    xroom_header                       : "#xroom_header"
  })



  # Create Initializer Functions
  Mywebroom.App.addInitializer( ->

    new Mywebroom.Routers.RoomsRouter()
    Backbone.history.start() if Backbone.history
  )




  Mywebroom.App.addInitializer( ->

    Mywebroom.Helpers.AppHelper.fetchInitialData()
    view = new Mywebroom.Views.RoomView()

    # Save a reference in the state model
    Mywebroom.State.set("roomView", view)
  )



  # Start the App!
  Mywebroom.App.start()


)




