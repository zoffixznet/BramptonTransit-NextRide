jQuery(function ($) {
    var max_height = 0;
    $('body > ul > li').each(function(){
        if ( $(this).height() > max_height ) {
            max_height = $(this).height();
        }
    });

    $('body > ul > li').height(max_height);
});