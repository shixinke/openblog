define(['jquery', 'fn', 'layer'], function($, fn, layer){
    var options = {
        inputLogo:$('#logo'),
        validateBtn:$('#validate-logo-btn'),
        imgPreview : $('#logo-preview')
    };
    var init = function(){
        events();
    };


    var events = function() {
       options.validateBtn.on('click', function(){
           var val = options.inputLogo.val();
           if (val.substring(0, 4) != 'http') {
               layer.message("请输入有效有LOGO地址", {icon : 5});
               return false;
           }
           options.imgPreview.attr('src', val);
       })
    };

    return {
        init:init
    }
})