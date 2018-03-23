define(['jquery', 'bootstrap', 'layer'], function($, b, layer){
    var options = {
        addPostsBtn:$('#add-posts-btn'),
        topicId:$('#topicId').val()
    };
    var index;
    var init = function(){
        events();
    };

    var events = function() {
        options.addPostsBtn.on('click', function(){
            var data = $(this).data();
            index = layer.open({
                type:2,
                content:data.url,
                title:$(this).text(),
                btn:['确定'],
                area:[data.width+"px", data.height+"px"],
                yes:function(index, wrapper){
                    var body = layer.getChildFrame('body', index);
                    var arr = new Array();
                    var $checkedItems= body.find('tbody :checkbox:checked');

                    $checkedItems.each(function(){
                        arr.push($(this).val());
                    });
                    $.ajax({
                        url:'/admin/topicrelation/add',
                        type:'post',
                        data:{topicId:options.topicId, postsId:JSON.stringify(arr)},
                        dataType:'json',
                        success:function(res){
                            var result = res || {};
                            if (result.code == 200) {
                                layer.msg('添加成功', {icon : 1}, function(){
                                    window.location.reload();
                                });

                            } else {
                                layer.msg('添加失败', {icon : 5})
                            }
                        },
                        error:function(){
                            layer.msg('网络连接出错', {icon : 5})
                        }
                    });
                    layer.close(index);
                }
            });

        });

    };





    return {
        init:init
    }
});