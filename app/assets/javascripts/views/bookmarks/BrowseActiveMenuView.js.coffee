#Active Menu instance hides and shows by altering the css left property. 
#This lets the menu slide out from right to left. 
class Mywebroom.Views.BrowseActiveMenuView extends Backbone.View
  className:'browse_mode_active_sites_menu'
  template:JST['bookmarks/BrowseActiveMenuTemplate']
  events:
    'click #active_menu_close':'hideActiveMenu'
  initialize:->
    self= this
    @collection.on('add',@render,self)
    @collection.on('remove',@render,self)
    Mywebroom.State.set('activeSitesMenuView', this)
  render:->
    $(@el).html(@template(collection:@collection))
    this
  hideActiveMenu:->
    #$(@el).css "opacity",0
    setTimeout (->$('.browse_mode_active_sites_menu').css "top","-115px"),0
    $('#browse_mode_active_default').removeClass('selected')
    # $(@el).css "opacity",0
    # setTimeout (->$('.browse_mode_active_sites_menu').css "left","-12070px"),1500
    # $('#browse_mode_active_default').removeClass('selected')
   
  showActiveMenu:->
    if $(@el).css("top") is "-115px"
      $(@el).css "top","45px"
      #$(@el).css "opacity",1
      $('#browse_mode_active_default').addClass('selected')
    else
      @hideActiveMenu()

    # if $(@el).css("left") is "-12070px"
    #   $(@el).css "left","70px"
    #   $(@el).css "opacity",1
    #   $('#browse_mode_active_default').addClass('selected')
    # else
    #   @hideActiveMenu()

  isHidden:->
    if $(@el).css("top") is "-115px"
      true
    else
      false
    # if $(@el).css("left") is "-12070px"
    #   true
    # else
    #   false