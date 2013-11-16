class Mywebroom.Views.ProfileGridItemView2 extends Marionette.ItemView

  tagName:'div'

  className:'gridItemWrap'

  template:JST['profile/ProfileGridItemTemplate2']

  events: {
    'mouseenter .gridItem': 'showSocialBarView'
    'mouseleave .gridItem': 'closeSocialBarView'
    'click .gridItem':      'getGridItemModel'
  }

  onRender: ->

    #Depending on Model Type, show social view
    if @model.get('type') is 'PHOTO'
      #don't create social view.
      return

    else
      @socialBarView = new Mywebroom.Views.SocialBarView(model: @model)

      $(@el).children(".gridItem").children(".gridItemPicture").append(@socialBarView.el)

      @socialBarView.render()
      @socialBarView.hide()


  showSocialBarView: (event) ->
    @socialBarView.show() if @socialBarView


  closeSocialBarView: ->
    @socialBarView.hide() if @socialBarView


  getGridItemModel: (event) ->

    this.trigger('gridItemLargeView', @model)
    event.stopPropagation()
    dataID = event.currentTarget.dataset.id
    #console.log("You clicked a grid Item in ProfileGridItemView " + this.model.get('id'))
    # gridItem is either Activity Item or Photo. Determine which.
