
describe("Editor Helper", ->


  describe("filterKeyword", ->


    it("should handle null", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(null)).toEqual("")
    )


    it("sholld handle undefined", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(undefined)).toEqual("")
    )


    it("should handle NaN", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(NaN)).toEqual("")
    )


    it("should handle booleans", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(true)).toEqual("")
      expect(Mywebroom.Helpers.Editor.filterKeyword(false)).toEqual("")
    )


    it("should handle numbers", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(7)).toEqual("7")
    )


    it("should handle decimals", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword(3.1415927)).toEqual("3 1415927")
    )


    it("should do nothing to words without special characters", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("Wayfair")).toEqual("Wayfair")
    )


    it("should do nothing to words without special characters but trailing / leading spaces", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("  Wayfair  ")).toEqual("Wayfair")
    )


    it("should handle empty string", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("")).toEqual("")
    )


    it("should strip 1 special character", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("Joss & main 123")).toEqual("Joss   main 123")
    )


    it("should strip many special characters", ->
      expect(Mywebroom.Helpers.Editor.filterKeyword("$$ Jo--ss &123& ma^^in @@")).toEqual("Jo  ss  123  ma  in")
    )

  )

)
