expect = chai.expect


describe("Editor Helper", ->


  describe("filterKeyword", ->


    it("should handle null", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(null)).to.equal("")
    )


    it("sholld handle undefined", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(undefined)).to.equal("")
    )


    it("should handle NaN", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(NaN)).to.equal("")
    )


    it("should handle booleans", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(true)).to.equal("")
      expect(Mywebroom.Helpers.Editor.filterKeyword(false)).to.equal("")
    )


    it("should handle numbers", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(7)).to.equal("7")
    )


    it("should do nothing to words without special characters", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("Wayfair")).to.equal("Wayfair")
    )


    it("should do nothing to words without special characters but trailing / leading spaces", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("  Wayfair  ")).to.equal("Wayfair")
    )


    it("should handle empty string", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("")).to.equal("")
    )


    it("should strip 1 special character", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("Joss & main 123")).to.equal("Joss   main 123")
    )


    it("should strip many special characters", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("$$ Jo--ss &123& ma^^in @@")).to.equal("Jo  ss  123  ma  in")
    )

  )

)
