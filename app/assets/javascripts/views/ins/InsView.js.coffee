class Mywebroom.Views.InsView extends Backbone.View
  
  template: JST['ins/InsViewTemplate']
  
  
  initialize: ->  
    this.bind("ok", @okClicked)
  
  
  render: ->
    
    this.$el.html(@template(model: @model))
    this
    
    
  okClicked: (modal) ->
    
    if not @model.get("position")
      throw new Error("model without type")
    
    
    position = @model.get("position")
    
    if position is 2 or position is 3 then Mywebroom.Helpers.showStore()
