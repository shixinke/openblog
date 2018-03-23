define(['jquery', 'fn'], function($, fn, layer){

    var init = function(){
        events();
    };

    var events = function() {
        $("form").each(function () {
            fn.validateForm($(this).attr('id'));
        });
    }

    return {
        init:init
    }
})