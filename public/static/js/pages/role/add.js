define(['jquery', 'bootstrap', 'layer', 'jquery.jstree'], function($, b, layer){
    var options = {
        treeviewBox:$('#rule-tree'),
        hiddenValue:$('#hidden-value'),
        refreshCacheBtn:$('#refresh-cache')
    };
    var init = function(){
        events();
    };

    var events = function() {
        var data = options.treeviewBox.data();
        methods('getRules', [data.url, function(rules){
            options.treeviewBox.jstree({ 'core' : {
                'data' : rules
            } ,"plugins" : ["checkbox"]});
        }]);
        options.treeviewBox.on('changed.jstree',function(e,data){
            methods('setValue', data.selected);
        });
        $(document).on("click", "#check-all", function () {
            options.treeviewBox.jstree($(this).prop("checked") ? "check_all" : "uncheck_all");
        });
        $(document).on("click", "#expand-all", function () {
            options.treeviewBox.jstree($(this).prop("checked") ? "open_all" : "close_all");
        });
        options.refreshCacheBtn.on('click', function(){
            if(window.localStorage) {
                window.localStorage.removeItem("rule_list");
            }
            window.location.reload();
        });
    };

    var methods = function(method, args){
        var _class = {
            getRules : function(args){
                if (window.localStorage) {
                    var ruleList = window.localStorage.getItem('rule_list');
                    if (ruleList) {
                        var data = JSON.parse(ruleList);
                        data = methods("parseRules", [data, methods("getValues")]);
                        args[1](data);
                        return true;
                    }
                }
                $.ajax({
                    url : args[0],
                    type : 'get',
                    dataType:'json',
                    success:function(res){
                        res = res || {};
                        if (res.code == 200) {
                            var data = [];
                            for(var i=0; i< res.data.length; i++) {
                                var tmp = {id :0, text:"", parent:0, icon:"iconfont "};
                                tmp.id = res.data[i].id;
                                tmp.text = res.data[i].title;
                                tmp.parent = res.data[i].parentId;
                                if (res.data[i].icon) {
                                    tmp.icon = tmp.icon + res.data[i].icon;
                                }
                                data.push(tmp);
                            }
                            if (window.localStorage) {
                                window.localStorage.setItem('rule_list', JSON.stringify(data));
                            }
                            data = methods("parseRules", [data, methods("getValues")]);
                            args[1](data);
                        } else {
                            layer.msg("获取数据失败", {icon : 5})
                        }
                    },
                    error:function(){
                        layer.msg("网络不稳定，请稍侯重试", {icon : 5})
                    }
                });

            },
            parseRules:function(args){
                for (var i=0; i< args[0].length; i++) {
                    args[0][i].state =  {opened : false, selected : false };
                    args[0][i].parent = args[0][i].parent != 0 ? args[0][i].parent : '#';
                    if ($.inArray(args[0][i].id.toString(), args[1]) >= 0) {
                        args[0][i].state =  {opened : true, selected : true };
                    }
                }
                return args[0];
            },
            getValues:function(){
                var value = options.hiddenValue.val();
                if (value && value != "") {
                    var values = value.split(',');
                    return values;
                }

                return [];
            },
            setValue:function(val){
                options.hiddenValue.val(val.join(','));
            }
        };
        return _class[method](args);
    };

    return {
        init:init
    }
})