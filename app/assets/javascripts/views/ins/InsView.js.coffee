class Mywebroom.Views.InsView extends Backbone.View
  
  template: JST['ins/InsViewTemplate']
  
  
  render: ->
    
    this.$el.html(@template({model: @model}))
    this
    

  events: {
    'click .lighbox-ins': 'onClick'
  }

    
  onClick: ->
    

    console.log('ins lightbox clicked!')


    if not @model.has("position")
      
      console.error("model without type", @model)

    


    else
    
      position = @model.get("position")
      

      switch position

        when 1
          console.log("bookmark - don't open store")
        
        when 2
          console.log("design - open store")
          
          # Design
          Mywebroom.Helpers.showStore()
        
        when 3
          console.log("theme - open store, show theme tab")
          
          # Theme
          Mywebroom.Helpers.showStore()

          # Switch to Theme Tab
          $('a[href="#tab_themes"]').tab('show')




    $('#lightbox').hide()
    $('#lightbox-shadow').hide()
    
    $('#lightbox').empty()
    $('#lightbox-shadow').empty()

    $('#lightbox').remove()
    $('#lightbox-shadow').remove()