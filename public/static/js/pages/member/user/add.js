define(['jquery', 'layer'], function($, layer){
    var options = {
        selectBtn:$('#select-btn'),
        userId:$('#userId'),
        nickname:$('#nickname'),
        avatar:$('#avatar'),
        avatarImg:$('#avatar-img'),
        testImgBtn:$('#test-avatar-btn')
    };
    var init = function(){
        events();
    };

    var events = function() {
        options.selectBtn.on('click', function(){
            var cookieValue = getCookie('MEIZUSTORESESSIONVAL');
            if (cookieValue) {
                try {
                    cookieValue = JSON.parse(decodeURIComponent(cookieValue));
                    options.userId.val(cookieValue.uid);
                    options.nickname.val(cookieValue.username);
                    options.avatar.val(cookieValue.avatar);
                    options.avatarImg.attr('src', cookieValue.avatar).show();
                } catch(e) {
                    console.log("解析cookie失败:"+e);
                    layer.msg("未获取到登录信息", {icon : 5});
                }
            } else {
                layer.msg("flyme用户未登录", {icon : 5});
            }
        });

        options.testImgBtn.on('click', function(){
            var avatarValue = options.avatar.val();
            if (avatarValue.length > 0 && avatarValue.substr(0, 4) == 'http') {
                options.avatarImg.attr('src', avatarValue).show();
            } else {
                layer.msg('请输入合法的头像地址');
            }
        });

    };

    var getCookie = function(name){
        var cookieArr = document.cookie.split(';');
        var cookieMap = {};
        for (var i = 0; i< cookieArr.length; i++) {
            var tmp = cookieArr[i].split('=');
            if (tmp.length > 1) {
                cookieMap[tmp[0].trim()] = decodeURIComponent(tmp[1]);
            }
        }
        if (name) {
            return cookieMap[name];
        }
        return cookieMap;
    };


    return {
        init:init
    }
});