
function signup_lightbox_show(){


    var theShadow = $('<div id="signup_lightbox-shadow"/>');
    $('body').append(theShadow);

    $('#signup_lightbox').css('opacity', '1')
    $('#signup_lightbox').css('top', '150px')
    $('#signup_lightbox').css('z-index', '1511')




}

function signup_lightbox_hide(){
    $('#signup_lightbox').css('top', '-500px')
    $('#signup_lightbox').css('opacity', '0')

    $('#signup_lightbox').css('z-index', '1511')

    $('#signup_lightbox-shadow').hide();
    $('#signup_lightbox-shadow').empty();
    $('#signup_lightbox-shadow').remove();
}

function signup_lightbox_term_of_use_hide(){
    $('#signup_term_of_use').css('display', 'none')
    $('#signup_term_of_use').css('top', '-1000px')
}

function signup_lightbox_term_of_use_show(){
    $('#signup_term_of_use').css('display', 'block')
    $('#signup_term_of_use').css('top', '20px')
}

