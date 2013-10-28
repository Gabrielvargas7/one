class Mywebroom.Views.ProfileHomeTopView extends Backbone.View
  template:JST['profile/ProfileHomeTopTemplate']
  className:"profile_home_top_view"
  initialize:->
    if @model
      #modify created_at property to be month and date.
      monthNamesShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      memberSince = new Date(@model.get('created_at'))
      if memberSince
        newMemberSince = monthNamesShort[memberSince.getMonth()] + ' ' + memberSince.getUTCFullYear()
        @model.set('member_since',newMemberSince,{silent:true})
  render: ->
    $(@el).html(@template(user_info:@model))
    this