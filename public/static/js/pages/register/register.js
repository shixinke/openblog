define(['fn', 'jquery.validate', 'jquery.form', 'jquery.md5'], function(fn){
    var $ = fn.$;
    var layer = fn.layer;
    var options = {
        form : $('#register-form'),
        password:$('#password'),
        index : 0
    };
    var init = function(){
        checkRegister();
    };

    var checkRegister = function(){
        options.form.validate({
            errorClass:'login-error',
            rules:{
                account:{
                    required:true
                },
                password:{
                    required:true
                },
                nickname:{
                    required:true
                },
                email:{
                    required : true,
                    email : true
                }
            },
            messages:{
                account:{
                    required:"请输入账号"
                },
                password:{
                    required:'请输入密码'
                },
                nickname : {
                    required : '请输入昵称'
                },
                email:{
                    required : '请输入邮箱',
                    email : '请输入合法的邮箱'
                }
            },
            errorPlacement: function(error, element) {
                error.appendTo(element.parent().next('.help-block'));
            },
            submitHandler: function (form) {
                options.password.val($.md5(options.password.val()));
                $(form).ajaxSubmit({
                    dataType:'json',
                    type:'post',
                    success:function(res){
                        var res = res || {};
                        if (res && res.code && (res.code == 6000)) {
                            layer.msg('注册成功，请登录', {icon : 1, time : 2000}, function(){
                                window.location.href = '/passport/login#system';
                            });
                        } else {
                            var msg = res && res.message && res.message != '' ? res.message : '登录失败';
                            layer.msg(msg, {icon : 2})
                        }
                    },
                    error:function(){
                        layer.msg("网络不稳定，请稍候重试", {icon : 2})
                    }
                });
            }
        });
    };
    return {
        init:init
    }
});