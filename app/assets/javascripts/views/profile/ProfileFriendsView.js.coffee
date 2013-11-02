class Mywebroom.Views.ProfileFriendsView extends Backbone.View
  
  className:'profile_friends_view media'

  events:
    'click #friends_show_more a':'showMore'

  initialize: ->
    @friendsCollection = new Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection()
    @friendsTotal = Mywebroom.State.get('roomData').get('user_profile').friends_number
   # Fetch friends data for Profile Friends
    
    @limit = 26;
    @offset = 0;
    @friendsCollection.fetch
      url:@friendsCollection.url @model.get('user_id'), 26, 0
      async:false
      success: (response)->
       console.log("FriendsCollection Fetched Successfully")
       console.log(response)
    this.listenTo(@friendsCollection,'remove',@render)
  render: ->
    tableHeaderHTML = JST['profile/ProfileGridTableHeader'](headerName:"Friends ("+@friendsCollection.length+")")
    $(@el).html(tableHeaderHTML)
    if @friendsCollection.length is 0
      @template = JST['profile/ProfileNoFriendsTemplate']
      $(@el).append @template()
    else
      @friendsCollection.forEach(@friendsAddView,this)
      if @friendsTotal!= undefined and @friendsTotal > 26 #Totally a hack until we know what the limit is. 
        $(@el).append("<div id='friends_show_more'><a href='#showMore'>Show More</a></div>")
    this
  
  friendsAddView: (friend) ->
    friendView = new Mywebroom.Views.ProfileFriendsSingleView({model:friend,PUBLIC_FLAG:@model.get('FLAG_PROFILE')})
    that = this
    friendView.on('Profile:friendRemoved',(->
      @friendsCollection.remove(friendView.model)),that)
    $(@el).append(friendView.el)
    friendView.render()

  showMore: (event)->
    event.preventDefault()
    event.stopPropagation()
    @offset += @limit;
    nextCollection = new Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection()
    nextCollection.fetch
      url:@friendsCollection.url @model.get('user_id'), @limit, @offset
      async:false
      success: (response)->
       console.log("nextCollection Fetched Successfully")
       console.log(response)

    @.$('#friends_show_more').remove()
    
    #render the new friends loaded.
    nextCollection.forEach(@friendsAddView,this)

    #if there's still more to fetch, add show more button. 
    if @offset < @friendsTotal
      $(@el).append("<div id='friends_show_more'><a href='#showMore'>Show More</a></div>")


