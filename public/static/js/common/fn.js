define(['jquery', 'layer'], function($, layer){
    var validateForm = function(formId, options){
        var selector = '';
        if (formId instanceof jQuery) {
            selector = formId;
        } else if(formId.substr(0, 1) == '#' || formId.substr(0, 1) == '.') {
            selector = $(formId)
        } else {
            selector = $('#'+formId);
        }
        var options = options || {};
        var defaultCallback = function(res){
            var res = res || {}
            var iframe = selector.data('iframe');
            if (res.code == 200) {
                res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作成功';
                layer.alert(res.message, {shade:[0, 'transparent'], icon:1}, function(){
                    if (!res.data) {
                        iframe == 1 ? window.parent.location.reload() : window.location.reload();
                    } else {
                        iframe == 1 ? window.parent.location.href = res.data.url : window.location.href = res.data.url;
                    }

                });
            } else {
                res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作失败';
                res.data = res.data || {};
                layer.alert(res.message, {shade:[0, 'transparent'], icon:5}, function(index){
                    if (typeof res.data.url != 'undefined' && res.data.url != '') {
                        iframe == 1 ? window.parent.location.href = res.data.url : window.location.href = res.data.url;
                    }
                    else {
                        layer.close(index);
                    }
                });
            }
        };
        options.success = options.success || defaultCallback;
        require(['jquery.validate', 'jquery.form', 'layer', 'jquery.md5'], function(validate, jqueryForm, layer){
            selector.validate({
                errorPlacement: function(error, element) {
                    var $label = $( element ).closest( "form" ).find( "div[for='" + element.attr( "id" ) + "']" );
                    $label.append(error).show();
                },
                submitHandler: function(form){
                    var iframe = $(form).attr('data-iframe');
                    $('input[type=password]').each(function(){
                        var encrypt = $(this).attr('data-encrypt') || '1';
                        if(encrypt != '0') {
                            $(this).val($.md5($(this).val()));
                        }
                    });
                    if (options.before) {
                        options.before();
                    }
                    $(form).ajaxSubmit({
                        dataType:'json',
                        success:options.success,
                        error:function(){
                            layer.msg("网络不稳定，请稍候重试", {icon : 5});
                        }
                    });
                }
            });
        })
    };

    var loadPage = function(selector){
        var selector = selector || '.loadpage';
        var style = {};
        $("body").on('click', selector, function(){
            style.width = $(this).attr('data-width') || $(window).width() - 50;
            style.height = $(this).attr('data-height') || $(window).height() - 50;
            var title = $(this).attr('title') || $(this).text();
            layer.open({
                type: 2,
                title:title,
                scrollbar:true,
                area: [style.width +'px', style.height +'px'],
                content: $(this).attr('data-url')
            });
        });
    };

    var toCamelCase = function (str){
        var strArr=str.split('-');
        for(var i=1;i<strArr.length;i++){
            strArr[i]=strArr[i].charAt(0).toUpperCase()+strArr[i].substring(1);
        }
        return strArr.join('');
    };

    var dataToCamelCase = function(selector){
        var $selector;
        if (selector instanceof jQuery) {
            $selector = selector;
        } else {
            $selector = $(selector);
        }
        var data = $selector.data();
        var params = {};
        if (data) {
            for (var param in data) {
                var name = toCamelCase(param);
                params[name] = data[param];
            }
        }
        return params;
    };

    var addIframeTab = function(iframeWrapper, selector, options){
        var iframeWrapper = iframeWrapper || '#content-wrapper';
        if (!selector) {
            console.log("请选择元素");
            return false;
        }
        console.log(options);
        console.log($(selector).data());
        var config = $.extend({}, options, $(selector).data());
        if (!config.id || !config.label || !config.url) {
            console.log("配置不正确");
            return false;
        }
        require(['jquery.iframetabs'], function(){
            console.log("tab config:");
            console.log(config.url);
            console.log(config.label);
            console.log(config.id);
            var obj = $(iframeWrapper);
            if (obj.length < 1) {
                obj = $(iframeWrapper,parent.document)
            }
            if (obj.length < 1) {
                console.log("未获取到元素");
                return;
            }
            var tabObj =  obj.iframeTabs(config);
            tabObj.add(config);
        });
    };

    var checkUrlTab = function(){
        $("body").on("click", "a.tab-link", function(e){
            e.preventDefault();
            var options = {};
            options.url = $(this).attr('href');
            options.label = $(this).text() || $(this).attr('title');
            addIframeTab(null, this, options);
        });
    };

    var loadLayer = function(selector, options){
        var ch = selector.substr(0, 1);
        var options = options || {};
        options.type = 1;
        if (ch == '.' || ch == '#') {
            options.content = $(selector);
        } else {
            options.content = selector;
        }
        layer.open(options);
    };

    var hoverTip = function(selector){
        var $selector = selector ? $(selector) : $('.tip-hover');
        var index = null;
        $selector.on('mouseover', function(){
            var that = this;
            var time = $(this).attr('data-time');
            var type = $(this).attr('data-type') || 2;
            var color = $(this).attr('data-time') || '3595CC';
            index = layer.tips($(this).attr('data-tip'), that, {tips:[type, '#'+color], time:time || 0}); //在元素的事件回调体中，follow直接赋予this即可;
        });
        $selector.on('mouseout', function(){
            layer.close(index);
        });
    };

    var clickTip = function(selector){
        var $selector = selector ? $(selector) : $('.tip-hover');
        var index = null;
        $selector.on('click', function(){
            var that = this;
            var time = $(this).attr('data-time');
            var type = $(this).attr('data-type') || 2;
            var color = $(this).attr('data-time') || '3595CC';
            index = layer.tips($(this).attr('data-tip'), that, {tips:[type, '#'+color], time:time || 0}); //在元素的事件回调体中，follow直接赋予this即可;
        });
    };

    var transfer = function(selector, options){
        var selector = selector || '.transfer-select';
        var options = options || {};
        require(['jquery.transfer'], function(){
            $(selector).transfer(options);
        });
    };

    var ajaxDelSubmit = function(url, data, info, okFn){
        var info = info || {};
        if (!okFn) {
            var okFn = function(res){
                if (res.code == 200) {
                    res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作成功';
                    layer.alert(res.message, {shade:[0, 'transparent'], icon:1}, function(){
                        window.location.href = res.data.url;
                    });
                } else {
                    res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作失败';
                    layer.alert(res.message, {shade:[0, 'transparent'], icon:5}, function(index){
                        if (typeof res.data.url != 'undefined' && res.data.url != '') {
                            window.location.href = res.data.url;
                        }
                        else {
                            layer.close(index);
                        }
                    });
                }
            };
        };
        info.msg = info.msg ? info.msg : '您确定要删除该项吗？删除后将无法恢复';
        info.title = info.title ? info.title : '删除提醒';
        layer.confirm(info.msg, {icon:3, title:info.title}, function(index){
            layer.close(index);
            $.ajax({
                url : url,
                type:'post',
                data : data,
                dataType:'json',
                success:okFn
            });
        }, function(index){
            layer.close(index);
        });
    };

    var ajaxDel = function(selector, okFn){
        var selector = selector || '.btn-del-row';
        $('table.action-table').on('click', selector, function(){
            var $parent = $(this).parents("tr");
            var msg = $(this).attr('data-msg') ? $(this).attr('data-msg') : '您确定要删除该项吗？删除后将无法恢复';
            var title = $(this).attr('data-title') ? $(this).attr('data-title') : '删除提醒';
            var options = {};
            if ($(this).attr('data-id')) {
                options.id = $(this).attr('data-id');
            } else {
                var fields = $(this).attr('data-fields');
                if (fields) {
                    var arr = fields.split(',');
                    for (var val in arr) {
                        if (val) {
                            options[val] = $(this).attr('data-'+val);
                        }
                    }
                }
            }

            var removeFn = function(res){
                var res = res || {};
                if (res.code == 200) {
                    //$parent.remove();
                    layer.msg(res.message, {icon: 1}, function(){
                        $parent.remove();
                    });

                } else {
                    res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作失败';
                    layer.msg(res.message, {icon:5}, function(){
                        if (res.data && typeof res.data.url != 'undefined' && res.data.url != '') {
                            window.location.href = res.data.url;
                        }
                    });

                }
            };
            if (!okFn) {
                okFn = removeFn;
            }
            ajaxDelSubmit($(this).attr('data-action'), options, {title:title, msg:msg}, okFn);
        });

    };

    var selectPage = function(selector, options, callback){
        var selector = selector || '.select-page';
        var options = options || {};
        var $selector = $(selector);
        options = $.extend(dataToCamelCase($selector), options);
        options.data = options.url;
        if (callback) {
            options.eAjaxSuccess = function(res){
                res = res || {};
                if (res.code == 200) {
                    return callback(res.data);
                } else {
                    layer.msg("数据加载失败", {icon : 5});
                }
            };
        }
        require(['selectpage'], function(){
            $(selector).selectPage(options);
        })
    };

    var trim = function(str){
        if (!str) {
            return str;
        }
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }
    var ltrim= function(str, delimiter){
        if (!str) {
            return str;
        }
        return str.replace(/(^\s*)/g,"");
    }
    var rtrim = function(str){
        if (!str) {
            return str;
        }
        return str.replace(/(\s*$)/g,"");
    }

    var ajaxDelBatch = function(selector, checkSelector){
        var $selector = selector ? $(selector) : $('#ajax-batch-del-btn');
        var checkSelector = checkSelector ? checkSelector : '.check-item';
        $selector.on('click', function(){
            var $checkedSelector = $(checkSelector+":checked");
            var length = $checkedSelector.length;
            if (length < 1) {
                layer.alert('请选择要删除的选项', {shade:[0, 'transparent']});
                return false;
            }
            var ids = '';
            $checkedSelector.each(function(){
                ids += $(this).val()+',';
            });
            var msg = $(this).attr('data-msg') || '您确定要删除这些选定的选项吗？';
            ajaxDelSubmit($(this).attr('data-action'), {ids:ids}, {msg:msg});
        });
    };

    var getUrlVars = function(){
        var vars = [], hash;
        var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for(var i = 0; i < hashes.length; i++){
            hash = hashes[i].split('=');
            if (hash[1] != "") {
                vars[hash[0]] = hash[1];
            }
        }
        return vars;
    };

    var getUrlVar = function(name){
        return getUrlVars()[name];
    };

    var getBaseUrl = function(url){
        var url = url ? url : window.location.href;
        return url.substr(0, url.indexOf('?'))
    };

    //封装浏览器参数
    var composeUrlParams=function(){
        var param='';
        var vars = getUrlVars();
        var index = 0;
        for(var k in vars) {
            if (k != 'page' && vars[k]) {
                var tmp = index == 0 ? "" : "&";
                param += tmp + k+"="+vars[k];
                index ++;
            }
        };
        return param;
    }

    var pager = function(selector) {
        require(['pager'], function(pager){
            var $selector = selector ? $(selector) : $('#pager');
            var options = {
                currentPage:$selector.attr('pageNum') || 1,
                totalPages:$selector.attr('pageCount') || 1,
                numberOfPages:$selector.attr('numberOfPages') || 5,
                bootstrapMajorVersion:3,
                pageUrl: function(type, page, current){
                    return getBaseUrl($selector.attr('baseUrl'))+'?'+composeUrlParams()+"&page="+page;
                }
            };
            $selector.bootstrapPaginator(options);
            var $pageSearchBtn = $('.page-search');
            var $pageInput = $('.page-input');
            $pageInput.change(function(){
                if ($(this).val().length > 0) {
                    var pageNum = parseInt($(this).val());
                    if (pageNum > 0) {
                        $pageSearchBtn.attr('disabled', false);
                    }
                } else {
                    $pageSearchBtn.attr('disabled', true);
                }
            });
            $('.page-search').on('click', function(){
                var pageNum = parseInt($pageInput.val());
                if (pageNum < 1) {
                    layer.msg("请输入合法的页码", {icon: 6}, function(){
                        $pageSearchBtn.attr('disabled', true);
                    });

                } else {
                    url = getBaseUrl()+'?'+composeUrlParams()+"&page="+pageNum;
                    window.location.href = url;
                }
            });
        });
    };

    var changeBtn = function(selector, disabled){
            var selector = selector ? $(selector) : $('.form-btn-groups');
            if (disabled) {
                selector.find('.btn').attr('disabled', true);
            } else {
                selector.find('.btn').removeAttr('disabled');
            }
    };

    var checkAll = function(checkAll, checkItem, change){

            var checkAll = checkAll ? checkAll : '.check-all';
            var $checkItem = checkItem ? $(checkItem) : $('#form-table .check-item');
            var change = change ? change : false;
            $('#form-table').on('click', checkAll, function(){
                if (this.checked) {
                    $checkItem.prop('checked', true);
                    if (change) {
                        changeBtn(null, false);
                    }

                } else {
                    $checkItem.prop('checked', false);
                    if (change) {
                        changeBtn(null, true);
                    }
                }
            });

            if (change) {
                $checkItem.on('click', function(){
                    if (this.checked) {
                        changeBtn(null, false);
                    } else {
                        if ($('#form-table .check-item:checked').length == 0) {
                            changeBtn(null, true);
                        }
                    }
                });
            }

    };

    var refreshPage = function(selector, isParent){
            var $selector = selector ? $(selector) : $('.refresh-btn');
            $selector.on('click', function(){
                if (isParent) {
                    window.parent.location.reload();
                } else {
                    window.location.reload();
                }
            });
    };

    var datepicker = function(selector, options){
        var selector = selector || '.date-picker';
        var options = options || {};
        options.type = options.type || 'datetime';
        require(['laydate'], function(laydate){
            laydate.path = '/static/js/libs/laydate/5.0.7/';
            laydate.render({
                elem: selector,
                type:options.type
            });
        });

    };

    var bootstrapTable = function(selector, options){
        var selector = selector || 'table.bootstrap-table';
        var $selector = $(selector);
        var options = options || {};
        options = $.extend(options, $selector.data());
        require(['bootstrap.table', 'bootstrap.table.cn'], function(){
            options = $.extend(options, $.fn.bootstrapTable.locales['zh-CN']);
            options.queryParamsType = "";
            $selector.bootstrapTable(options);
            $('#table-search-btn').click(function(){
                $selector.bootstrapTable('refresh');
            });
            $('.btn-del-all').on('click', function(){
                var ids = $.map($selector.bootstrapTable('getSelections'), function (row) {
                    if (app.pk) {
                        return row[app.pk];
                    }
                    return row.id;
                });
                if (ids.length > 0) {
                    if (app.group != '') {
                        var url = '/'+app.group+'/'+app.module+'/'+app.del;
                    } else {
                        var url = '/'+app.module+'/'+app.del;
                    }

                    ajaxDelSubmit(url,{id : ids.join(',')}, {}, function(res){
                        var res = res || {};
                        if(res.code == 200) {
                            layer.msg("删除成功", {icon : 1});
                            $selector.bootstrapTable('remove', {
                                field: app.pk,
                                values: ids
                            });
                        } else {
                            var msg = res.message || '删除失败';
                            layer.msg(msg, {icon : 2});
                        }

                    });
                } else {
                    layer.msg('请选择要删除的数据', {icon : 2});
                }
            });
        });

    };

    var imgLoadError = function(selector, defaultImg){
        var selector = selector || 'img';
        var defaultImg = defaultImg || 'static/images/img_error.png';
        $(selector).error(function(){
            $(this).attr('src', defaultImg);
        });
    };

    var webuploader = function(opts){
        opts = opts || {};
        require(['webuploader'], function(WebUploader){
            var options = $.extend({
                swf:'/static/js/libs/webuploader/Uploader.swf',
                accept:{title: 'Images', extensions: 'gif,jpg,jpeg,bmp,png', mimeTypes: 'image/jpg,image/jpeg,image/png,image/gif,image/bmp'},
                resize: false
            }, opts);
            var uploader = WebUploader.create(options);
            uploader.on( 'uploadError', function( file ) {
                layer.msg('上传失败', {icon:5});
            });

            uploader.on('uploadSuccess', function(file, ret){
                ret = ret || {};
                if (ret && ret.code && ret.code == 200) {
                    if (options.success) {
                        options.success(file, ret, options);
                    }
                } else {
                    layer.msg(ret.message, {icon:5});
                }
            });
            uploader.on('uploadProgress', function(file, percentage){
                if (options.progress) {
                    options.progress(file, percentage);
                }
            });

            if (!options.auto && options.startUploadBtn) {
                options.startUploadBtn.on('click', function(){
                    if (options.uploadState == 'uploading') {
                        uploader.stop();
                    } else {
                        uploader.upload();
                    }
                });
            }

            uploader.on('all', function(type){
                if (options.all) {
                    options.all(type);
                }
            });
        });
    };

    var imgUpload = function(selector, options){
        var html = '';
        var defaults = {
            swf:'/static/js/libs/webuploader/0.1.5/Uploader.swf',
            server: '/upload',
            auto:true,
            pick: {
                id:'#single-upload-btn',
                multiple:false
            },
            thumb:{
                width:200,
                height:100,
                quality:80
            },
            uploadBox:$('.single-upload-box'),
            previewBox:$('#single-upload-preview'),
            uploadValue:$('#single-upload-value'),
            uploadInfo:$('#single-upload-info'),
            accept:{title: 'Images', extensions: 'gif,jpg,jpeg,bmp,png', mimeTypes: 'image/jpg,image/jpeg,image/png,image/gif,image/bmp'},
            resize: false,
            success:function(file, ret, options){
                ret.data = ret.data || {};
                ret.data.fileType = ret.data.fileType || 'image';
                if (ret.data.fileType == 'image') {
                    html = '<img src="'+ret.data.url+'" class="file-img-thumb">'
                } else if (ret.data.fileType == 'video') {
                    html = '<video src="'+ret.data.url+'"></video>';
                } else if(ret.data.fileType == 'audio') {
                    html = '<audio src="'+ret.data.url+'"></audio>';
                }
                options.uploadBox.addClass('active');
                options.previewBox.html(html);
                options.uploadInfo.val(JSON.stringify(ret.data));
                options.uploadValue.val(ret.data.url);
            }
        };

        webuploader(defaults);
    };

    var imgUploadRemove = function(options){
        options = options || {};
        var $selector = options.uploadBox || $('.upload-item-box');
        var removeBtn = options.removeBtn || 'a.remove-btn';
        $selector.on('click', removeBtn, function(){
            var $parent = $(this).parent('.upload-item-box');
            options.uploadBox = $parent;
            options.previewBox = options.previewBox || options.uploadBox.find('.upload-preview-box');
            options.hiddenBox = options.uploadValueBox || options.uploadBox.find('.upload-value');
            options.path = options.hiddenBox.val();
            ajaxRemoveFile(options);
        });
    };

    var ajaxRemoveFile = function(options){
        options = options || {};
        var defaults = {
            url : '/upload/delete',
            success:function(res){
                var res = res || {};
                var message = res.message || "删除失败";
                if (res.code == 200) {
                    if (options.uploadBox) {
                        options.uploadBox.removeClass('active');
                    }
                    if (options.previewBox) {
                        options.previewBox.html("");
                    }
                    if (options.hiddenBox) {
                        options.hiddenBox.val("");
                    }
                    layer.msg("删除成功", {icon:1});
                } else {
                    layer.msg(message, {icon:5});
                }
            }
        };
        var opts = $.extend(defaults, options);
        $.ajax({
            url:opts.url,
            type:'post',
            dataType:'json',
            data:{url : opts.path},
            success:opts.success
        });
    };

    var multipleImgUpload = function(selector, options){

    };



    var removeFile = function(options){
        $('.upload-box ul').on('click', 'a.upload-remove-btn', function(){
            var $parent = $(this).parents('li');
            var $uploadBox = $(this).parents('.upload-box');
            var type = $uploadBox.attr('data-type');
            var path = $parent.find('.upload-hidden-path').val();
            $.ajax({
                url:options.removeUrl || '/upload/remove',
                type:'post',
                data:{path:path},
                dataType:'json',
                success:function(ret){
                    var code = ret.code ? ret.code : null;
                    if (code == 200) {
                        $parent.remove();
                        var length = $uploadBox.find('ul li').length;
                        if ((type == 'image' || type == 'file') && length == 0) {
                            $uploadBox.find('.upload-btn-box').show();
                        }
                    } else {
                        var message = ret && ret.message && ret.message != '' ? ret.message : '删除失败';
                        layer.msg(message, {icon:5});
                    }
                }
            });
        });
    };

    var treetable = function(selector, options){
        require(['treetable'], function(){
            var $selector = selector ? $(selector) : $('.tree-table');
            $selector.treetable({expandable : true, indent : 24, indenterTemplate : '<span class="indenter"><i>&nbsp;</i></span>'});
        });
    };

    var dragsort = function(selector, options){
        var $selector = selector ? $(selector) : $('.drag-sort');
        var options = options || {};
        require(['jquery.dragsort'], function(){
            $selector.dragsort(options);
        });
    };


    var chosen = function(selector, options){
        var options = options || {};
        var selector = selector || '.chosen-select';

        require(['jquery.chosen'], function(){
            $(selector).chosen(options);
        })
    };

    var formatBytes = function(size, delimiter){
        var delimiter = delimiter ? delimiter : ' ';
        var units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
        var size = size;
        for (var i = 0; size >= 1024 && i< units.length; i++) {
            size = size / 1024;
        }
        return size.toFixed(2)+delimiter+units[i+1];
    };

    var strtotime = function(timestamp)
    {
        var date = new Date(timestamp);
        return date.getTime();
    };

    var timeFormat = function(time, format){
        var format = format ? format : '%Y-%m-%d %H:%i:%s';
        var date = new Date(time);
        var year = date.getFullYear();
        var month = date.getMonth()+1;
        month = month < 10 ? '0'+month.toString() : month;
        var day = date.getDate();
        day = day < 10 ? '0'+day.toString() : day;
        var hour = date.getHours();
        hour = hour < 10 ? '0'+hour.toString() : hour;
        var minute = date.getMinutes();
        minute = minute < 10 ? '0'+minute.toString() : minute;
        var second = date.getDate();
        second = second < 10 ? '0'+second.toString() : second;
        var str = format;
        str = str.replace('%Y', year);
        str = str.replace('%m', month);
        str = str.replace('%d', day);
        str = str.replace('%H', hour)
        str = str.replace('%i', minute)
        str = str.replace('%s', second)
        return str;
    };

    return {
        validateForm:validateForm,
        loadPage:loadPage,
        loadLayer:loadLayer,
        transfer:transfer,
        dragsort:dragsort,
        bootstrapTable:bootstrapTable,
        hoverTip:hoverTip,
        clickTip:clickTip,
        pager:pager,
        ajaxDel:ajaxDel,
        ajaxDelBatch:ajaxDelBatch,
        ajaxDelSubmit:ajaxDelSubmit,
        checkAll:checkAll,
        refreshPage:refreshPage,
        chosen:chosen,
        datepicker:datepicker,
        webuploader:webuploader,
        imgUpload:imgUpload,
        imgUploadRemove:imgUploadRemove,
        ajaxRemoveFile:ajaxRemoveFile,
        multipleImgUpload:multipleImgUpload,
        removeFile:removeFile,
        treetable:treetable,
        formatBytes:formatBytes,
        strtotime:strtotime,
        timeFormat:timeFormat,
        imgLoadError:imgLoadError,
        selectPage:selectPage,
        toCamelCase:toCamelCase,
        dataToCamelCase:dataToCamelCase,
        checkUrlTab:checkUrlTab,
        $:$,
        layer:layer
    }
});