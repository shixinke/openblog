define(['fn'], function(fn){
    var $ = fn.$;
    var layer = fn.layer;
    var options = {
        imgListBox:$('#uploaded-file-list'),
        imgItem:$('#uploaded-file-list dd'),
        checkAll:$('#check-all'),
        isMulti:$('#uploaded-file-list').data('multi') == '1' ? true : false

    };
    var init = function(){
        events();
    };

    var events = function() {
        options.imgItem.on('click', function(){
            if ($(this).hasClass('active')) {
                $(this).removeClass('active');
            } else {
                if (!options.isMulti) {
                    $(this).addClass('active').siblings('dd').removeClass('active');
                } else {
                    $(this).addClass('active');
                }
            }
        });
        options.checkAll.on('click', function(){
            if (this.checked) {
                options.imgItem.addClass('active');
            } else {
                options.imgItem.removeClass('active');
            }
        });
    };

    var arrToObject = function(arr, index){
        var obj = {};
        for(var i=0; i< arr.length; i++) {
            if (arr[i][index]) {
                obj[arr[i][index]] = arr[i];
            }
        }
        return obj;
    };


    return {
        init:init
    }
});