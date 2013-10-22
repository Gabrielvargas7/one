class Mywebroom.Views.InsView extends Backbone.View
  
  ###
  TEMPLATE
  ###
  template: JST['ins/InsViewTemplate']
  

  ###
  RENDER
  ###
  render: ->
    
    $(@el).append(@template(model: @model))
