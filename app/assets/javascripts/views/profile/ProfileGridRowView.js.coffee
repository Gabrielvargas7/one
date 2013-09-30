class Mywebroom.Views.ProfileGridRowView extends Backbone.View
	tagName:'tr'
	className:'profile_grid_row'
	initialize: ->
		@originalCollection=this.options.originalCollection
	render: ->
		$(@el).html()
		if @collection
			for item in @collection
				#Make new view with the model
				currentTableCell = new Mywebroom.Views.ProfileGridItemView({model:item,collection:@collection,originalCollection:@originalCollection})
				$(@el).append(currentTableCell.el)
				currentTableCell.render()
