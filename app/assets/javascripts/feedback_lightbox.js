
////
//  this close and clean the feedback box from the Dom
////
function feedback_close_lightbox(){

    // hide lightbox and shadow <div/>'s
    $('#feedback_lightbox').hide();
    $('#feedback_thk_lightbox').hide();
    $('#feedback-shadow').hide();

    // remove contents of lightbox in case a video or other content is actively playing
    $('#feedback_lightbox').empty();
    $('#feedback_lightbox').remove();

    $('#feedback_thk_lightbox').empty();
    $('#feedback_thk_lightbox').remove();

    $('#feedback-shadow').empty();
    $('#feedback-shadow').remove();

}


////
//  Show the feedback submit Form
////

function feedback_lightbox(){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {


//        add lightbox/shadow <div/>'s if not previously added
        if($('#feedback_lightbox').size() == 0){

            var theLightbox =  $('<div id="feedback_lightbox"> ' +
                '<p id="feedback_label_title">Please feel free to leave us feedback.</p>'+
                '<form action="/feedbacks/json/create_feedback" data-remote="true" id="feedback_form" method="POST">' +
                    '<label id="feedback_label_name">Name/Email</label>'+
                    '<input name="name" type="text">'+
                    '<label id="feedback_label_comment">Comment</label>'+
                    '<textarea name="description" rows="8"></textarea>'+
                    '<br/>'+
                    '<div id="feedback_btn_container">' +
                        '<a id="feedback_close_btn" class="gray_button_light gray_button" href="javascript:feedback_close_lightbox();">Cancel</a>' +
                        '<input id="feedback_send_btn" class="green_button green_button_light" name="commit" type="submit" value="Send">'+

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


    $( "#feedback_form" ).submit(function( event ) {
        event.preventDefault();
        feedback_thk_lightbox()
    });


}

////
//  Show the feedback thankyou Form
////


function feedback_thk_lightbox(){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {

        // hide lightbox and shadow <div/>'s
        $('#feedback_lightbox').hide();
        $('#feedback-shadow').hide();

        // remove contents of lightbox in case a video or other content is actively playing
        $('#feedback_lightbox').empty();
        $('#feedback_lightbox').remove();
        $('#feedback-shadow').empty();
        $('#feedback-shadow').remove();


//        add lightbox/shadow <div/>'s if not previously added
        if($('#feedback_thk_lightbox').size() == 0){

            var theLightbox =  $('<div id="feedback_thk_lightbox"> ' +
                '<p id="feedback_thk_label_title">Thank You  for your feedback.</p>'+
                '<p id="feedback_thk_content">We appreciate your feedback and will continue to strive to make our website better. Thank you!</p>'+

                '<div id="feedback_thk_btn_container">' +
                    '<a id="feedback_close_btn" class="green_button_light green_button" href="javascript:feedback_close_lightbox();">Go to my Room</a>' +
                '</div>'+

                '</div>' +
                '');

            var theShadow = $('<div id="feedback-shadow"/>');



            $('body').append(theShadow);
            $('body').append(theLightbox);
        }

        // display the lightbox
        $('#feedback_thk_lightbox').show();
        $('#feedback-shadow').show();


    })(jQuery); // end jQuery wrapper

}


