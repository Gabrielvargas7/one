class Mywebroom.Helpers.ItemHelper extends Backbone.Model

  helperTwo: ->
    alert("helper two")

  helperOne: ->
    alert("helper one")
	#--------------------------
# Retrieve the signed in user id. 
#--------------------------
  getUserId:->
  	userSignInCollection = new Mywebroom.Collections.ShowSignedUserCollection()
  	userSignInCollection.fetch async: false
  	userSignInCollection.models[0].get('id')
  