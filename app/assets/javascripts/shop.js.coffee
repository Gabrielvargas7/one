

Pinterest =
  generatePinterestUrl: ->

    type =  $(".shop_upper_container").attr("data-shop-type")
    baseUrl = '//pinterest.com/pin/create/button/?url='


    switch type

      when "DESIGN"
        mediaUrl =    $.trim($(".shop_image_name").attr('src'))
        description = $.trim($(".shop_name").text()) + ' - '
        signature =   ' - Found at myWebRoom.com'

      when "BOOKMARK"
        mediaUrl =    $.trim($(".shop_image_name").attr('src'))
        description = $.trim($(".shop_name").text()) + ' - '
        signature =   ' - For my virtual room at myWebRoom.com'

      when "ENTIRE_ROOM"
        mediaUrl =    $.trim($(".shop_image_name").attr('src'))
        description = $.trim($(".shop_name").text()) + ' - '
        signature = ' - Check out this virtual room at myWebRoom.com'

      when "BUNDLE"
        mediaUrl =    $.trim($(".shop_image_name").attr('src'))
        description = $.trim($(".shop_name").text()) + ' - '
        signature = ' - For my virtual room at myWebRoom.com'

      when "THEME"
        mediaUrl =    $.trim($(".shop_image_name").attr('src'))
        description = $.trim($(".shop_name").text()) + ' - '
        signature = ' - For my virtual room at myWebRoom.com'



    description += $.trim($(".shop_description").text()) + signature
    results = baseUrl +
    encodeURIComponent(window.location.href) +
    '&media=' +
    encodeURIComponent(mediaUrl) +
    '&description=' +
    encodeURIComponent(description)

    return results


jQuery ->


  $(".shop_fb_btn").click (event) ->
    event.preventDefault() # Prevent link from following its href
    #console.log window.location.href
    window.open "https://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(window.location.href), "facebook-share-dialog", "width=626,height=436"



  $(".shop_pinterest_btn").click (event) ->

    event.preventDefault() # Prevent link from following its href
    #console.log  $(".shop_image_name").attr('src')
    #console.log $.trim($(".shop_name").text())
    #console.log $.trim($(".shop_description").text())
    #console.log $(".shop_upper_container").attr("data-shop-type")

    url = Pinterest.generatePinterestUrl()

#    console.log("url "+url)
    window.open(url,
      '_blank',
      'width=750,height=350,toolbar=0,location=0,directories=0,status=0'
    )





