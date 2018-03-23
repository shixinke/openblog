define(['fn', 'bootstrap', 'utils'], function(fn){
    var $ = fn.$;
    var layer = fn.layer;
    var options = {
        loadingBox:$('#loading-box'),
        postsCount:$('#postsCount'),
        tagCount:$('#tagCount'),
        viewCount :$('#viewCount'),
        commentCount : $('#commentCount'),
        dailyPostsCount:$('#dailyPostsCount'),
        dailyPostsRate : $('#dailyPostsRate'),
        dailyCommentCount : $('#dailyCommentCount'),
        dailyCommentRate:$('#dailyCommentRate'),
        dailyTagCount:$('#dailyTagCount'),
        dailyTagRate:$('#dailyTagRate'),
        hotTopics:$('#hot-topic-tbody'),
        hotPosts:$('#hot-posts-tbody'),
        hotTags:$('#hot-tag-tbody'),
        hotCategory:$('#hot-category-tbody')
    };
    var init = function(){
        events();
    };

    var events = function() {
        options.loadingBox.show();
        fn.checkUrlTab();
        model();
    };

    var getTrTpl = function(lists) {
        var html = "";
        if (!lists) {
            html = "<tr><td>暂无数据</td></tr>"
        } else {
            for (var i=0; i<= lists.length; i++) {
                html += '<tr>';
                for (var ele in lists[i]) {
                    html += '<td>'+lists[i][ele]+'</td>';
                }
                html += '</tr>';
            }
        }
        return html;
    };

    var model = function(){
        $.ajax({
            url:'/admin/dashboard/stats',
            type:'get',
            data:{},
            dataType:'json',
            success:function(result){
                options.loadingBox.hide();
                var res = result || {};
                if (res.code) {
                    if (res.code == 5006) {
                        layer.msg("用户未登录", {icon : 5});
                        window.parent.location.href = res.data.url;
                    } else if(res.code == 200) {
                        var statsData = res.data;
                        options.postsCount.text(statsData.total.posts);
                        options.tagCount.text(statsData.total.tags);
                        options.viewCount.text(statsData.total.views);
                        options.commentCount.text(statsData.total.comments);
                        options.dailyPostsCount.text(statsData.today.posts);
                        options.dailyTagCount.text(statsData.today.tags);
                        options.dailyCommentCount.text(statsData.today.comments);
                        var postsRate = Math.ceil(statsData.dailyPostsCount/statsData.total.posts);
                        var tagRate = Math.ceil(statsData.dailyTagCount/statsData.total.tags);
                        var commentRate = Math.ceil(statsData.dailyCommentCount/statsData.total.comments);
                        options.dailyPostsRate.css("width", postsRate+"%");
                        options.dailyTagRate.css("width", tagRate+"%");
                        options.dailyCommentRate.css("width", commentRate+"%");
                        if (statsData.topicList) {
                            var html = '';
                            for (var i=0; i< statsData.topicList.length; i++) {
                                var row = statsData.topicList[i];
                                html += '<tr>';
                                html += '<td>'+row.topicId+'</td>';
                                html += '<td>'+row.topicName+'</td>';
                                html += '<td>'+row.posts+'</td>';
                                html += '<td><a href="/admin/topic/edit?id='+row.topicId+'" title="查看专题" target="_blank" class="tab-link" data-id="topicEdit"><i class="iconfont icon-search"></i></a></td>';
                                html += '</tr>';
                            }
                            options.hotTopics.append(html);
                        }
                        if (statsData.postsList) {
                            var html = '';
                            for (var i=0; i< statsData.postsList.length; i++) {
                                var row = statsData.postsList[i];
                                html += '<tr>';
                                html += '<td>'+row.postsId+'</td>';
                                html += '<td>'+row.title+'</td>';
                                html += '<td>'+row.views+'</td>';
                                html += '<td>'+row.comments+'</td>';
                                html += '<td>'+row.createTime+'</td>';
                                html += '<td><a href="/admin/posts/edit?id='+row.postsId+'" title="查看文章" target="_blank" class="tab-link" data-id="postsDetail"><i class="iconfont icon-search"></i></a></td>';
                                html += '</tr>';
                            }
                            options.hotPosts.append(html);
                        }
                        if (statsData.categoryList) {
                            var html = '';
                            for (var i=0; i< statsData.categoryList.length; i++) {
                                var row = statsData.categoryList[i];
                                html += '<tr>';
                                html += '<td>'+row.categoryId+'</td>';
                                html += '<td>'+row.categoryName+'</td>';
                                html += '<td>'+row.items+'</td>';
                                html += '<td><a href="/admin/category/edit?id='+row.categoryId+'" title="查看分类" target="_blank" class="tab-link" data-id="categoryDetail"><i class="iconfont icon-search"></i></a></td>';
                                html += '</tr>';
                            }
                            options.hotCategory.append(html);
                        }
                        if (statsData.tagList) {
                            var html = '';
                            for (var i=0; i< statsData.tagList.length; i++) {
                                var row = statsData.tagList[i];
                                html += '<tr>';
                                html += '<td>'+row.tagId+'</td>';
                                html += '<td>'+row.tagName+'</td>';
                                html += '<td>'+row.items+'</td>';
                                html += '<td><a href="/admin/tag/edit?id='+row.tagId+'" title="查看标签" target="_blank" class="tab-link" data-id="tagDetail"><i class="iconfont icon-search"></i></a></td>';
                                html += '</tr>';
                                html += '</tr>';
                            }
                            options.hotTags.append(html);
                        }

                    } else {
                        layer.msg("数据获取失败", {icon : 5})
                    }
                } else {
                    layer.msg("数据获取失败", {icon : 5})
                }
            },
            error:function(){
                options.loadingBox.hide();
                layer.msg("网络连接失败", {icon : 5})
            }
        });
    };

    return {
        init:init
    }
})