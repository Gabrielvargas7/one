#= require calculator
expect = chai.expect

test = new Calculator()


describe("this suite", ->
  it("does stuff", ->
    expect(test.foo).to.be.a('string')
    expect(test.foo).to.equal('bar')
    expect(test.foo).to.have.length(3)
    expect(test.beverages).to.have.property('tea').with.length(3)
  )
)
