/*! jquery-xpassword 密码组件 License LGPL  http://github.com/shixinke/xpassword By 诗心客 version:1.0 */
(function($){
    function inArrObject(value, arr) {
        for (var i =0; i< arr.length; i++) {
            if (arr[i] && (value == arr[i].value)) {
                return i;
            }
        }
        return false;
    }
    function XPassword(selector, options) {
        this.selector = selector;
        this.options = options;
        this.initStatus = false;
        this.$element = {};
        this.$element.container = selector.parent();
        console.log(selector)
    }
    XPassword.prototype.init = function(){
        this.initStatus = true;
        if (!this.options.strength) {
            this.options.strengthTpl = '';
        }
        var id = this.selector.attr('id');
        var template = $.fn.xPassword.defaults.template.
        replace(/\{\{iconPrefix}}/g, this.options.iconPrefix).
        replace('{{iconOpenEye}}', this.options.iconOpenEye).
        replace('{{placeholder}}', this.options.placeholder).
        replace('{{forId}}', id).
        replace('{{strengthTpl}}', this.options.strengthTpl);
        var $tpl = $(template);
        this.selector.addClass('x-password-password');
        $tpl.find('.input-password-wrapper').prepend(this.selector);
        this.$element.container.html($tpl.prop('outerHTML'));
        this.$element.inputWrapper = this.$element.container.find('.input-password-wrapper');
        this.$element.inputPassword = this.$element.container.find('input[type=password]');
        this.$element.inputText = this.$element.container.find('.x-password-text');
        this.$element.strengthBox = this.$element.container.find('.password-strength-fill');
        this.$element.visibleBtn = this.$element.container.find('.password-eye');
        return this;
    };

    XPassword.prototype.showStrength = function(){
        if (!this.initStatus) {
            this.init();
        }
        var value = this.$element.inputPassword.val();
        if (this.options.strength) {
            if (value.length < 6) {
                this.$element.strengthBox.attr('data-strength', "");
                return;
            }
            var level = 0;
            var title = this.options.level0Text;
            if (this.options.pattern.level4.test(value)) {
                level = 4;
                title = this.options.level4Text;
            } else if (this.options.pattern.level3.test(value)) {
                level = 3;
                title = this.options.level3Text;
            } else if (this.options.pattern.level2.test(value)) {
                level = 2;
                title = this.options.level2Text;
            }  else if (this.options.pattern.level1.test(value)) {
                level = 1;
                title = this.options.level1Text;
            } else if(this.options.pattern.level0.test(value) || this.options.pattern.level01.test(value)) {
                level = 0;
                title = this.options.level0Text;
            } else {
                level = "";
                title = "";
            }
            this.$element.strengthBox.attr('data-strength', level).attr('title', title);
            return true;
        }
    };

    XPassword.prototype.toggleVisible = function(item){
        var visible;
        var icon;
        if (!item) {
            item = this.$element.visibleBtn;
        }
        visible = item.attr('data-visible');
        icon = item.find('i');
        if( visible == "1" ){
            item.attr("data-visible", 0);
            icon.removeClass('icon-close-eye').addClass('icon-open-eye');
            this.$element.inputPassword.val(this.$element.inputText.val()).show();
            this.$element.inputText.hide();
            return;
        } else {
            item.attr("data-visible", 1);
            icon.removeClass('icon-open-eye').addClass('icon-close-eye');
            this.$element.inputText.val(this.$element.inputPassword.val()).show();
            this.$element.inputPassword.hide();
            return;
        }
    };

    $.fn.xPassword = function(options) {
        var settings = $.extend({}, $.fn.xPassword.defaults, options);
        var _this;
        return this.each(function(){
            _this = $(this);
            var xPasswordObj = new XPassword(_this, settings);
            xPasswordObj.init();
            xPasswordObj.$element.inputPassword.on('keyup', function(){
                xPasswordObj.showStrength();
            });
            xPasswordObj.$element.visibleBtn.on('click', function(){
                xPasswordObj.toggleVisible($(this));
            });
        });
    };
    $.fn.xPassword.defaults = {
        'template':
            '<div class="x-password-wrapper">\
                 <div class="input-password-wrapper">\
                     <input type="text" class="x-password-text" placeholder="{{placeholder}}"/>\
                     <a href="javascript:;" class="password-eye" title="显示"><i class="{{iconPrefix}} {{iconOpenEye}}"></i></a>\
                 </div>\
                 <div class="help-block" for="{{forId}}"></div>\
                 {{strengthTpl}}\
            </div>',
        'strengthTpl':'<div class="password-strength">'+
                           '<div class="password-strength-fill">'+
                           '</div>',
        'strength':false,
        'pattern':{
            level0:/^[a-zA-Z]{6,}$/,
            level01:/^[0-9]{6,}$/,
            level1:/^(?=.*?[a-z])(?=.*?[0-9]).{7,}$/,
            level2:/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{10,}$/,
            level3:/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{7,}$/,
            level4:/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{10,}$/
        },
        'iconPrefix':'iconfont',
        'iconOpenEye':'icon-open-eye',
        'iconCloseEye':'icon-close-eye',
        'level0Text':'弱',
        'level1Text':'中',
        'level2Text':'强',
        'level3Text':'较强',
        'level4Text':'超强',
        'placeholder':'请输入密码'
    };
})(jQuery);