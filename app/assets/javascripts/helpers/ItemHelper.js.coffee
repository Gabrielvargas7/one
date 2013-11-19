class Mywebroom.Helpers.ItemHelper extends Backbone.Model

  #--------------------------
  # Retrieve the signed in user id.
  #--------------------------
  getUserId: ->
    userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
    userSignInCollection.fetch async: false
    userSignInCollection.models[0].get('id')
