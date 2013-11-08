###
returns { signed: "yes" } or { signed: "not" }
###
class Mywebroom.Models.ShowIsSignedUserModel extends Backbone.Model

  url: ->
    '/users/json/is_signed_user.json'
