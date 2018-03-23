//value即数据
//row为数据行对象
//index为行索引值
function imgUrlFormatter(value, row, index) {
    return '<img src="'+value+'" class="list-thumb">';
}

function imgFormatter(value, row, index) {
    return imgUrlFormatter(value, row, index)
}

function imgageFormatter(value, row, index) {
    return imgUrlFormatter(value, row, index)
}

function urlFormatter(value, row, index) {
    if (value) {
        return '<a href="'+value+'" target="_blank"><i class="iconfont icon-link"></i>'+value+'</a>';
    }
}

function statusFormatter(value, row, index) {
    if (value == 1) {
        return '<span class="text-success"><i class="iconfont icon-black-bg-dot"></i> 正常</span>';
    } else {
        return '<span class="text-primary"><i class="iconfont icon-black-bg-dot"></i> 禁用</span>';
    }
}

function booleanFormatter(value, row, index) {
    if (value == 1) {
        return '<a class="btn btn-success btn-xs"><i class="iconfont icon-confirm"></i> 是</a>';
    } else {
        return '<a class="btn btn-default btn-xs"><i class="iconfont icon-close"></i> 否</a>';
    }
}

function iconFormatter(value, row, index) {
    if (value && value != '') {
        return '<i class="iconfont '+value+'"></i> ';
    }
    return '-'
}

function dateTimeFormatter(value, row, index) {
    if (!value ) {
        return
    }
    if (typeof value == 'number') {
        var date = new Date(value);
        return '<i class="iconfont icon-time"></i> '+date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds();
    } else {
        return '<i class="iconfont icon-time"></i> '+value;
    }

}

function inArray(element, arr) {
    for (var i=0; i< arr.length; i++) {
        if (element == arr[i]) {
            return true;
        }
    }
    return false;
}

function responseHandler(res){
    if (res.data) {
        return {
            total:res.data.total,
            rows:res.data.list
        }
    } else {
        return {
            total : 0,
            rows:[]
        }
    }
}

function queryParams(options) {
    var params = {};
    $('#search-toolbar').find('input[name]').each(function () {
        params[$(this).attr('name')] = $(this).val();
    });
    $('#search-toolbar').find('select[name]').each(function () {
        params[$(this).attr('name')] = $(this).val();
    });
    params.page = options.pageNumber;
    params.pageSize = options.pageSize;
    return params;
}

function operateFormatter(value, row, index){
    var id = row[app.pk];
    var tpls = {
        add:'<a href="{{addUrl}}" data-url="{{addDataUrl}}" data-width="1000" data-height="800" data-id="'+id+'" class="btn btn-xs btn-success btn-edit {{loadpage}}" title="编辑">'+
                '<i class="iconfont icon-plus"></i>'+
            '</a>',
        edit:'<a href="{{editUrl}}" data-url="{{editDataUrl}}" data-width="1000" data-height="800" data-id="'+id+'" class="btn btn-xs btn-success btn-edit {{loadpage}}" title="编辑">'+
                '<i class="iconfont icon-edit"></i>'+
              '</a>',
        delete:'<a href="javascript:;" data-action="{{deleteUrl}}" data-id="'+id+'" class="btn btn-xs btn-danger btn-del-row" title="删除">'+
                  '<i class="iconfont icon-delete"></i>'+
               '</a>',

        resort:'<a href="javascript:;" data-action="{{resortUrl}}" data-id="'+id+'" class="btn btn-xs btn-primary btn-dragsort" title="排序">'+
                   '<i class="iconfont icon-drag"></i>'+
               '</a>',
        detail:'<a href="{{detailUrl}}" data-url="{{detailDataUrl}}" data-width="1000" data-height="800" data-id="'+id+'" class="btn btn-xs btn-success {{loadpage}}" title="查看详情">'+
                  '<i class="iconfont icon-search"></i>'+
               '</a>',
        password:'<a href="{{passwordUrl}}" data-url="{{passwordDataUrl}}" data-width="1000" data-height="800" data-id="'+id+'" class="btn btn-xs btn-success {{loadpage}}" title="修改密码">'+
        '<i class="iconfont icon-password"></i>'+
        '</a>'
    };
    var html = "";
    var params = "";
    if (app.params) {
        var paramsArr = new Array();
        for (var param in app.params) {
            var value = app.params[param];
            if (value == '' || value == '{{'+param+'}}') {
                value = value.replace('{{'+param+'}}', row[param]);
            }
            paramsArr.push(param+'='+value);
        }
        if (paramsArr.length > 0) {
            params = paramsArr.join('&');
        }
    }
    var urlPrefix = '/'+app.module+'/'
    if (app.group && app.group != '') {
        urlPrefix = '/'+app.group+urlPrefix;
    }
    if (app.action) {
        if (inArray('add', app.action)) {
            var addUrl = "javascript:;";
            var loadPage = "loadpage";
            var addDataUrl = urlPrefix+app.add;
            if (params != '') {
                addDataUrl = addDataUrl+'?'+params;
            }
            if (app.isAddPage) {
                addUrl = addDataUrl;
                loadPage = "";
            }
            html += tpls.add.replace('{{addDataUrl}}', addDataUrl).replace('{{addUrl}}', addUrl).replace('{{loadpage}}', loadPage);
        }
        if (inArray('edit', app.action)) {
            var editUrl = "javascript:;";
            var loadPage = "loadpage";
            var editDataUrl = urlPrefix+app.edit+"?id="+id;
            if (app.isEditPage) {
                editUrl = editDataUrl;
                loadPage = "";
            }
            html += tpls.edit.replace('{{editDataUrl}}', editDataUrl).replace('{{editUrl}}', editUrl).replace('{{loadpage}}', loadPage);
        }
        if (inArray('detail', app.action)) {
            var detailUrl = "javascript:;";
            var loadPage = "loadpage";
            var detailDataUrl = urlPrefix+app.detail+"?id="+id;
            if (app.isDetailPage) {
                detailUrl = detailDataUrl;
                loadPage = "";
            }
            html += tpls.detail.replace('{{detailDataUrl}}', detailDataUrl).replace('{{detailUrl}}', detailUrl).replace('{{loadpage}}', loadPage);
        }
        if (inArray('password', app.action)) {
            var passwordUrl = "javascript:;";
            var loadPage = "loadpage";
            var passwordDataUrl = urlPrefix+app.password+"?id="+id;
            if (app.isDetailPage) {
                passwordUrl = passwordDataUrl;
                loadPage = "";
            }
            html += tpls.password.replace('{{passwordDataUrl}}', passwordDataUrl).replace('{{passwordUrl}}', passwordUrl).replace('{{loadpage}}', loadPage);
        }
        if (inArray('delete', app.action)) {
            var   deleteUrl = urlPrefix+app.del;
            html += tpls.delete.replace('{{deleteUrl}}', deleteUrl);
        }
        if (inArray('sort', app.action)) {
            var   resortUrl = urlPrefix+app.resort;
            html += tpls.resort.replace('{{resortUrl}}', resortUrl);
        }
    }
    return html;
}

var operateEvents = {
    'click .btn-del-row': function (e, value, row, index) {
        var id = $(this).data('id');
        var $table = $(this).parents('table');
        var url = $(this).data('action');
        require(['fn'], function(fn){
            fn.ajaxDelSubmit(url,{id : id}, {}, function(res){
                var res = res || {};
                if(res.code == 200) {
                    layer.msg("删除成功", {icon : 1});
                    $table.bootstrapTable('remove', {
                        field: app.pk,
                        values: [id]
                    });
                } else {
                    var msg = res.message || '删除失败';
                    layer.msg(msg, {icon : 2});
                }
            });
        });
    }
};
