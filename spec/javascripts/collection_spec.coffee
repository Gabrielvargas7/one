#= require collections/bookmark_categories/IndexBookmarksCategoriesByItemId
#= require views/bookmarks/BookmarksView
expect = chai.expect


describe("Collection Fetching", ->

  describe("Bookmark Categories", ->

    it("should have a length of 5 for item 16", (done) ->
      cat = new Mywebroom.Collections.IndexBookmarksCategoriesByItemId([], {itemId: 16})

      cat.once('reset', ->
        expect(cat).to.have.length(5)
        done()
      )

      cat.fetch({reset: true})
    )

  )

)



###
describe("BookmarksView", ->

  it("should be able to call a method", (done) ->

    view = new Mywebroom.Views.BookmarksView()
    done()

  )

)
###
