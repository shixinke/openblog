define(['jquery', 'bootstrap', 'layer', 'sortable'], function($, b, layer, Sortable){
    var options = {
        tableBoxSelector:'table.bootstrap-table',
        inputSelectWrapper:$('.input-select-wrapper'),
        inputSelectText:$('.input-select-wrapper :input:last'),
        inputSelectHidden:$('.input-select-wrapper :hidden'),
        clearBtn:$('.input-select-wrapper .single-close-btn')
    };
    var index = 0;
    var init = function(){
        events();
    };

    var events = function() {
        options.inputSelectText.on('focus', function(){
            var parent = $(this).parent();
            var hidden = parent.find(':hidden');
            var setting = {
                width:900,
                height:600,
                title:'选择话题',
                url : '/topic/list?multi=0'
            };
            var data = parent.data();
            data = $.extend(setting, data);
            index = layer.open({
                type:2,
                content:data.url,
                title:data.title,
                btn:['确定'],
                area:[data.width+"px", data.height+"px"],
                yes:function(index, wrapper){
                    var body = layer.getChildFrame('body', index);
                    var selectedTr = $(body).find('table.bootstrap-table:first tr.selected');
                    var selections = [];
                    selectedTr.each(function(){
                        var obj = {text : '', value : 0};
                        obj.text = $(this).find('td:eq(1)').text();
                        obj.value = $(this).find(':radio').val();
                        selections.push(obj);
                    });
                    if (selections.length > 0) {
                        var obj = selections[0];
                        options.inputSelectText.val(obj.text);
                        options.inputSelectHidden.val(obj.value);
                        options.inputSelectWrapper.addClass('active');
                    }
                    layer.close(index);
                }
            });
        });
        options.clearBtn.on('click', function(){
            options.inputSelectHidden.val("");
            options.inputSelectText.val("");
            options.inputSelectWrapper.removeClass('active');
        });
    };


    return {
        init:init
    }
})