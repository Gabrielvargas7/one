



$(document).ready(function() {


    $('.shop_let_me_see_on_my_room_btn').click(function(event){
        alert('shop_let_me_see_on_my_room_btn');
        event.preventDefault(); // Prevent link from following its href
    });

    $('.shop_fb_btn').click(function(event){
        event.preventDefault(); // Prevent link from following its href

        console.log(window.location.href)
        window.open(
            'https://www.facebook.com/sharer/sharer.php?u=' +
                encodeURIComponent(window.location.href),
            'facebook-share-dialog',
            'width=626,height=436'
        )

    });

    $('.shop_pinterest_btn').click(function(event){
        alert('shop_pinterest_btn');
        event.preventDefault(); // Prevent link from following its href
    });


});