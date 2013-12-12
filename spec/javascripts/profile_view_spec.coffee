
describe "Profile View", ->
  beforeEach ->
    #Create a Profile View
    #Create data for profile View
    Mywebroom.State.set("roomState","SELF")
    user = new Backbone.Model({id:24,firstname:"Sara"})
    userPhotos = {image_name:{url:""}}
    user.set("user_photos",userPhotos) #for render test
    roomData = new Backbone.Model({user:user})
    Mywebroom.State.set("roomData",new Backbone.Model({}))
    Mywebroom.State.get("roomData").set("user_profile",user)

    viewModel = new Backbone.Model({user_photos:userPhotos,user:{}})
    this.profileView = new Mywebroom.Views.ProfileHomeView(model:viewModel)

  describe "defined", ->
    it "should be defined", ->
      expect(this.profileView).toBeDefined()

  describe "render", ->

    describe "Gets data", ->
      it "should call showHomeGrid", ->
        # maybe make spy to insure correct function is called
        spyOn(this.profileView,"showHomeGrid")
        this.profileView.render()
        expect(this.profileView.showHomeGrid).toHaveBeenCalled()
        #expect("")
      xit "should have 6 grid items", ->
        this.profileView.render()
        expect(this.profileView.$el(".gridItem").length).toEqual(6)


    it "should render", ->
      expect(this.profileView.render()).toBeTruthy()

    xdescribe "General Profile View events", ->
      it "closes on x click by hiding the view" , ->
        expect(ddisplayPropertyinEl).toEqual("none")

      it "collapses on < click and the css is right",->
        expect(cssonView).toEqual("right")

    xdescribe "ProfileHomeView Events", ->
      it "shows social view on hover", ->
        expect(socialEl).toBeDefined
        expect(hoverItemSocialCSS).not.toEqual("display:none")
      
      xdescribe "Social Event", ->
        it "generates url when click facebook", ->
          expect(generateUrl).toHaveBeenCalled()
          expect(generateUrl).toContain(item.url)
        it "generates url when click Punterest", ->
        it "goes to info page when click info", ->

      xdescribe "Large Item View", ->
        it "shows the large item view",->
          expect(clickToMakeLargeView).toBeDefined()
        it "has social", ->
          expect(socialItemjQuery).not.toEqual(0)
        xdescribe "Social Events" , ->
          expect()
        xdescribe "Try it and Add it", ->
          it "adds bookmark after click", ->
            expect(bookmarkAdd).toHaveBeenCalled()
          it "redirects after click Try It in My Room", ->
            expect(clickEvent) toRedirect

  xdescribe "Profile Photos View" , ->
    describe "Renders",->
      it "renders Photos View after click", ->
        expect(clickPhotosView).toBeDefined()
      it "has the correct top template", ->
      xit "has a scroll bar if needed", ->
        expect()

    xdescribe "Photos events", ->
      it "does not show social on hover", ->
        expect(hoverItemEventSocialNode).toEqual(0)
      xdescribe "Photos Large View", ->
        it "uses correct template", ->
          expect(viewTemplate).toBe(JST(PhotosTemplate))
          expect(socialNode).toBe(0)
      xdescribe "closes correctly", ->
        it "closes properly and events are removed"

  xdescribe "Profile Requests", ->
  xdescribe "Profile Friends", ->
  xdescribe "Profile Activity", ->
  xdescribe "Profile Bookmarks", ->
  xdescribe "Profile Objects", ->
