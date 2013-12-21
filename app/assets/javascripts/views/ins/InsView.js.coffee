class Mywebroom.Views.InsView extends Backbone.View

  template: JST['ins/InsViewTemplate']


  render: ->

    this.$el.empty().append(@template({model: @model}))
    this


  events: {
    'click .ins-button': 'continue'
    'click .ins-close':  'close'
  }


  continue: ->


    #console.log('ins lightbox clicked!')


    if not @model.has("position")

      console.error("model without type", @model)




    else

      position = @model.get("position")


      switch position

        when 1
          false
          #console.log("bookmark - don't open store")

        when 2
          false
          #console.log("design - open store")

          # Design
          Mywebroom.Helpers.EditorHelper.showStore()

        when 3
          #console.log("theme - open store, show theme tab")

          # Theme
          Mywebroom.Helpers.EditorHelper.showStore()

          # Switch to Theme Tab
          $('a[href="#tab_themes"]').tab('show')




    $('#lightbox').hide()
    $('#lightbox-shadow').hide()

    $('#lightbox').empty()
    $('#lightbox-shadow').empty()

    $('#lightbox').remove()
    $('#lightbox-shadow').remove()




  close: ->

    $('#lightbox').hide()
    $('#lightbox-shadow').hide()

    $('#lightbox').empty()
    $('#lightbox-shadow').empty()

    $('#lightbox').remove()
    $('#lightbox-shadow').remove()
