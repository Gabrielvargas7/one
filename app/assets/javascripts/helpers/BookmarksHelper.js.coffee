Mywebroom.Helpers.BookmarksHelper = {




  createBookmarksView: (itemModel, DomItemId) ->

    switch (itemModel.get('id'))

      when 2 #BirdCage
      #Open Popup and on close, go to website.
      #1. Get popupUrl
        urlToPopup = Mywebroom.State.get('staticContent').findWhere({"name": "twitter-external-site-popup"})
        urlToPopup = urlToPopup.get('image_name').url if urlToPopup

      #2. Set Data: coordinates, button text, url

        itemModel.set('urlToPopup', urlToPopup)
        itemModel.set('buttonText', "Continue")
        coordinates = itemModel.get('coordinates')

      #3. Create View. View handles external link opening.
        twitterPopupView = new Mywebroom.Views.PopupExternalSiteWarningView({
          itemData:    itemModel
          coordinates: coordinates
          externalUrl: "http://www.twitter.com"
        })
      #4. Render View
        twitterPopupView.render().el
        $('#room_bookmark_item_id_container_' + DomItemId).append(twitterPopupView.el)

      #A4(i) Detect if Popup view is in viewport and adjust
        twitterPopupView.detectViewportAndCenter()



      when 20 #Pinboard
      #Open Popup and on close, go to website.
      #1. Get popupUrl
        urlToPopup = Mywebroom.State.get('staticContent').findWhere({"name": "pinboard-external-site-popup"})
        urlToPopup = urlToPopup.get('image_name').url if urlToPopup

      #2. Set Data: coordinates, button text, url

        itemModel.set('urlToPopup',urlToPopup)
        itemModel.set('buttonText',"Continue")
        coordinates = itemModel.get('coordinates')

      #3. Create View. View handles external link opening.
        pinboardPopupView = new Mywebroom.Views.PopupExternalSiteWarningView({
          itemData:    itemModel
          coordinates: coordinates
          externalUrl: "http://www.pinterest.com"
        })
      #4. Render View
        pinboardPopupView.render().el
        $('#room_bookmark_item_id_container_' + DomItemId).append(pinboardPopupView.el)

      #A4(i) Detect if Popup view is in viewport and adjust
        pinboardPopupView.detectViewportAndCenter()

      when 21 #Portrait
        # Open Profile, not Bookmarks.
        Mywebroom.State.get('roomHeaderView').displayProfile()

      else #All other Items- create Bookmarks View
        view = new Mywebroom.Views.BookmarksView(
          {
            items_name:       itemModel.get("name_singular")
            item_id:          itemModel.get("id")
            user:             Mywebroom.State.get("roomUser").get("id")
          }
        )

        $('#room_bookmark_item_id_container_' + DomItemId).append(view.el)
        view.render()




}
