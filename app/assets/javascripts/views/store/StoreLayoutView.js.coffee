###
This view represents the div that holds the main store page and it's collapse bar.
At this point, the view for the collapse bar has already been created at attached
to the #store_main_box_left element of this view's template.

Since that view has already been created, this view just creates the menu view,
but it also listens to clicks on the children elements of the collapse bar view.
###
class Mywebroom.Views.StoreLayoutView extends Backbone.View


  #*******************
  #**** Template
  #*******************
  template: JST['store/StoreLayoutTemplate']


  #*******************
  #**** Events
  #*******************
  events: {
    'click #store_close_button':    'clickClose'
    'click #store_collapse_button': 'clickCollapse'
  }


  #*******************
  #**** Render
  #*******************
  render: ->

    # THIS VIEW
    $(@el).html(@template())



    # STORE MENU VIEW
    view = new Mywebroom.Views.StoreMenuView()
    $('.store_main_box_right').html(view.el)
    view.render()


    # Listen for editor scroll
    Mywebroom.Helpers.EditorHelper.onEditorScroll()


    # Store a reference
    Mywebroom.State.set("storeMenuView", view)



    this




  #--------------------------
  # close store page
  #--------------------------
  clickClose: (event) ->

    event.preventDefault()
    event.stopPropagation()

    ###
    Display a confirm dialog if there are any un-saved changes
    ###
    if $("[data-design-has-changed=true]").size() > 0 or $("[data-theme-has-changed=true]").size() > 0

      bootbox.confirm("Leaving this screen will not save your changes", (result) ->

        if result

          # Change All DOM properties back to their original
          Mywebroom.Helpers.cancelChanges()


          # Proceed with hiding the store
          Mywebroom.Helpers.EditorHelper.hideStore()
      )
    else

      # Hide the store
      Mywebroom.Helpers.EditorHelper.hideStore()






  #--------------------------
  # collapse store page
  #--------------------------
  clickCollapse: (event) ->

    event.preventDefault()
    event.stopPropagation()

    state = Mywebroom.State.get("storeState")

    switch state

      when "shown"
        Mywebroom.Helpers.EditorHelper.collapseStore()
      when "collapsed"
        Mywebroom.Helpers.EditorHelper.expandStore()
