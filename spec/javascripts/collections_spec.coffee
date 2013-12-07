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




)
