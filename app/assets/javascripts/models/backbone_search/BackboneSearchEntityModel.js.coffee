class  Mywebroom.Models.BackboneSearchEntityModel extends Backbone.Model

  defaults:
    entityType       : false  # Types can be ITEM_DESIGN,PEOPLE,BOOKMARK
    displayTopName   : false  # PERSON = Lastname and Firtname
                              # ITEM_DESIGN = name of the item designs
                              # BOOKMARK = Title

    displayUnderName : false  # PERSON = username
                              # ITEM_DESIGN = the word object "Object"
                              # BOOKMARK = the word object "Bookmark"

    imageName        : false  #
    entityId         : false  # id of the item_designs or bookmark or user
    viewNum          : false  # is the number where is the view



  @ITEM_DESIGN = "ITEM_DESIGN"
  @PEOPLE = "PEOPLE"
  @BOOKMARK = "BOOKMARK"

  @DISPLAY_UNDER_NAME_BOOKMARK = "Bookmark"
  @DISPLAY_UNDER_NAME_OBJECT = "Object"

