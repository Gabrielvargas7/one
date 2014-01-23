class Mywebroom.Models.DefaultStateModel extends Backbone.Model


  defaults: {

    staticContent : false  #Collection of static content images

    roomState     : false  # Who's room are we viewing? PUBLIC, FRIEND, or SELF
    roomUser      : false  # Backbone Model of room user, or false
    roomData      : false  # Backbone Model of room data, or false
    signInState   : false  # Boolean: Is the user signed in?
    signInUser    : false  # Backbone Model of signed-in user, or false
    signInData    : false  # Backbone Model of signed-in user's data, or false

    roomDesigns   : false  # Array of item designs, or empty array
    roomTheme     : false  # Object containing info on room's theme
    firstTimePopupItem : 0 #set the item for the first time popup
    dom_item_id   : false # dom item when is click

    initialItems: false # Backbone collection of room items

    $activeDesign           : false  # A refernce to the element of the design in focus (*see note below)
    activeDesignIsHidden    : false  # yes or no
    tutorialItem            : 13     # is the number of the item the where click on the turotial default is 13
    tutorialBookmarkCounter : 0      #  counter number of bookmark on tutorial
    tutorialStep            : 0      #  step of the tutorial default is 0


    roomView                     : false  # A reference to this view
    roomHeaderView               : false  # A reference to this view
    storeLayoutView              : false  # A reference to this view
    storeMenuSaveCancelRemoveView: false  # A reference to this view
    roomScrollerLeftView         : false  # A reference to this view
    roomScrollerRightView        : false  # A reference to this view
    tutorialItemClick            : false  # A reference to this view
    tutorialBookmarkDiscover     : false  # A reference to this view
    tutorialBookmarkView         : false  # A reference to this view


    friendItemPopupView          : false  # A reference to the popup view
    profileHomeView              : false  # A reference to this view
    bookmarksView                : false  # A reference to the bookmarks view that currently open. There should only ever be one.


    roomViewState                     : false # open or closed
    roomHeaderViewState               : false # open or closed
    storeLayoutViewState              : false # open or closed


    tabContentItems         : false
    tabContentThemes        : false
    tabContentBundles       : false
    tabContentEntireRooms   : false
    tabContentHidden        : false


    storeState: false # hidden, collapsed, or shown
    saveBarWasVisible: false # Lets us know if the save bar was showing when we collapsed the store
    storeHelper: false # Store information about the tab or object we're on
    activeSitesMenuView: false #A reference to the Active Sites Menu View.
    searchViewArray: false #A reference to an Array of view on the search

    room0: {
      position: -2200
      screen_position: 0
      id: "#xroom_items_0"
    }
    room1: {
      position: 0
      screen_position: 1
      id: "#xroom_items_1"
    }
    room2: {
      position: 2200
      screen_position: 2
      id: "#xroom_items_2"
    }
  }

  ###
  *Note about $activeDesign: At the present, this gets set when either the object this design
   belongs to is clicked from the store, or a new design was
   chosen from the store. Would probably be good to have this
   get set when a room design is click directly.
  ###

