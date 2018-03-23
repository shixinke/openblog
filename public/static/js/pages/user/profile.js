define(['jquery', 'bootstrap', 'layer', 'sortable'], function($, b, layer, Sortable){
    var options = {
        avatarBtn:$('.profile-avatar-text:first'),
        avatarPreview:$('#avatar-preview'),
        avatarHidden:$('#avatar-hidden'),
        avatarListBox:$('#avatar-list'),
        avatarItem:$('.avatar-list-ul li')
    };
    var init = function(){
        events();
    };

    var events = function() {
        options.avatarBtn.on('click', function(){
            options.avatarItem.removeClass('active');
            var currentAvatar = options.avatarPreview.attr('src');
            options.avatarItem.each(function(){
                var src = $(this).find('img').attr('src');
                if (src == currentAvatar) {
                    $(this).addClass("active");
                    return;
                }
            });
            layer.open({
                title : '更换头像',
                type:1,
                content : options.avatarListBox,
                area:['460px', '400px'],
                btn:['确定'],
                yes:function(index, wrapper){
                    var $selectedItem = wrapper.find('.avatar-list-ul li.active');
                    if ($selectedItem.length > 0) {
                        var value = $selectedItem.find('img').attr('src');
                        options.avatarPreview.attr('src', value);
                        options.avatarHidden.val(value);
                    }
                    layer.close(index);
                }
            });
        });
        options.avatarItem.on('click', function(){
            $(this).addClass('active').siblings().removeClass('active');
        });
    };


    return {
        init:init
    }
});