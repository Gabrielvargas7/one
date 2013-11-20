function login_lightbox_show(){


    var theShadow = $('<div id="login_lightbox-shadow"/>');
    $('body').append(theShadow);

    $('#login_lightbox').css('opacity', '1')
    $('#login_lightbox').css('top', '150px')
    $('#login_lightbox').css('z-index', '1511')




}

function login_lightbox_hide(){
    $('#login_lightbox').css('top','-500px')
    $('#login_lightbox').css('opacity','0')
    $('#login_lightbox').css('z-index','1511')
    $('#login_lightbox-shadow').hide();
    $('#login_lightbox-shadow').empty();
    $('#login_lightbox-shadow').remove();
}



