Mywebroom.Helpers.LightboxHelper = {
  /****************************************
  Barebones Lightbox Template
  by Kyle Schaeffer
  http://www.kyleschaeffer.com
  * requires jQuery
  ****************************************/

  // display the lightbox
  lightbox: function(lbClass, shadowClass){

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


        // move the lightbox to the current window top + 200px
        $('#lightbox').css('top', $(window).scrollTop() + 200 + 'px');

        // display the lightbox
        $('#lightbox').show();
        $('#lightbox-shadow').show();

    })(jQuery); // end jQuery wrapper

  },




  ////
  //  this close and clean the feedback box from the Dom
  ////
  feedback_close_lightbox: function(){

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

  },




  ////
  //  Show the feedback submit Form
  ////
  feedback_lightbox: function(){

    // jQuery wrapper (optional, for compatibility only)
    (function($) {


    // add lightbox/shadow <div/>'s if not previously added
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
                        '<a id="feedback_close_btn" class="gray_button_light gray_button" href="javascript:Mywebroom.Helpers.LightboxHelper.feedback_close_lightbox();">Cancel</a>' +
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
        Mywebroom.Helpers.LightboxHelper.feedback_thk_lightbox();
    });

  },




  ////
  //  Show the feedback thankyou Form
  ////
  feedback_thk_lightbox: function(){

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


    // add lightbox/shadow <div/>'s if not previously added
        if($('#feedback_thk_lightbox').size() == 0){

            var theLightbox =  $('<div id="feedback_thk_lightbox"> ' +
                '<p id="feedback_thk_label_title">Thank You  for your feedback.</p>'+
                '<p id="feedback_thk_content">We appreciate your feedback and will continue to strive to make our website better. Thank you!</p>'+

                '<div id="feedback_thk_btn_container">' +
                    '<a id="feedback_close_btn" class="green_button_light green_button" href="javascript:Mywebroom.Helpers.LightboxHelper.feedback_close_lightbox();">Go to my Room</a>' +
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

  },




  login_lightbox_show: function(){

    var theShadow = $('<div id="login_lightbox-shadow"/>');
    $('body').append(theShadow);

    $('#login_lightbox').css('opacity', '1');
    $('#login_lightbox').css('top', '150px');
    $('#login_lightbox').css('z-index', '1511');

  },




  login_lightbox_hide: function(){

    $('#login_lightbox').css('top','-500px');
    $('#login_lightbox').css('opacity','0');
    $('#login_lightbox').css('z-index','1511');
    $('#login_lightbox-shadow').hide();
    $('#login_lightbox-shadow').empty();
    $('#login_lightbox-shadow').remove();

  },




  signup_lightbox_show: function(){

    var theShadow = $('<div id="signup_lightbox-shadow"/>');
    $('body').append(theShadow);

    $('#signup_lightbox').css('opacity', '1');
    $('#signup_lightbox').css('top', '150px');
    $('#signup_lightbox').css('z-index', '1511');

  },




  signup_lightbox_hide: function(){

    $('#signup_lightbox').css('top', '-500px');
    $('#signup_lightbox').css('opacity', '0');

    $('#signup_lightbox').css('z-index', '1511');

    $('#signup_lightbox-shadow').hide();
    $('#signup_lightbox-shadow').empty();
    $('#signup_lightbox-shadow').remove();

  },




  signup_lightbox_term_of_use_hide: function(){

    $('#signup_term_of_use').css('display', 'none');
    $('#signup_term_of_use').css('top', '-1000px');

  },




  signup_lightbox_term_of_use_show: function(){

    $('#signup_term_of_use').css('display', 'block');
    $('#signup_term_of_use').css('top', '20px');

  }



};
