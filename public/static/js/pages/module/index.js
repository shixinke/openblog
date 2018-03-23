define(['fn', 'sortable'], function(fn, Sortable){
    var $ = fn.$;
    var layer = fn.layer;
    var options = {
        delBtn:$('.btn-del-row'),
        sortContainer:$('#sortable-container'),
        sortItem:'.sortable-item'
    };
    var init = function(){
        events();
    };


    var events = function() {
        options.delBtn.on('click', function(){
            var data = $(this).data();
            var $parent = $(this).parents('.module-list-item-box');
            fn.ajaxDelSubmit(data.url, {id : parseInt(data.id)}, {}, function(res){
                var result = res || {};
                if (result.code == 200) {
                    layer.msg('删除成功', {icon : 1}, function(){
                        $parent.remove();
                    });
                } else {
                    layer.msg('删除失败', {icon : 5})
                }
            })
        });

    };

    var sortItem = function(){


    };
    return {
        init:init
    }
})