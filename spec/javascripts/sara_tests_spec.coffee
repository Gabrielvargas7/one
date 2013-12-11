
describe("Sara Collections", ->
  describe("IndexBookmarksCategoriesByItemId", ->
    beforeEach( ->
      this.testCollection = new Mywebroom.Collections.IndexBookmarksByBookmarksCategoryId([], {categoryId: 101});
      
    )
    it("should be defined", ->
      expect(this.testCollection).toBeDefined()
      )
  ))

describe "Profile View", ->
  beforeEach ->
    #need to mock user info.
    #need to mock roomheaderview? or need to fail without roomheader view.
    Mywebroom.State.set("roomState","SELF")
    user = new Backbone.Model({id:24,firstname:"Sara"})
    # get('user_photos').image_name.url

    userPhotos = {image_name:{url:""}}
    
    user.set("user_photos",userPhotos) #for render test

    roomData = new Backbone.Model({user:user})
    Mywebroom.State.set("roomData",new Backbone.Model({}))
    Mywebroom.State.get("roomData").set("user_profile",user)

    viewModel= new Backbone.Model({user_photos:userPhotos,user:{}})
    this.profileView = new Mywebroom.Views.ProfileHomeView(model:viewModel)

  describe "defined", ->
    it "should be defined", ->
      expect(this.profileView).toBeDefined()
  describe "render", ->
    describe "Gets data", ->
      it "should call showHomeGrid", ->
        # maybe make spy to insure correct function is called?
        #expect
        spyOn(this.profileView,"showHomeGrid")
        this.profileView.render();
        expect(this.profileView.showHomeGrid).toHaveBeenCalled();

    it "should render", ->
      expect(this.profileView.render()).toBeTruthy()