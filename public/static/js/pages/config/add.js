define(['jquery', 'fn', 'layer', 'utils'], function($, fn, layer){
    var index = 0;
    var options = {
        dictSelect:$('#dictionary'),
        elementSelect:$('#element'),
        optionsBody:$('#options-body'),
        optionsWrapper:$('#options-wrapper'),
        addRowBtn:$('#add-row-btn'),
        getDictionaryUrl:$('#dictionary').data('url'),
        configValueBox:$('#config-value-box'),
        configOptionRow:$('#config-option-row'),
        hiddenOptions:$('#hidden-options')
    };
    var init = function(){
        events();
    };

    var getRowTpl = function(multiple, value, text, checked){
        var multiple = multiple || false;
        var element = multiple ? 'checkbox' : 'radio';
        var checked = multiple && checked ? 'checked="checked"' : '';
        var value = value || '';
        var text = text || '';
        var tpl = '<dd class="form-inline">'+
                      '<input type="text" name="optionText" class="form-control" size="40" value="{{text}}">     &nbsp;'+
                      '<input type="text" name="optionValue" class="form-control"  size="20" value="{{value}}">'+
                      '<input type="'+element+'" name="optionSelected" value="1" '+checked+'>'+
                      '<span class="btn btn-xs btn-danger btn-remove"><i class="iconfont icon-close"></i></span>    &nbsp;'+
                      '<span class="btn btn-xs btn-primary btn-dragsort" style="cursor: pointer;"><i class="iconfont icon-drag"></i></span>'+
                   '</dd>';
        tpl = tpl.replace('{{value}}', value).replace('{{text}}', text);
        return tpl;
    };

    var getObjectRowTpl = function(name, value) {
        var name = name || '';
        var value = value || '';
        var selectHtml = '<select name="paramName" class="form-control">';
        for (var field in fieldsMap) {
            var selected = name == field ? 'selected = "selected"' : '';
            selectHtml += '<option value="'+field+'" '+selected+'>'+fieldsMap[field]+'</option>';
        }
        value = name != '' && fieldsMap[name] ? value : '';
        selectHtml += '</select>      &nbsp;';
        var tpl = '<dd class="form-inline">'+
                      selectHtml+
                      '<input type="text" name="paramValue" class="form-control"  size="20" value="'+value+'">'+
                      '<input type="checkbox" name="optionSelected" value="1">'+
                      '<span class="btn btn-xs btn-danger btn-remove"><i class="iconfont icon-close"></i></span>    &nbsp;'+
                      '<span class="btn btn-xs btn-primary btn-dragsort" style="cursor: pointer;"><i class="iconfont icon-drag"></i></span>'+
                   '</dd>';
        return tpl;
    };

    var getItemTpl = function(value, text) {
        return '<label class="input-item" data-text="'+text+'" data-value="'+value+'">\
                       <input type="hidden" name="value" value="'+value+'">\
                       <span class="input-item-text">\
                           <i class="iconfont icon-tag"></i> '+text+'\
                       </span>\
                       <div class="remove">\
                           <span class="remove-item-btn">\
                               <i class="iconfont icon-close-circle"></i>\
                           </span>\
                       </div>\
                   </label>';
    };

    var getImgItemTpl = function(url, title){
        var title = title || '暂无说明';
        return '<dd>'+
                   '<a href="javascript:;" class="remove-btn file-img-delete"><i class="iconfont icon-close-circle"></i></a>'+
                   '<img src="'+url+'" class="file-img-thumb"><input type="hidden" name="value" value="'+url+'">'+
                   '<p class="file-img-title">'+title+'</p>'+
               '</dd>';
    };

    var getSingleBoxTpl = function(){
        return '<div class="single-upload-box">'+
                   '<a href="javascript:;" class="remove-btn file-img-delete"><i class="iconfont icon-close-circle"></i></a>'+
                   '<div id="single-upload-preview"></div>'+
                   '<input type="hidden" name="value" value="" id="single-upload-value">'+
                   '<a href="javascript:;" class="add-single-btn single-upload-btn" title="添加附件" data-width=\"800\" data-height=\"600\" data-url=\"/attach/single\">'+
                       '<i class="iconfont icon-image" style="font-size:80px;"></i>'+
                   '</a>'+
               '</div>';
    };

    var getMultiBoxTpl = function(url, className){
        return '<div class="file-img-list" id="upload-file-list">'+
                   '<ul>'+
                       '<li class="file-list"><dl id="uploaded-file-list" class="uploaded-file-list"> </dl></li>'+
                       '<li> <a href="javascript:;" title="添加图片" class=\"'+className+'\" data-width=\"1000\" data-height=\"800\" data-url=\"'+url+'\"> <i class="iconfont icon-addpic" style="font-size:80px;"></i> </a> </li>'+
                   '</ul>'+
                '</div>';
    };




    var setValue = function(){
        var optionsObj;
        var elementType = options.elementSelect.val();
        var html = '';
        if (inArray(elementType, ['text'])) {
            html = '<input type="text" name="value" class="form-control">';
            options.configOptionRow.hide();
        } else if (elementType == 'textarea') {
            html = '<textarea name="value" class="form-control" rows="5"></textarea>';
            options.configOptionRow.hide();
        } else if(elementType == 'object') {
            var optionsHtml = '';
            optionsObj = {};
            options.optionsBody.children('dd').each(function(){
                var name = $(this).find(':input[name=paramName]').val();
                var value = $(this).find(':input[name=paramValue]').val();
                var checked = $(this).find(':input:last').prop('checked');
                if (checked) {
                    optionsHtml += getItemTpl(name, name+":"+value);
                }
                optionsObj[name] = value;
            });
            html = '<div class="select-input-wrapper">\
                         <div class="select-input-items">\
                         '+optionsHtml+
                '</div>\
           </div>';
            options.hiddenOptions.val(JSON.stringify(optionsObj));
            options.configOptionRow.show();

        }else if (inArray(elementType, ['select', 'multipleSelect', 'transfer', 'checkbox', 'radio'])) {
            var optionsHtml = '';
            optionsObj = [];
            options.optionsBody.children('dd').each(function(){
                var text = $(this).find(':input[name=optionText]').val();
                var value = $(this).find(':input[name=optionValue]').val();
                var checked = $(this).find(':input:last').prop('checked');
                if (checked) {
                    optionsHtml += getItemTpl(value, text);
                }
                optionsObj.push({text : text, value : value, selected: checked});
            });
            html = '<div class="select-input-wrapper">\
                         <div class="select-input-items">\
                         '+optionsHtml+
                         '</div>\
                    </div>';
            options.hiddenOptions.val(JSON.stringify(optionsObj));
            options.configOptionRow.show();
        } else if(elementType == 'image') {
            html = getSingleBoxTpl();
            options.configOptionRow.hide();
        } else if(elementType == 'multipleImage') {
            html = getMultiBoxTpl("/attach/multi", 'add-multiple-btn');
            options.configOptionRow.hide();
        } else if(elementType == 'imageSelect') {
            html = getMultiBoxTpl("/attach/imagelist?multi=1", 'add-image-select-btn');
            options.configOptionRow.hide();
        }
        options.configValueBox.html(html);
    };

    var events = function() {
        if (pageData.options) {
            options.hiddenOptions.val(pageData.options);
        }
        options.dictSelect.on('change', function(){
            var value = $(this).val();
            var elementType = options.elementSelect.val();
            var multiple = elementType == 'radio' ? false : true;
            if (value == "") {
                options.optionsBody.find("dd").remove();
            } else {
                methods('request', [options.getDictionaryUrl, {parent: value}, function(res){
                    var result = res || {};
                    if (result.code == 6000) {
                        var html = "";
                        for (var i=0; i< result.data.length; i++) {
                            if (elementType == 'object') {
                                html += getObjectRowTpl(result.data[i].item, result.data[i].value);
                            } else {
                                html += getRowTpl(multiple, result.data[i].value, result.data[i].title, true);
                            }

                        }
                        options.optionsBody.html(html);
                        setValue();
                    } else {
                        var message = result.message || "请求失败";
                        layer.msg(message, {icon : 2});
                    }
                }])
            }
        });
        options.addRowBtn.on('click', function(){
            var elementType = options.elementSelect.val();
            var multiple = elementType == 'radio' ? false : true;
            var html = '';
            if (elementType == 'object') {
                html = getObjectRowTpl();
            } else {
                html = getRowTpl(multiple);
            }
            options.optionsBody.append(html);
        });
        options.optionsBody.on('click', '.btn-remove', function(){
            var $parent = $(this).parents('dd');
            $parent.remove();
            setValue();
        });
        options.elementSelect.on('change', function(){
            setValue();
        });
        options.optionsBody.on('click', ':checkbox', function(){
            setValue();
        });
        options.optionsBody.on('click', ':radio', function(){
            setValue();
        });
        options.configValueBox.on('click', 'span.remove-item-btn', function(){
            $(this).parents('label').remove();
        });
        options.configValueBox.on('click', 'a.add-single-btn', function(){
            var settings = $(this).data() || {};
            var $box = $('#single-upload-preview');
            var $uploadBox = $('.single-upload-box');
            var $hiddenValue = $('#single-upload-value');
            require(['jquery.form'], function(){
                methods('open', {
                    url:settings.url,
                    width:settings.width || '800',
                    height:settings.height || '600',
                    title:'添加图片',
                    callback:function(wrapper, body){

                        console.log($box);
                        var form = $(body).find('form:first');
                        var url = $(body).find('input[name=url]').val();
                        form.ajaxSubmit({
                            dataType:'json',
                            success:function(res){
                                res = res || {};
                                if (res.code == 6000) {
                                    $box.html('<img src="'+url+'" class="file-img-thumb">');
                                    $hiddenValue.val(url);
                                    $uploadBox.addClass('active');
                                } else {
                                    layer.msg("上传失败", {icon : 5});
                                }
                            },
                            error:function(){
                                layer.msg("网络不稳定，请稍候重试", {icon : 5});
                            }
                        });
                    }
                });
            });

        });
        options.configValueBox.on('click', 'a.add-multiple-btn', function(){
            var settings = $(this).data() || {};
            var $box = options.configValueBox.find('.uploaded-file-list')
            var urlList = new Array();
            $box.find('dd').each(function(){
                urlList.push($(this).find('input[name=url]').val());
            });
            methods('open', {
                url:settings.url,
                width:settings.width || '800',
                height:settings.height || '600',
                title:'添加图片',
                callback:function(wrapper, body){
                    var form = $(body).find('form:first');
                    var url = $(body).find('input[name=url]').val();

                    form.ajaxSubmit({
                        dataType:'json',
                        success:function(res){
                            res = res || {};
                            if (res.code == 6000) {
                                var html = '';
                                var items = $(body).find('.uploaded-file-list dd');
                                items.each(function(){
                                    var url = $(this).find('input[name=url]').val();
                                    if ($.inArray(url, urlList) < 0) {
                                        html += getImgItemTpl(url, $(this).find('input[name=text]').val());
                                    }

                                });
                                $box.html(html);
                            } else {
                                layer.msg("上传失败", {icon : 5});
                            }
                        },
                        error:function(){
                            layer.msg("网络不稳定，请稍候重试", {icon : 5});
                        }
                    });
                }
            });
        });
        options.configValueBox.on('click', 'a.add-image-select-btn', function(){
            var settings = $(this).data() || {};
            var $box = options.configValueBox.find('.uploaded-file-list');
            var urlList = new Array();
            $box.find('dd').each(function(){
                urlList.push($(this).find('input[name=url]').val());
            });
            methods('open', {
                url:settings.url,
                width:'800',
                height:'600',
                title:'选择图片',
                callback:function(wrapper, body){
                    var items = $(body).find('.uploaded-file-list dd.active');
                    var html = '';
                    items.each(function(){
                        var url = $(this).find('input[name=url]').val();
                        if ($.inArray(url, urlList) < 0) {
                            html += getImgItemTpl(url, $(this).find('input[name=text]').val());
                        }

                    });
                    $box.html(html);
                }
            });
        });
        options.configValueBox.on('click', 'a.file-img-delete', function(){
            var parent = $(this).parent();
            if (parent.hasClass('single-upload-box')) {
                parent.find('img').remove();
                parent.removeClass('active');
            } else {
                parent.remove();
            }

        });
        fn.dragsort('#options-body', {dragSelector : 'dd'});
    };

    var methods = function(method, args){
        var _class = {
            request : function(args){
                $.ajax({
                    url : args[0],
                    type : 'get',
                    data:args[1],
                    dataType:'json',
                    success:args[2],
                    error:function(){
                        layer.msg("网络错误", {icon : 2});
                    }
                });
            },
            open:function(args){
                index = layer.open({
                    type:2,
                    content:args.url,
                    title:args.title,
                    btn:['确定'],
                    area:[args.width+"px", args.height+"px"],
                    yes:function(index, wrapper){
                        var body = layer.getChildFrame('body', index);
                        if (args.callback) {
                            args.callback(wrapper, body);
                        }
                        layer.close(index);
                    }
                });
            }
        };
        return _class[method](args);
    };

    return {
        init:init
    }
})