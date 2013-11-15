

function feedback_close_lightbox(){

    // hide lightbox and shadow <div/>'s
    $('#feedback_lightbox').hide();
    $('#feedback-shadow').hide();

    // remove contents of lightbox in case a video or other content is actively playing
    $('#feedback_lightbox').empty();
}


function feedback_lightbox(){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {


//        add lightbox/shadow <div/>'s if not previously added
        if($('#feedback_lightbox').size() == 0){

            var theLightbox =  $('<div id="feedback_lightbox"> ' +
                '<p id="feedback_label_title">Please feel free to leave us feeedback</p>'+
                '<form action="" method="POST">' +
                    '<label id="feeedback_label_name">Name/Email</label>'+
                    '<input name="name" type="text">'+
                    '<label id="feeedback_label_comment">Comment</label>'+
                    '<textarea name="comment" rows="8"></textarea>'+
                    '<br/>'+
                    '<div id="feedback_btn_container">' +
                        '<a id="feedback_close_btn" class="blue_button_light blue_button" href="javascript:feedback_close_lightbox();">Close feedback</a>' +
                        '<input class="green_button green_button_light" name="commit" type="submit" value="Send Feedback">'+
                    '</div>'+
                '</form>'+
                '</div>' +
                '');

            var theShadow = $('<div id="feedback-shadow"/>');



            $('body').append(theShadow);
            $('body').append(theLightbox);
        }

        // display the lightbox
        $('#feedback_lightbox').show();
        $('#feedback-shadow').show();


    })(jQuery); // end jQuery wrapper

}

