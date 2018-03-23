define(['jquery', 'bootstrap', 'layer', 'sortable'], function($, b, layer, Sortable){
    var options = {
        tableBoxSelector:'#rule-table',
        tableBox:$('#rule-table'),
        tableBody:$('#rule-table tbody'),
        tableTrItem:$('#rule-table tbody tr[data-tt-parent-id=0]')
    };
    var init = function(){
        events();
    };

    var events = function() {
        resort();
    };

    var resort = function(){
        var el = document.getElementById('rule-table').getElementsByTagName('tbody')[0];
        var sortable = new Sortable(el, {
            group:null,
            //sort: true,
            draggable:'tr',
            handle:'a.btn-dragsort',
            onMove: function (evt,originalEvent) {
                var data = {};
                var srcElement = evt.dragged;
                var targetElement = evt.related;
                var srcRow = $(srcElement);
                var targetRow = $(targetElement);
                var level = srcRow.data('level');
                var targetLevel = targetRow.data('level');
                if (level != targetLevel) {
                    layer.msg('非同一层级不能排序', {icon : 2});
                    return false;
                }
                data.id = srcRow.data('tt-id');
                data.sort = srcRow.data('sort');
                data.relatedId = srcRow.data('tt-id');
                data.relatedSort = targetRow.data('sort');
                var isPost = true;
                if (!isPost) {
                    return false;
                }
                $.ajax({
                    url:'',
                    data:data,
                    dataType:'json',
                    type:'post',
                    success:function(res){
                        isPost = false;
                        var result = res || {};
                        if (result.code == 200) {
                            window.location.reload();
                        } else {
                            layer.msg(result.message || '排序失败', {icon : 2});
                            return false;
                        }
                    }
                });
            },
        });
    };

    return {
        init:init
    }
})