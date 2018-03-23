define(['jquery', 'bootstrap', 'layer'], function($, b, layer){
    var options = {
        selectIconBtn:$('.btn-search-icon'),
        previewIcon:$('.icon-preview-box i'),
        inputIcon:$('.icon-input-value'),
        iconListInlineBox:$('#icon-list-inline'),
        iconListTpl : $('#icon-list-tpl'),
        cached : false,
        defaultIcon:$('.icon-input-value').val()
    };
    var init = function(){
        events();
    };

    var events = function() {
        options.selectIconBtn.on('click', function(){
            if (!options.cached) {
                methods('getIcons', [iconUrl, function(icons){
                    var html = '';
                    for (var i =0; i< icons.length; i++) {
                        var attrs = '';
                        if (options.defaultIcon == icons[i].icon) {
                            attrs = 'class="active"';
                        }
                        html += '<li data-font="'+icons[i].icon+'" title="'+icons[i].title+'" '+attrs+'> <i class="iconfont '+icons[i].icon+' icon-font-preview"></i> <i class="iconfont icon-selected icon-tool-selected"></i></li>';
                    }
                    options.iconListInlineBox.html(html);
                    layer.open({
                        title : '选择图标',
                        content : options.iconListTpl.html(),
                        width:'450px',
                        yes:function(index, wrapper){
                            methods('setSelectedIcon', [wrapper]);
                            layer.close(index);
                        }
                    });
                }])
                options.cached = true;
            } else {
                options.iconListTpl.find('li').show();
                layer.open({
                    title : '选择图标',
                    content : options.iconListTpl.html(),
                    width:'450px',
                    yes:function(index, wrapper){
                        methods('setSelectedIcon', [wrapper]);
                        layer.close(index);
                    }
                });
            }

        });
        $(document).on('click', '#choose-icon ul li', function () {
            $(this).addClass('active').siblings().removeClass('active');
        });
        $(document).on('keyup', 'input.input-icon-search', function () {
            $("#choose-icon ul li").show();
            var keywords = $(this).val();
            if ($(this).val() != '') {
                var pattern = /^[a-zA-Z0-9_-]+$/;
                if (pattern.test(keywords)) {
                    $("#choose-icon ul li:not([data-font*='" + keywords + "'])").hide();
                } else {
                    $("#choose-icon ul li[title*='" +keywords + "']").show().siblings().hide();
                }
            } else {
                $("#choose-icon ul>li").show();
            }
        });
    };

    var methods = function(method, args){
        var _class = {
            getIcons : function(arg){
                if (window.localStorage) {
                    var icons = window.localStorage.getItem('icon_list');
                    if (icons) {
                        arg[1](JSON.parse(icons));
                        return true;
                    }
                }
                $.ajax({
                    url : arg[0],
                    type : 'get',
                    success:function(content){
                        var $iconItem = $(content).find('.icon_lists:first li');
                        var iconList = new Array();
                        $iconItem.each(function(){
                            var $current = $(this);
                            var obj = {};
                            var className = $current.find('div[class=fontclass]').text().substring(1);
                            if (className != 'icon-meizu-logo') {
                                obj.title = $current.find('div[class=name]').text();
                                obj.icon = className;
                                iconList.push(obj);
                            }
                        });
                        if (window.localStorage) {
                            window.localStorage.setItem('icon_list', JSON.stringify(iconList));
                        }
                        arg[1](iconList);
                    }
                });

            },
            setSelectedIcon:function(arg){
                var selectedIcon = arg[0].find('#icon-list-inline li.active:first');
                if (selectedIcon.length > 0) {
                    var className = selectedIcon.data('font');
                    options.previewIcon.removeClass().addClass('iconfont '+className).prop('title', selectedIcon.attr('title'));
                    options.inputIcon.val(className);
                    options.iconListTpl.find('li[data-font='+className+']').addClass('active').siblings().removeClass('active');
                }
            },
        };
        return _class[method](args);
    };

    return {
        init:init
    }
});