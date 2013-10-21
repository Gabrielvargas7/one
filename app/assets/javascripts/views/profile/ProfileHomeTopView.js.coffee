class Mywebroom.Views.ProfileHomeTopView extends Backbone.View
  template:JST['profile/ProfileHomeTopTemplate']
  className:"profile_home_top_view"
  render: ->
    $(@el).html(@template(user_info:@model))
    this