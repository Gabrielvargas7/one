

function feedback_lightbox(){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {
        alert("hi feed back")

//        add lightbox/shadow <div/>'s if not previously added
        if($('#feedback_lightbox').size() == 0){

            var theLightbox =  $('<div id="feedback_lightbox">' +
                '' +
                '' +
                '' +
                '</div>');
            var theShadow = $('<div id="feedback-shadow"/>');


            $('body').append(theShadow);
            $('body').append(theLightbox);
        }

        // remove any previously added content
        $('#feedback_lightbox').empty();

        // display the lightbox
        $('#feedback_lightbox').show();
        $('#feedback-shadow').show();

    })(jQuery); // end jQuery wrapper

}


