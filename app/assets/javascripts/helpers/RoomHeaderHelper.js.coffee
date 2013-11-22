Mywebroom.Helpers.RoomHeaderHelper = {


  addHeaderImageProfile: ->
    console.log("add image profile")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_profile').css('background-image', 'url("' + imageUrl + '")');
    $('#xroom_header_profile').removeClass('xroom_header_profile_img_hover').addClass('xroom_header_profile_img');


  addHoverHeaderImageProfile: ->

    console.log("add hover image profile")
    toolbar_icons = Mywebroom.State.get('staticContent').findWhere({"name":"toolbar-icons"})
    imageUrl = toolbar_icons.get('image_name').url
    $('#xroom_header_profile').css('background-image', 'url("' + imageUrl + '")');
    $('#xroom_header_profile').removeClass('xroom_header_profile_img').addClass('xroom_header_profile_img_hover');


}