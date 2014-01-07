StaticPagesHomeLightBoxHelper = {
//playVideoLightbox

  ////
  //  this close and clean the play_video box from the Dom
  ////
  playVideoCloseLightbox: function(){

    // hide lightbox and shadow <div/>'s
    $('#play_video_lightbox').hide();
    $('#play_video_thk_lightbox').hide();
    $('#play_video-shadow').hide();

    // remove contents of lightbox in case a video or other content is actively playing
    $('#play_video_lightbox').empty();
    $('#play_video_lightbox').remove();

    $('#play_video_thk_lightbox').empty();
    $('#play_video_thk_lightbox').remove();

    $('#play_video-shadow').empty();
    $('#play_video-shadow').remove();

    //start the carosal
    $('.carousel').carousel('cycle');

  },




  ////
  //  Show the play_video submit Form
  ////
  playVideoLightbox: function(){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {


    // add lightbox/shadow <div/>'s if not previously added
        if($('#play_video_lightbox').size() == 0){

            var theLightbox =  $('<div id="play_video_lightbox"> ' +

                '<div id="play_video_iframe_wrap"> <iframe width="480" height="360" src="//www.youtube.com/embed/4Gccm4F0PzA?autoplay=1" frameborder="0" allowfullscreen></iframe></div>'+
                        '<a id="play_video_close_btn" class="blue_button blue_button_light" href="javascript:StaticPagesHomeLightBoxHelper.playVideoCloseLightbox();">Close</a>' +



                '</div>' +
                '');

            var theShadow = $('<div id="play_video-shadow"/>');



            $('body').append(theShadow);
            $('body').append(theLightbox);
        }

        // display the lightbox
        $('#play_video_lightbox').show();
        $('#play_video-shadow').show();

        //pause the carosal
        $('.carousel').carousel('pause');


    })(jQuery); // end jQuery wrapper

  }
};