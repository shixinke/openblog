define(['fn'], function(fn){
    var $ = fn.$;
    var layer = fn.layer;
    var options = {
        postsBody:$('#posts-body'),
        deletePostsBtn:$('.posts-actions a.delete-posts-btn'),
        commentListBox:$('#comment-list'),
        loadingBtn:$('#loading-flag-button'),
        loadingIconBox:$('.loading-icon-box'),
        loadingInfoBox:$('#loading-flag-info'),
        page:1,
        postsId:$('#postsId').val(),
        postsCommentContent:$('#comment-content'),
        postsAddcommentBtn:$('#add-posts-comment-btn'),
        postsCommentCount:$('#posts-comment-count'),
        postsActions:$('.posts-actions'),
        pageSize:15
    };
    var init = function(){
        events();
    };

    var formatCommentList = function(datalist){
        var html = "";
        if (!datalist || datalist.length < 1) {
            return html;
        }
        for(var i=0; i< datalist.length; i++) {
            var obj = datalist[i];
            var avatar = obj.avatar != '' ? obj.avatar : '/static/images/default_avatar.png';
            var actions = obj.actions ? obj.actions : {};
            html += '<div  class="comment-item" data-id="'+obj.commentId+'">' +
                           '<div class="comment-item-left">' +
                               '<div><a href="#"><img class="img-rounded" src="'+avatar+'" /> </a></div>' +
                           '</div>' +
                           '<div class="comment-item-middle">' +
                               '<div class="comment-item-middle-username" data-uid="'+obj.userId+'"><a href="#"><span>'+obj.username+'</span></a></div>' +
                               '<div class="comment-item-middle-content"><span>'+obj.content+'</span></div>' +
                               '<div class="comment-footer">' +
                                   '<div class="comment-footer-left">' +
                                       '<span><i class="iconfont icon-time"></i> '+obj.createTime+'</span>' +
                                   '</div>' +
                                   '<div class="comment-footer-actions">' +
                                        '<a href="javascript:;" class="delete-btn"><i class="iconfont icon-delete"></i>删除 </a>' +
                                   '</div>' +
                               '</div>' +
                               '<div class="add-comment-box">'+
                                   '<input type="hidden" class="at-user-id" value="">'+
                                   '<input type="hidden" class="at-nickname" value="">'+
                                   '<div class="add-comment-field">'+
                                       '<textarea class="form-control" rows="2" class="comment-content"  placeholder="写下你的评论..."></textarea>'+
                                   '</div>'+
                                   '<div class="add-comment-buttons">'+
                                       '<button type="button" class="btn btn-primary btn-sm add-comment-btn">评论</button>'+
                                       '<a  href="javascript:;"  class="add-comment-buttons-cancel">取消</a>'+
                                    '</div>'+
                               '</div>'+
                           '</div>' +
                       '</div>'
        }
        return html;
    };

    var events = function() {
        models("getCommentList");
        options.loadingBtn.on('click', function(){
            models("getCommentList");
        });
        options.postsBody.on('click', 'a.add-reply-buttons-cancel', function(){
            var $parent = $(this).parents('.add-comment-box');
            $parent.find('textarea').val("");
        });
        options.postsAddcommentBtn.on('click', function(){
            addComment(this);
        });
        
        options.postsActions.on('click', 'a.delete-posts-btn', function(){
            var index = layer.confirm('您确定要删除该帖子吗？', function(){
                models('deletePosts', [{id : options.postsId}, function(res){
                    res = res || {};
                    if (res.code == 200) {
                        layer.msg("删除成功", {icon : 1});
                        window.location.href = '/admin/posts/index';
                    } else {
                        layer.msg("删除失败", {icon : 5});
                    }
                }])
            }, function(){
                layer.close(index);
            });
        });
        options.commentListBox.on('click', 'a.comment-btn', function(){
            showCommentTextarea(this);
        });
        options.commentListBox.on('click', '.add-comment-btn', function(){
            addComment(this);
        });
        options.commentListBox.on('click', 'a.delete-btn', function(){
            var parents = $(this).parents(".comment-item");
            var id = parents.data('id');
            var index = layer.confirm('您确定要删除该回帖吗？', function(){
                models('deletecomment', [{id : id}, function(res){
                    res = res || {};
                    if (res.code == 200) {
                        layer.msg("删除成功", {icon : 1});
                        models("getCommentList");
                    } else {
                        layer.msg("删除失败", {icon : 5});
                    }
                }])
            }, function(){
                layer.close(index);
            });
        });
    };

    var _checkLogin = function(res){
        if (res) {
            if (res.code == 5006) {
                layer.msg('用户未登录', {icon : 5});
                window.location.href = res.data.url;
            }
        }
    };

   
    var addComment = function(selector){
        _checkLogin();
        var data = {};
        var parent = $(selector).parents('.add-reply-box');
        var content = parent.find('textarea:first').val();
        var parents = $(selector).parents(".comment-item");
        var commentCountBox = parents.find('.comment-count');
        if (content == '') {
            layer.msg("请填写评论内容", {icon : 5});
            return false;
        }
        data.postsId = options.postsId;
        data.content = content;
        if (parents.length > 0) {
            data.parentId = parents.data('id');
        } else {
            commentCountBox = options.postsCommentCount;
        }

        models("comment", [data, function(res){
            _checkLogin(res);
            if (res.code == 200) {
                layer.msg("评论成功", {icon : 1});
                options.page = 1;
                commentCountBox.text(parseInt(commentCountBox.text())+1);
                models('getCommentList');
            } else {
                console.log(res);
                layer.msg("评论失败", {icon : 5})
            }
        }])
    };

    var showCommentTextarea = function(selector){
        var parents = $(selector).parents('.comment-item');
        var addcommentBox = parents.find('.add-comment-box');
        var user = parents.find('.comment-item-middle-username');
        var textarea = parents.find('textarea:first');
        parents.find('.at-user-id').val(user.data('uid')+",");
        parents.find('.at-nickname').val(user.text()+",");
        textarea.val("@"+user.text()+","+textarea.val());
        if (addcommentBox.is(":visible")) {
            addcommentBox.hide();
        } else {
            addcommentBox.show();
        }
    };

    var preparecommentList = function(res){
        res = res || {};
        if (res.code == 200) {
            if (res.data.list.length < 1) {
                options.loadingBtn.hide();
                options.loadingInfoBox.show();
                options.loadingIconBox.hide();
                return;
            }
            if (res.data.pages == options.page) {
                options.loadingBtn.hide();
            } else {
                options.page ++;
            }
            if (res.data.page == 1) {
                options.commentListBox.html(formatCommentList(res.data.list));
            } else {
                options.commentListBox.append(formatCommentList(res.data.list));
            }

        } else {
            options.loadingBtn.hide();
            options.loadingInfoBox.show();
        }
        options.loadingIconBox.hide();
    };

    var models = function(method, args) {
        var _class = {
            deletePosts:function(){
                _class['request'](['/admin/posts/delete', args[0], 'post', args[1]]);
            },
            getCommentList:function(args){
                options.loadingIconBox.show();
                _class['request'](['/admin/comment/lists?postsId='+options.postsId+"&page="+options.page+"&pageSize="+options.pageSize, {}, 'get', function(res){
                    preparecommentList(res);
                }]);
            },
            comment:function(args){
                _class['request'](['/admin/comment/add', args[0], 'post', args[1]]);
            },
            deletecomment:function(){
                _class['request'](['/admin/comment/delete', args[0], 'post', args[1]]);
            },
            request:function(args){
                console.log(args);
                $.ajax({
                    url:args[0],
                    data:args[1],
                    type:args[2],
                    dataType:'json',
                    success:args[3],
                    error:function(){
                        layer.msg("网络错误", {icon : 5});
                    }
                })
            }
        };
        return _class[method](args);
    };


    return {
        init:init
    }
})