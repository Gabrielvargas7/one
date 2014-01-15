# expect = chai.expect

# # Fixtures
# fixture.preload("fixture.html", "fixture.json")

# describe("Using fixtures", ->

#   fixture.set("<h2>Another Title</h2>")

#   beforeEach( ->
#     @fixtures = fixture.load("fixture.html", "fixture.json", true)
#   )

#   it("loads fixtures", ->

#     expect(document.getElementById("test").tagName).to.equal("DIV")
#     expect($('#test', fixture.el).text()).to.equal("Hello, World!")
#     expect(@fixtures[0]).to.equal(fixture.el)
#     expect(@fixtures[1]).to.eql(fixture.json[0]) # Note: using .equal() would fail because that does a deep equals
#     expect(@fixtures[1].foo).to.equal('bar')

#   )

# )
