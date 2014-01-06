Mywebroom.Helpers.ProfileHelper = {
  showProfile:->
    #get Room Header View with profile View. 
    Mywebroom.State.get('roomHeaderView').displayProfile() if Mywebroom.State.get('roomHeaderView')

  hideProfile:->
    Mywebroom.State.get('roomHeaderView').hideProfile() if Mywebroom.State.get('roomHeaderView')
}