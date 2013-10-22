class Mywebroom.Collections.IndexItemsDesignsCategoriesByItemIdCollection extends Backbone.Collection

  url: (itemId) ->
    '/items_designs/json/index_items_designs_categories_by_item_id/' + itemId + '.json'
