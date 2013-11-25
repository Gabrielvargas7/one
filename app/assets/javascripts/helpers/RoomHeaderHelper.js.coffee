Mywebroom.Helpers.RoomHeaderHelper = {


  addHeaderImageProfile: ->

    #console.log("add image profile")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_profile').css('background-image', 'url("' + imageUrl + '")')
    $('#xroom_header_profile').removeClass('xroom_header_profile_img_hover').addClass('xroom_header_profile_img')


  addHoverHeaderImageProfile: ->

    #console.log("add hover image profile")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_profile').css('background-image', 'url("' + imageUrl + '")')
    $('#xroom_header_profile').removeClass('xroom_header_profile_img').addClass('xroom_header_profile_img_hover')


  addHeaderImageStorePage: ->

    #console.log("add image storepage")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_storepage').css('background-image', 'url("' + imageUrl + '")')
    $('#xroom_header_storepage').removeClass('xroom_header_storepage_img_hover').addClass('xroom_header_storepage_img')


  addHoverHeaderImageStorePage: ->

    #console.log("add hover image store page")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_storepage').css('background-image', 'url("' + imageUrl + '")')
    $('#xroom_header_storepage').removeClass('xroom_header_storepage_img').addClass('xroom_header_storepage_img_hover')

  addHeaderImageActiveSites: ->

    #console.log("add image ActiveSites")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_active_sites').css('background-image', 'url("' + imageUrl + '")')
    $('#xroom_header_active_sites').removeClass('xroom_header_active_sites_img_hover').addClass('xroom_header_active_sites_img')


  addHoverHeaderImageActiveSites: ->

    #console.log("add hover image ActiveSites")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_active_sites').css('background-image', 'url("' + imageUrl + '")')
    $('#xroom_header_active_sites').removeClass('xroom_header_active_sites_img').addClass('xroom_header_active_sites_img_hover')

}
