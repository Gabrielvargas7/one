expect = chai.expect

describe("Testing a view", ->

  before( ->

    this.$fixture = $("<div id='view-fixture'></div>")

  )


  beforeEach( ->

    this.$fixture.empty().appendTo($('#teaspoon-fixtures'))

    this.view = new Mywebroom.Views.StoreMenuSaveCancelRemoveView()
    this.$fixture.append(this.view.el)

    this.view.render()
  )



  afterEach( ->
    this.view.remove()
  )



  after( ->
    $("teaspoon-fixtures").empty()
  )

)
