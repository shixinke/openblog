define(['jquery', 'bootstrap', 'layer', 'jquery.dragsort'], function($, b, layer, drag){
    var options = {
        picker:'#multi-upload-btn',
        singlePicker:'#single-upload-btn',
        uploadPreviewImg:'.upload-preview',
        uploadValueInput:'#upload-hidden',
        uploadQueueList:$('#upload-queue-list'),
        uploadedFileList:$('#uploaded-file-list'),
        startUploadBtn:$('.start-upload-btn'),
        startUploadBtnSpan:$('.start-upload-btn span:first'),
        cancelUploadBtn:$('.cancel-upload-btn'),
        delAllUploadedItem:$('#upload-file-list .delete-all'),
        fileUploadedBox:$('#uploaded-file-list'),
        uploadedItem:$('#uploaded-file-list dd'),
        fileEditBtn:$('#uploaded-file-list dd .file-img-edit'),
        fileDelBtn:$('#uploaded-file-list dd .file-img-delete'),
        fileImgList:$('.file-img-list'),
        uploadBeforeBox:$('#upload-before-box'),
        fileItemBox:$('#file-item-box'),
        confirmCloseBtn:$('.confirm-btn:first'),
        singlePreview:$('#single-upload-preview'),
        singleValue:$('#single-upload-value'),
        singleInfo:$('#single-upload-info'),
        singleUploadBox:$('.single-upload-box'),
        uploadState:'pending',
        layerIndex:0,
        uploadServerUrl:'/admin/upload/attach',
        sortServerUrl:'',
        delServerUrl:'/admin/upload/remove',
        fileQueueList:[],
        thumb:{
            width:200,
            height:100,
            quality:80
        },
        fileQueueItemTpl:'<dd data-id="{{fileId}}" class="active" data-type="queue" data-file-id="0">'+
        '<a href="javascript:;" class="remove-btn file-queue-del"><i class="iconfont icon-close-circle"></i></a>'+
        '<img src="{{thumb}}" class="file-img-thumb" title="点击可选择">'+
        '<a href="javascript:;" class="file-select-btn"><i class="iconfont icon-selected"></i></a>'+
        '<p class="upload-status">'+
        '<span class="upload-progress-text">未上传</span>'+
        '<span class="upload-progress-percent text-success">0%</span>'+
        '</p>'+
        '<div class="progress"><div class="progress-bar progress-bar-success" style="width: 0%"></div></div>'+
        '</dd>',
        fileUploadedItemTpl:'<dd data-file-id="{{id}}" data-index="{{index}}" data-sort="{{sort}}" title="拖动改变排序">'+
        '<a href="javascript:;" class="remove-btn file-img-delete"><i class="iconfont icon-close-circle"></i></a>'+
        '<img src="{{url}}" class="file-img-thumb"><input type="hidden" name="url" value="{{url}}"><input type="hidden" name="text" value="" class="hidden-text"><input type="hidden" name="fileInfo" class="hidden-file-info" value="">'+
        '<p class="file-img-title">暂无说明</p>'+
        '<div class="btn-toolbar">'+
        '<a href="javascript:;" title="修改图片标题" class="file-img-edit"><i class="iconfont icon-edit"></i></a>'+
        '<a href="javascript:;" title="删除图片" class="file-img-delete"><i class="iconfont icon-delete"></i></a>'+
        '</div>'+
        '</dd>'
    };
    var init = function(){
        events();
    };

    var events = function() {
        require(['webuploader'], function(WebUploader){

            var uploader = WebUploader.create({
                swf:'/static/js/libs/webuploader/0.1.5/Uploader.swf',
                server: options.uploadServerUrl,
                auto:false,
                pick: {
                    id:options.picker,
                    multiple:true
                },
                thumb:options.thumb,
                accept:{title: 'Images', extensions: 'gif,jpg,jpeg,bmp,png', mimeTypes: 'image/jpg,image/jpeg,image/png,image/gif,image/bmp'},
                resize: false,
                threads:10
            });

            uploader.on('fileQueued', function(file){
                var tpl = options.fileQueueItemTpl.replace('{{fileId}}', file.id).replace('{{thumb}}', '');
                var $li = $(tpl);
                var $img = $li.find('img:first');
                options.uploadQueueList.append($li);
                uploader.makeThumb(file, function(error, src){

                    if (error) {
                        $img.attr('src', '/static/images/img_error.png');
                        console.log('不能预览');
                        return;
                    }
                    $img.attr('src', src);
                }, options.thumb.width, options.thumb.height);
            });
            uploader.on('filesQueued', function(file){
                options.fileQueueList = arrToObject(file, 'id');
                var layerBox = $('#layui-layer'+options.layerIndex);
                if (layerBox.length > 0) {

                } else {
                    options.layerIndex = layer.open({
                        type:1,
                        content:options.uploadBeforeBox,
                        title:'选择上传文件',
                        area:['800px', '600px']
                    });
                }
            });

            options.startUploadBtn.on('click', function(){
                if (options.uploadState == 'uploading') {
                    uploader.stop();
                } else {
                    uploader.upload();
                }

            });
            uploader.on('all', function(type){
                if (type == 'startUpload') {
                    options.uploadState = 'uploading';
                } else if(type == 'stopUpload') {
                    options.uploadState = 'paused';
                } else if (type == 'uploadFinished') {
                    options.uploadState = 'done';
                }
                if ( options.uploadState == 'uploading') {
                    options.startUploadBtnSpan.text('暂停上传');
                } else {
                    options.startUploadBtnSpan.text('开始上传');
                }
            });
            uploader.on( 'uploadError', function( file, reason ) {
                layer.msg('上传失败', {icon:5});
            });
            uploader.on('uploadProgress', function(file, percentage){
                var $li = options.uploadQueueList.find('dd[data-id='+file.id+']');
                $li.find('.upload-progress-text').text('上传中……');
                if (percentage == 1) {
                    $li.find('.upload-progress-text').text('上传完成');
                }
                var value = percentage * 100 + '%';
                $li.find('.upload-progress-percent').text(value);
                $li.find('.progress-bar').css('width', value);
            });

            uploader.on('uploadSuccess', function(file, ret){
                var ret = ret || {};
                var $li = options.uploadQueueList.find('dd[data-id='+file.id+']');
                var html;
                if (ret.code && ret.code == 200) {
                    $li.find('img').attr('src', ret.data.url);
                    $li.data('file-id', ret.data.id);
                    var length = options.uploadedFileList.find('dd').length;
                    html = options.fileUploadedItemTpl.replace('{{id}}', ret.data.id).replace(/\{\{url\}\}/g, ret.data.url).replace('{{sort}}', ret.data.sort).replace('{{index}}', length);
                    var $wrapper = $(html);
                    $wrapper.find('.hidden-file-info').val(JSON.stringify(ret.data));
                    $wrapper.appendTo(options.uploadedFileList);
                    $li.remove();
                } else {
                    layer.msg(ret.message, {icon:5});
                }
            });

            options.uploadQueueList.on('click', 'a.file-queue-del', function(){
                var $parent = $(this).parents('dd');
                $parent.remove();
                uploader.removeFile($parent.data('id'), true);
                delete options.fileQueueList[$parent.data('id')];
            });

            options.fileImgList.on('click', 'img', function(){
                var $parent = $(this).parents('dd');

                var type = $parent.data('type');
                var id = $parent.data('id');
                if ($parent.hasClass('active')) {
                    $parent.removeClass('active');
                    if (type == 'queue') {
                        uploader.removeFile(id, true);
                    }
                } else {
                    $parent.addClass('active');
                    if (type == 'queue') {
                        uploader.addFiles(options.fileQueueList[id]);
                    }
                }
            });

            options.delAllUploadedItem.on('click', function(){
                //交互先放着
                options.uploadedItem.remove();
            });

            options.fileUploadedBox.on('click', 'a.file-img-delete', function(){
                var $parent = $(this).parents('dd');
                $.ajax({
                    url:options.delServerUrl,
                    type:'post',
                    data:{id:[$parent.data('file-id')]},
                    dataType:'json',
                    success:function(resp){
                        var result = resp || {};
                        if (result.code == 200) {
                            layer.msg('删除成功', {icon : 1});
                            $parent.remove();
                        } else {
                            layer.msg('删除失败', {icon : 5});
                        }
                    }
                });
                $parent.remove();
            });

            options.fileUploadedBox.on('click', 'a.file-img-edit', function(){
                var $parent = $(this).parents('dd');
                options.fileItemBox.find('img').attr('src', $parent.find('img').attr('src'));
                var $hiddenText = $parent.find('.hidden-text');
                var $imgTitle = $parent.find('.file-img-title');
                layer.open({
                    content:options.fileItemBox.html(),
                    title:'修改图片标题',
                    yes:function(index, wrapper){
                        var title = wrapper.find('.img-title').val();
                        if (typeof title != 'undefined' && title != '') {
                            $hiddenText.val(title);
                            $imgTitle.text(title);
                        }
                        layer.close(index);
                    }
                });
            });

            options.confirmCloseBtn.on('click', function(){
                layer.close(options.layerIndex);
            });

            var singleUploader = WebUploader.create({
                swf:'/static/js/libs/webuploader/0.1.5/Uploader.swf',
                server: options.uploadServerUrl,
                auto:true,
                pick: {
                    id:options.singlePicker,
                    multiple:false
                },
                thumb:options.thumb,
                accept:{title: 'Images', extensions: 'gif,jpg,jpeg,bmp,png', mimeTypes: 'image/jpg,image/jpeg,image/png,image/gif,image/bmp'},
                resize: false
            });
            singleUploader.on( 'uploadError', function( file, reason ) {
                layer.msg('上传失败', {icon:5});
            });

            singleUploader.on('uploadSuccess', function(file, ret){
                var ret = ret || {};
                var html = '';
                if (ret.code && ret.code == 200) {
                    ret.data = ret.data || {};
                    ret.data.fileType = ret.data.fileType || 'image';
                    if (ret.data.fileType == 'image') {
                        html = '<img src="'+ret.data.url+'" class="file-img-thumb">'
                    } else if (ret.data.fileType == 'video') {
                        html = '<video src="'+ret.data.url+'"></video>';
                    } else if(ret.data.fileType == 'audio') {
                        html = '<audio src="'+ret.data.url+'"></audio>';
                    }
                    options.singleUploadBox.addClass('active');
                    options.singlePreview.html(html);
                    options.singleInfo.val(JSON.stringify(ret.data));
                    options.singleValue.val(ret.data.url);
                } else {
                    layer.msg(ret.message, {icon:1});
                }
            });

            options.singleUploadBox.on('click', 'a.remove-btn', function(){
                options.singleUploadBox.removeClass('active');
                options.singlePreview.html("");
            });


        });
        options.uploadedFileList.dragsort({ dragSelector: "dd", dragEnd: function() {
            /*
            var data = {};
            var newIndex = $(this).index();
            var $related = options.uploadedFileList.find('dd[data-index='+newIndex+']');
            data.id = $(this).data('file-id');
            data.sort = $(this).data('sort');
            data.relatedId = $related.data('file-id');
            data.relatedSort = $related.data('sort');
            */
            /*服务端排序实现*/
            /*
            $.ajax({
                url:options.sortServerUrl,
                type:'post',
                data:data,
                dataType:'json',
                success:function(response){
                    var result = response || {};
                    if (result.code == 200) {
                        layer.msg('排序成功', {icon : 1});
                        return true;
                    } else {
                        layer.msg('排序失败', {icon : 5});
                        return false;
                    }
                }
            });
            */
        }});
    };

    var arrToObject = function(arr, index){
        var obj = {};
        for(var i=0; i< arr.length; i++) {
            if (arr[i][index]) {
                obj[arr[i][index]] = arr[i];
            }
        }
        return obj;
    };


    return {
        init:init
    }
});