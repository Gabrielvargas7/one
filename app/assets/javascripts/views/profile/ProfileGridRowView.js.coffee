class Mywebroom.Views.ProfileGridRowView extends Backbone.View
	tagName:'tr'
	className:'profile_grid_row'
	render: ->
		$(@el).html()
		if @collection
			for item in @collection
				#Make new view with the model
				currentTableCell = new Mywebroom.Views.ProfileGridItemView({model:item})
				$(@el).append(currentTableCell.el)
				currentTableCell.render()
