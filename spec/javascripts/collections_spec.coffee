#= require collections/bookmark_categories/IndexBookmarksCategoriesByItemId
#= require collections/bookmarks/IndexBookmarksByBookmarkCategoryId
expect = chai.expect


describe("Collections", ->




  describe("IndexBookmarksCategoriesByItemId", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexBookmarksCategoriesByItemId([], {itemId: 16})
      this.emptyCollection = new Mywebroom.Collections.IndexBookmarksCategoriesByItemId([], {itemId: 99})
    )

    after( ->
      this.collection = null
      this.emptyCollection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/bookmarks_categories/json/index_bookmarks_categories_by_item_id/16.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(5)
        done()
      )

      this.collection.fetch({reset: true})
    )

    it("should be empty when the item doesn't exist in the database", (done) ->

      this.emptyCollection.once('reset', ->
        expect(this).to.have.length(0)
        done()
      )

      this.emptyCollection.fetch({reset: true})
    )

  )




  describe("IndexBookmarksByBookmarkCategoryId", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexBookmarksByBookmarksCategoryId([], {categoryId: 101})
      this.emptyCollection = new Mywebroom.Collections.IndexBookmarksByBookmarksCategoryId([], {categoryId: 1})
    )

    after( ->
      this.collection = null
      this.emptyCollection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/bookmarks/json/index_bookmarks_by_bookmarks_category_id/101.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(13)
        done()
      )

      this.collection.fetch({reset: true})
    )

    it("should be empty when the item doesn't exist in the database", (done) ->

      this.emptyCollection.once('reset', ->
        expect(this).to.have.length(0)
        done()
      )

      this.emptyCollection.fetch({reset: true})
    )

  )




  describe("IndexBookmarksWithBookmarksCategoryByItemIdCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection([], {itemId: 1})
      this.emptyCollection = new Mywebroom.Collections.IndexBookmarksWithBookmarksCategoryByItemIdCollection([], {itemId: 99})
    )

    after( ->
      this.collection = null
      this.emptyCollection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/bookmarks/json/index_bookmarks_with_bookmarks_category_by_item_id/1.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(46)
        done()
      )

      this.collection.fetch({reset: true})
    )

    it("should be empty when the item doesn't exist in the database", (done) ->

      this.emptyCollection.once('reset', ->
        expect(this).to.have.length(0)
        done()
      )

      this.emptyCollection.fetch({reset: true})
    )

  )




  describe("IndexRandomBookmarksByLimitByOffsetCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexRandomBookmarksByLimitByOffsetCollection([], {limit: 10, offset: 0})
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/bookmarks/json/index_random_bookmarks_by_limit_by_offset/10/0.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(10)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )




  describe("IndexBundlesByLimitAndOffsetCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexBundlesByLimitAndOffsetCollection([], {limit: 10, offset: 0})
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/bundles/json/index_bundles_by_limit_and_offset/10/0.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(10)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )



  describe("IndexBundlesCategoriesCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexBundlesCategoriesCollection()
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url).to.equal('/bundles/json/index_bundles_categories.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(1)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )




  describe("IndexBundlesCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexBundlesCollection()
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url).to.equal('/bundles/json/index_bundles.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(10)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )





  describe("IndexEntireRoomsByLimitAndOffsetCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexEntireRoomsByLimitAndOffsetCollection([], {limit: 10, offset: 0})
    )

    after( ->
      this.collection = null
      this.emptyCollection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/bundles/json/index_bundles_by_limit_and_offset/10/0.json')
    )

    it("should return data for items in the database", (done) ->


      this.collection.once('reset', ->
        expect(this).to.have.length(10)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )




  describe("IndexFriendRequestMakeFromYourFriendToYouByUserIdCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexFriendRequestMakeFromYourFriendToYouByUserIdCollection([], {userId: 18327})
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/friend_requests/json/index_friend_request_make_from_your_friend_to_you_by_user_id/18327.json')
    )

    it("should be empty when the item doesn't exist in the database", (done) ->

      this.collection.once('reset', ->
        expect(this).to.have.length(0)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )




  describe("ShowFriendRequestByUserIdAndUserIdRequestedCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.ShowFriendRequestByUserIdAndUserIdRequestedCollection([], {userId: 18327, userIdRequested: 7247})
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/friend_requests/json/show_friend_request_by_user_id_user_id_requested/18327/7247.json')
    )

    it("should be empty when the item doesn't exist in the database", (done) ->

      this.collection.once('reset', ->
        expect(this).to.have.length(0)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )




  describe("IndexFriendByUserIdByLimitByOffsetCollection", ->

    before( ->
      this.collection = new Mywebroom.Collections.IndexFriendByUserIdByLimitByOffsetCollection([], {userId: 18327, limit: 27, offset: 0})
    )

    after( ->
      this.collection = null
    )

    it("should be able to be instantiated", ->
      expect(this.collection).to.be.an('object')
    )

    it("should get the right url", ->
      expect(this.collection.url()).to.equal('/friends/json/index_friend_by_user_id_by_limit_by_offset/18327/27/0.json')
    )

    it("should return data for items in the database", (done) ->

      this.collection.once('reset', ->
        expect(this).to.have.length(7)
        done()
      )

      this.collection.fetch({reset: true})
    )

  )

)
