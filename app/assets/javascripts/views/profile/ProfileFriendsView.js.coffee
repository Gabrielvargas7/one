class Mywebroom.Views.ProfileFriendsView extends Backbone.View
  
  className:'profile_friends_view media'

  initialize: ->
    @friendsCollection = new Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection()
    @friendsTotal = Mywebroom.State.get('roomData').get('user_profile').friends_number
    #Fetch friends data for Profile Friends
    
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
    tableHeaderHTML = JST['profile/ProfileGridTableHeader'](headerName:"Friends ("+@friendsTotal+")")
    $(@el).html(tableHeaderHTML)
    if @friendsCollection.length is 0
      @template = JST['profile/ProfileNoFriendsTemplate']
      $(@el).append @template()
    else
      @friendsCollection.forEach(@friendsAddView,this)
      if @friendsTotal!= undefined and @friendsTotal > 26 #Totally a hack until we know what the limit is. 
        that = this
        $(@el).off('scroll').on('scroll',that,(event)->

          if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight-100
            event.data.paginate(event)            
            )
    this
  
  friendsAddView: (friend) ->
    friendView = new Mywebroom.Views.ProfileFriendsSingleView({model:friend,PUBLIC_FLAG:@model.get('FLAG_PROFILE')})
    that = this
    friendView.off('Profile:friendRemoved').on('Profile:friendRemoved',(->
      #Note, used to be find cid. But cid is not the same after pagination since I have a temp collection hold them. 
      @friendsCollection.remove(@friendsCollection.findWhere({'user_id':friendView.model.get('user_id')}))),that)
    $(@el).append(friendView.el)
    friendView.render()

  paginate: (event)->
    event.preventDefault()
    event.stopPropagation()

    #1. Increment offset
    event.data.offset += event.data.limit;
    
    #2. Fetch new items
    nextCollection = new Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection()
    nextCollection.fetch
      url:@friendsCollection.url event.data.model.get('user_id'), event.data.limit, event.data.offset
      async:false
      success: (response)->
       console.log("nextCollection Fetched Successfully")
       console.log(response)

    #3. Add to FriendsCollection so Menu Items still work   
    @friendsCollection.add(nextCollection.toJSON(),{silent:true})
    
    #4. Render the new friends loaded.
    nextCollection.forEach(@friendsAddView,this)

    #5. if there's no more to fetch, turn off event. 
    if event.data.offset >= event.data.friendsTotal
      $(@el).off('scroll');

