define(['fn', 'sortable'], function(fn, Sortable){
    var $ = fn.$;
    var layer = fn.layer;
    var options = {
        setBtn:$('.theme-item .btn-confirm')
    };
    var init = function(){
        events();
    };


    var events = function() {
        options.setBtn.on('click', function(){
            var data = $(this).data();
            var $parent = $(this).parents('.module-list-item-box');
            $.ajax({
                url : data.url,
                data:{theme:data.id},
                dataType:'json',
                type:'post',
                success:function(res){
                    var result = res || {};
                    if (result.code == 200) {
                        layer.msg('设置成功', {icon : 1}, function(){
                            $parent.remove();
                        });
                    } else {
                        layer.msg('设置失败', {icon : 5})
                    }
                },
                error:function(){
                    layer.msg('网络连接失败', {icon : 5});
                }
            });
        });

    };

    return {
        init:init
    }
})