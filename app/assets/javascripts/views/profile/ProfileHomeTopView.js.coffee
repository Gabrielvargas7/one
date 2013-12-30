class Mywebroom.Views.ProfileHomeTopView extends Backbone.View
  template: JST['profile/ProfileHomeTopTemplate']
  className: 'profile_home_top_view'
  events: {
    'click .profile_request_key_button': 'askForKey'
  }

  initialize: ->
    if @model
      # Modify created_at property to be month and date
      monthNamesShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
      memberSince = new Date(@model.get('created_at'))
      if memberSince
        newMemberSince = monthNamesShort[memberSince.getMonth()] + ' ' + memberSince.getUTCFullYear()
        @model.set('member_since', newMemberSince, {silent: true})

  render: ->
    $(@el).html(@template({user_info: @model.toJSON()}))

    if(@model.get("FLAG_PROFILE") is "PUBLIC")
      if Mywebroom.Helpers.AppHelper.IsThisMyFriendRequest(Mywebroom.State.get('roomUser').get('id'))
        @.$('.profile_request_key_button').hide()
        #console.log 'hide key requested'
      else
        @.$('.profile_key_requested').hide()
        #console.log 'show key requested'

    this

  askForKey: (event) ->
    # Key Request
    Mywebroom.Helpers.AppHelper.RequestKey(@model.get('user_id'))
    # Since the template is a class instead of ID, we need to handle the styling here
    $('.profile_request_key_button').hide()
    $('.profile_key_requested').show()
