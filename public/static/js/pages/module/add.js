define(['jquery', 'fn', 'layer'], function($, fn, layer){
    var options = {
        selectType:$('#type'),
        typeRow : $('.type-row')
    };
    var init = function(){
        events();
    };


    var events = function() {
        options.selectType.on('change', function(){
            var val = $(this).val();
            options.typeRow.hide();
            $('.type-row-'+val).show();
        });
    };

    return {
        init:init
    }
})