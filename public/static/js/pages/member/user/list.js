define(['jquery'], function($){
    var options = {
        selectGroup:$('.select-group'),
        avatarImg:$('.select-group .input-group-addon img'),
        inputText:$('.select-group input.input-text'),
        inputHidden:$('.select-group .hidden-user-id'),
        clearBtn:$('.select-group .clear-input'),
        dropdownMenu:$('.select-group .dropdown-menu'),
        listItem:$('.select-group .dropdown-menu ul li')
    };
    var init = function(){
        events();
    };

    var events = function() {
        options.inputText.on('focus', function(){
            options.dropdownMenu.show();
        });
        options.listItem.on('click', function(){
            var id = $(this).data('id');
            $(this).addClass('selected').siblings('li').removeClass('selected');
            options.avatarImg.attr('src', $(this).find('img').attr('src'));
            options.inputText.val($(this).find('a').text());
            options.inputHidden.val(id);
            options.selectGroup.addClass('active');
            options.dropdownMenu.hide();
        });
        options.clearBtn.on('click', function(){
            options.avatarImg.attr('src', '/images/default_avatar.png');
            options.inputText.val("");
            options.inputHidden.val("");
            options.selectGroup.removeClass('active');
            $('.select-group .dropdown-menu ul li.selected').removeClass('selected');
        });
        $(document).on('keyup', 'input.input-text', function () {
            options.listItem.show();
            var keywords = $(this).val();
            if ($(this).val() != '') {
                $(".select-group .dropdown-menu ul li:not([data-text*='" + keywords + "'])").hide();
                options.selectGroup.addClass('active');
            } else {
                options.selectGroup.removeClass('active');
            }
            options.avatarImg.attr('src', '/images/default_avatar.png');
            options.inputHidden.val("");
            $('.select-group .dropdown-menu ul li.selected').removeClass('selected');
        });
    };

    return {
        init:init
    }
});