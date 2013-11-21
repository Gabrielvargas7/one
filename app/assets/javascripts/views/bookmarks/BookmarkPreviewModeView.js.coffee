class Mywebroom.Views.BookmarkPreviewModeView extends Backbone.View
  className:"preview_mode_wrap"
  template:JST['bookmarks/BookmarkPreviewModeTemplate']
  events:
    'click .preview_mode_title .close_button':'closeView'
    'click .preview_mode_save_button_wrap':'saveSite'
  render:->
    $(@el).html(@template(model:@model))
    #Sidebar Preview Template
    sidebarPreviewHTML= JST['bookmarks/BookmarkSidebarPreviewMode'](model:@model)
    $('.bookmark_menu').append(sidebarPreviewHTML)
    $('.discover_submenu_section').hide()
    #$(@el).css "width",$(window).width()-$('.bookmark_menu').width()
    #$(@el).css "left",$('.bookmark_menu').width()
    $('.preview_mode_saved').hide()
    that=this
    #NOTE this is jquery .on NOT Backbone.on
    $('.preview_mode_save_button_wrap').on('click',{that},@saveSite)
    this
  closeView:->
    this.trigger('closedView')
    #Close SidebarPreview Template
    $('#bookmark_sidebar_preview_mode').remove()
    $('.discover_submenu_section').show()
    $('.preview_mode_save_button_wrap').off()
    this.remove()
  saveSite:(event)->
    event.stopPropagation()
    event.preventDefault()
    event.data.that.trigger('PreviewMode:saveSite',event.data.that.model)
    #replace Save Site button with Saved button.
    #savedButtonHTML = JST['bookmarks/PreviewModeSaved']()
    $('.preview_mode_saved').show()
    $('.preview_mode_save_button').hide()