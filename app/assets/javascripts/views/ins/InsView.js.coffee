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
    

    switch position
      when 2
        # Design
        Mywebroom.Helpers.showStore()
      
      when 3
        # Theme
        Mywebroom.Helpers.showStore()

        # Switch to Theme Tab
        $('a[href="#tab_themes"]').tab('show')
