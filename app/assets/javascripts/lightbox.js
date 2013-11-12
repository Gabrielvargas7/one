/****************************************
 Barebones Lightbox Template
 by Kyle Schaeffer
 http://www.kyleschaeffer.com
 * requires jQuery
 ****************************************/

// display the lightbox
function lightbox(lbClass, shadowClass){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {

        // add lightbox/shadow <div/>'s if not previously added
        if($('#lightbox').size() == 0){
            

            if(lbClass){
                var theLightbox = $('<div id="lightbox"' + 'class=' + lbClass + '/>');
            } else {
                var theLightbox = $('<div id="lightbox"/>');
            }


            if(shadowClass){
                var theShadow = $('<div id="lightbox-shadow"' + 'class=' + shadowClass + '/>');
            } else {
                var theShadow = $('<div id="lightbox-shadow"/>');
            }

            

            $('body').append(theShadow);
            $('body').append(theLightbox);
        }

        // remove any previously added content
        $('#lightbox').empty();

        
        // move the lightbox to the current window top + 100px
        $('#lightbox').css('top', $(window).scrollTop() + 100 + 'px');

        // display the lightbox
        $('#lightbox').show();
        $('#lightbox-shadow').show();

    })(jQuery); // end jQuery wrapper

}
