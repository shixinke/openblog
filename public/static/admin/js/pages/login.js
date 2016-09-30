//------------- login.js -------------//
$(document).ready(function() {

	//for custom checkboxes
	$('input').not('.noStyle').iCheck({
        checkboxClass: 'icheckbox_flat-green'
    });

	//validate login form 
	$("#login-form").validate({
		ignore: null,
		ignore: 'input[type="hidden"]',
		errorPlacement: function(error, element) {
			wrap = element.parent();
			wrap1 = wrap.parent();
			if (wrap1.hasClass('checkbox')) {
				error.insertAfter(wrap1);
			} else {
				if (element.attr('type')=='file') {
					error.insertAfter(element.next());
				} else {
					error.insertAfter(element);
				}
			}
		}, 
		errorClass: 'help-block',
		rules: {
			account: {
				required: true
			},
			password: {
				required: true,
				minlength: 5
			}
		},
		messages: {
			password: {
				required: "请输入密码",
				minlength: "输入至少需要5位"
			},
			account: "请输入账号",
		},
		highlight: function(element) {
			if ($(element).offsetParent().parent().hasClass('form-group')) {
				$(element).offsetParent().parent().removeClass('has-success').addClass('has-error');
			} else {
				if ($(element).attr('type')=='file') {
					$(element).parent().parent().removeClass('has-success').addClass('has-error');
				}
				$(element).offsetParent().parent().parent().parent().removeClass('has-success').addClass('has-error');
				
			}
	    },
	    unhighlight: function(element,errorClass) {
	    	if ($(element).offsetParent().parent().hasClass('form-group')) {
	    		$(element).offsetParent().parent().removeClass('has-error').addClass('has-success');
		    	$(element.form).find("label[for=" + element.id + "]").removeClass(errorClass);
	    	} else if ($(element).offsetParent().parent().hasClass('checkbox')) {
	    		$(element).offsetParent().parent().parent().parent().removeClass('has-error').addClass('has-success');
	    		$(element.form).find("label[for=" + element.id + "]").removeClass(errorClass);
	    	} else if ($(element).next().hasClass('bootstrap-filestyle')) {
	    		$(element).parent().parent().removeClass('has-error').addClass('has-success');
	    	}
	    	else {
	    		$(element).offsetParent().parent().parent().removeClass('has-error').addClass('has-success');
	    	}
		},
		submitHandler:function(form){
			$(form).ajaxSubmit({
				type:'post',
				url:$(form).attr('action'),
				dataType:'json',
				success: function(res){
					if (res.code == 200) {
						layer.msg(res.message, {icon : 1, time : 2000}, function(){
							window.location.href = '/admin/index'
						})
					} else {
						layer.msg('失败', {icon : 3});
					}
				}
			});
		}
	});

	$("#register-form").validate({
		ignore: null,
		ignore: 'input[type="hidden"]',
		errorPlacement: function(error, element) {
			wrap = element.parent();
			wrap1 = wrap.parent();
			if (wrap1.hasClass('checkbox')) {
				error.insertAfter(wrap1);
			} else {
				if (element.attr('type')=='file') {
					error.insertAfter(element.next());
				} else {
					error.insertAfter(element);
				}
			}
		},
		errorClass: 'help-block',
		rules: {
			account: {
				required: true
			},
			password: {
				required: true,
				minlength: 5
			},
			confirm_password: {
				required : true,
				equalTo :'#reg-password'
			}
		},
		messages: {
			password: {
				required: "请输入密码",
				minlength: "输入至少需要5位"
			},
			account: "请输入账号",
			confirm_password : {
				required : '请输入确认密码',
				equalTo:'两次输入密码不一致'
			}
		},
		highlight: function(element) {
			if ($(element).offsetParent().parent().hasClass('form-group')) {
				$(element).offsetParent().parent().removeClass('has-success').addClass('has-error');
			} else {
				if ($(element).attr('type')=='file') {
					$(element).parent().parent().removeClass('has-success').addClass('has-error');
				}
				$(element).offsetParent().parent().parent().parent().removeClass('has-success').addClass('has-error');

			}
		},
		unhighlight: function(element,errorClass) {
			if ($(element).offsetParent().parent().hasClass('form-group')) {
				$(element).offsetParent().parent().removeClass('has-error').addClass('has-success');
				$(element.form).find("label[for=" + element.id + "]").removeClass(errorClass);
			} else if ($(element).offsetParent().parent().hasClass('checkbox')) {
				$(element).offsetParent().parent().parent().parent().removeClass('has-error').addClass('has-success');
				$(element.form).find("label[for=" + element.id + "]").removeClass(errorClass);
			} else if ($(element).next().hasClass('bootstrap-filestyle')) {
				$(element).parent().parent().removeClass('has-error').addClass('has-success');
			}
			else {
				$(element).offsetParent().parent().parent().removeClass('has-error').addClass('has-success');
			}
		},
		submitHandler:function(form){
			$(form).ajaxSubmit({
				type:'post',
				url:$(form).attr('action'),
				dataType:'json',
				success: function(res){
					if (res.code == 200) {
						layer.msg(res.message, {icon : 1, time : 2000}, function(){
							window.location.reload()
						})
					} else {
						layer.msg('失败', {icon : 3});
					}
				}
			});
		}
	});

});