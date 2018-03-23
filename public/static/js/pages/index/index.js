define(['fn', 'bootstrap',  'jquery.slimscroll', 'jquery.cookie', 'jquery.iframetabs'], function(fn){
    var $ = fn.$;
    var layer = fn.layer;
    var tabObj;
    var options = {
        skinItem:$('#header .skin-list li a'),
        logoutBtn:$('#logout-btn'),
        changeIdentityBtn:$('.change-identity'),
        sidebarToggleBtn:$('.sidebar-toggle'),
        sidebarMenuItem:$('.sidebar-menu .sidebar-menu-item'),
        sidebarSubMenuLi:$('.treeview-menu li'),
        treeviewMenuItem:$('.sidebar-menu>li'),
        treeviewMenuLink:$('.treeview>a'),
        defaultMenuItem:$('.sidebar-menu .sidebar-menu-item:eq(0)'),
        clearCacheBtn:$('#clear-cache-btn'),
        sidebarSearchForm:$('form.sidebar-form'),
        sidebarSearchInputGroup:$('form.sidebar-form > .input-group'),
        sidebarSearchResult:$('.menuresult'),
        skinList:[
            "skin-blue",
            "skin-black",
            "skin-red",
            "skin-yellow",
            "skin-purple",
            "skin-green",
            "skin-blue-light",
            "skin-black-light",
            "skin-red-light",
            "skin-yellow-light",
            "skin-purple-light",
            "skin-green-light"
        ]
    };
    var init = function(){
        //初始化皮肤
        initSkin();
        initIframeTabs();
        events();
    };

    var events = function() {
        //点击更换皮肤
        changeSkinEvent();
        fullscreenEvent();
        clearCacheEvent();
        logoutEvent();
        sidebarSearchEvent();
        sidebarMenuItemEvent();
        loadPageEvent();
        changeIdentityEvent();
        initLayout();
        storageEvent();
    };

    var initSkin = function(){
        var skinClassName = $.cookie('skin');
        if (skinClassName) {
            changeSkin(skinClassName, false);
        }
    };

    var initLayout = function(){
        // 重设选项
        if ($('body').hasClass('fixed')) {
            $("[data-layout='fixed']").attr('checked', 'checked');
        }
        if ($('body').hasClass('layout-boxed')) {
            $("[data-layout='layout-boxed']").attr('checked', 'checked');
        }
        if ($('body').hasClass('sidebar-collapse')) {
            $("[data-layout='sidebar-collapse']").attr('checked', 'checked');
        }
        if ($('ul.sidebar-menu').hasClass('show-submenu')) {
            $("[data-menu='show-submenu']").attr('checked', 'checked');
        }
        if ($('ul.nav-addtabs').hasClass('disable-top-badge')) {
            $("[data-menu='disable-top-badge']").attr('checked', 'checked');
        }
    };

    var initIframeTabs = function(){
        var $defaultTab = options.defaultMenuItem;
        tabObj =  $('#content-wrapper').iframeTabs({defaultTab : {id : $defaultTab.data('id'), url : $defaultTab.attr('href'), label : $defaultTab.text()}});
        if (window.sessionStorage) {
            window.sessionStorage.setItem("tabObj", tabObj);
        }
    };

    var changeSkinEvent = function(){
        options.skinItem.on('click', function(){
            var name = $(this).attr('data-skin');
            changeSkin(name, true);
        });
    };

    var clearCacheEvent = function(){
        options.clearCacheBtn.on('click', function(){
            if (window.localStorage) {
                window.localStorage.clear();
            }
            if (window.sessionStorage) {
                window.sessionStorage.clear();
            }
            layer.msg('清除成功', {icon : 1});
        });
    };
    var logoutEvent = function(){
        options.logoutBtn.on('click', function(e){
            e.preventDefault();
            var url = $(this).attr('href');
            layer.confirm('您确定要退出登录吗？', {icon : 1}, function(idx){
                if (window.localStorage) {
                    window.localStorage.setItem("isLogin", 0);
                }
                if (window.sessionStorage) {
                    window.sessionStorage.removeItem('open_tab_list');
                    window.sessionStorage.removeItem('active_tab');
                }
                layer.msg('退出成功', {icon :1}, function(){
                    window.location.href = url;
                });
                layer.close(idx);
            }, function(idx){
                layer.close(idx);
            });
        });
    };
    var fullscreenEvent = function(){
        //全屏事件
        $(document).on('click', "[data-toggle='fullscreen']", function () {
            var doc = document.documentElement;
            if ($(document.body).hasClass("full-screen")) {
                $(document.body).removeClass("full-screen");
                document.exitFullscreen ? document.exitFullscreen() : document.mozCancelFullScreen ? document.mozCancelFullScreen() : document.webkitExitFullscreen && document.webkitExitFullscreen();
            } else {
                $(document.body).addClass("full-screen");
                doc.requestFullscreen ? doc.requestFullscreen() : doc.mozRequestFullScreen ? doc.mozRequestFullScreen() : doc.webkitRequestFullscreen ? doc.webkitRequestFullscreen() : doc.msRequestFullscreen && doc.msRequestFullscreen();
            }
        });
    };

    var sidebarSearchEvent = function(){
        options.sidebarSearchResult.width(options.sidebarSearchInputGroup.width());
        var searchResult = options.sidebarSearchResult;
        options.sidebarSearchForm.on("blur", "input[name=q]", function () {
            searchResult.addClass("hide");
        }).on("focus", "input[name=q]", function () {
            if ($("a", searchResult).size() > 0) {
                searchResult.removeClass("hide");
            }
        }).on("keyup", "input[name=q]", function () {
            searchResult.html('');
            var val = $(this).val();
            var html = new Array();
            if (val != '') {
                options.sidebarMenuItem.each(function () {
                    if ($(this).text().indexOf(val) > -1 || $(this).attr("href").indexOf(val) > -1) {
                        html.push('<a data-url="' + $(this).attr("href") + '" data-id="'+$(this).data('id')+'" href="javascript:;">' + $("span:first", this).text() + '</a>');
                        if (html.length >= 100) {
                            return false;
                        }
                    }
                });
            }
            searchResult.append(html.join(""));
            if (html.length > 0) {
                searchResult.removeClass("hide");
            } else {
                searchResult.addClass("hide");
            }
        });
        //快捷搜索点击事件
        options.sidebarSearchForm.on('mousedown click', '.menuresult a[data-url]', function () {
            tabObj.add({id: $(this).data('id'), url : $(this).data('url'), label : $(this).text()});
        });

    };
    var sidebarMenuItemEvent = function(){
        //显示大菜单或小菜单
        options.sidebarToggleBtn.on('click', function(){
            var body = $('body');
            if (body.hasClass('sidebar-collapse')) {
                body.removeClass('sidebar-collapse');
            } else {
                body.addClass('sidebar-collapse');
            }
        });
        //左侧一级菜单
        options.treeviewMenuLink.on('click', function(){
            var $parent = $(this).parent('li');
            $parent.addClass('active').siblings('li').removeClass('active');
            var $next = $(this).next('ul.treeview-menu');
            var $icon = $(this).find('.icon-arrow');
            if ($next.is(':visible') == true) {
                $next.hide();
                $icon.removeClass('icon-small-down').addClass('icon-small-left');
            } else {
                $next.show();
                $icon.removeClass('icon-small-left').addClass('icon-small-down');
            }
        });
        //左侧有导航的菜单
        options.sidebarMenuItem.on('click', function(e){
            e.preventDefault();
            var $parent = $(this).parent('li');
            var id = $(this).attr('data-id');
            var url = $(this).attr('href');
            var title = $(this).text();
            if (window.localStorage) {
                var isLogin = window.localStorage.getItem('isLogin');
                if (!isLogin || isLogin != 1) {
                    $.ajax({
                        url : '/admin/passport/status',
                        type:'POST',
                        dataType:'json',
                        success:function(result){
                            console.log(result);
                            var resp = result || {};
                            if (resp.code != 200) {
                                if (window.localStorage) {
                                    window.localStorage.setItem('isLogin', 0);
                                }
                                window.parent.location.href = '/admin/passport/login';
                            }
                        }
                    });
                }
            }
            options.sidebarSubMenuLi.removeClass('active');
            $parent.addClass('active').siblings('li').removeClass('active');
            tabObj.add({id: id, url : url, label : title});
        });
    };
    var loadPageEvent = function(){
        require(['fn'], function(fn){
            fn.loadPage();
        });
    };
    var storageEvent = function(){
        $(window).on('storage', function(e){
            var event = e.originalEvent;
            if (event.key == 'isLogin' && event.newValue == '0') {
                if (window.sessionStorage) {
                    window.sessionStorage.removeItem('open_tab_list');
                    window.sessionStorage.removeItem('active_tab');
                }
                window.location.href = "/passport/login";
            }
        });
    };
    var changeIdentityEvent = function(){
        options.changeIdentityBtn.on('click', function(){
            var img = $(this).find('img');
            var _self = $(this);
            fn.changeIdentity({title:'切换身份', btn:['确定', '取消']}, function(){
                //
            },function(data){
                img.attr('src', data.avatar);
                _self.attr('title', data.nickname);
                layer.msg('切换成功', {icon : 1, time : 2000});
            }, function(){
                layer.msg('切换失败', {icon : 5, time : 2000});
            });
        });
    };
    //功能型函数
    var changeSkin = function(cls, setCookie) {
        if (!$("body").hasClass(cls)) {
            //修改皮肤颜色
            $.each(options.skinList, function (i) {
                $("body").removeClass(options.skinList[i]);
            });
            var cssfile = "/css/skins/" + cls + ".css";
            var links = [];
            $("link").each(function(){
                links.push($(this).attr('href'));
            });
            if ($.inArray(cssfile, links) < 0) {
                $('head').append('<link rel="stylesheet" href="' + cssfile + '" type="text/css" />');
            }
            $("body").addClass(cls);
            if (setCookie) {
                $.cookie('skin', cls);
            }
            //修改显示
            options.skinItem.each(function(){
                var name = $(this).attr('data-skin');
                if (name == cls) {
                    $(this).addClass('active');
                } else {
                    $(this).removeClass('active');
                }
            });
        }
        return false;
    };

    return {
        init:init
    }
})