/*! jquery-transfer 选择组件 License LGPL  http://github.com/shixinke/jquery-input-select By 诗心客 version:1.0 */
(function($){
    function inArrObject(value, arr) {
        for (var i =0; i< arr.length; i++) {
            if (arr[i] && (value == arr[i].value)) {
                return i;
            }
        }
        return false;
    }
    function SelectInput(selector, options) {
        this.selector = selector;
        this.options = options;
        this.$element = {};
        var values = [];
        this.options.multiple = selector.attr('multiple') == 'multiple' ? true : false;
        this.selector.children().each(function(){
            if ($(this).attr('selected') == 'selected') {
                values.push({value : $(this).val(), text : $(this).text()});
            }
        });
        this.$element.container = selector.parent();
        this.values = values;
    }
    SelectInput.prototype.init = function(){
        var html = '';
        for (var i =0; i< this.values.length; i++) {
            if (this.values[i]) {
                html += this.add(this.values[i].value, this.values[i].text, true);
            }
        }
        this.options.name = this.selector.attr('name');
        var template = $.fn.selectInput.defaults.template.
            replace(/\{\{iconPrefix}}/g, this.options.iconPrefix).
            replace('{{iconPlus}}', this.options.iconPlus);
        var $tpl = $(template);
        $tpl.find('.select-input-items').append(html);
        this.$element.container.html($tpl.prop('outerHTML'));
        this.$element.itemListBox = this.$element.container.find('.select-input-items');
        this.$element.hidden = $('#select-input-hidden');
        return this;
    };
    SelectInput.prototype.add = function(val, text, init){
        var html = this.options.itemTpl.replace(/\{\{value\}\}/g, val).
            replace(/\{\{name\}\}/g, this.options.name).
            replace(/\{\{text\}\}/g, text).
            replace(/\{\{iconPrefix}}/g, this.options.iconPrefix).
            replace(/\{\{iconItem}}/g, this.options.iconItem).
            replace(/\{\{iconClose}}/g, this.options.iconClose);
        if (init) {
            return html;
        } else {
            if (inArrObject(value, this.values) !== false) {
                return false;
            }
            this.values.push({value : value, text : text});
            if (this.options.multiple) {
                this.$element.itemListBox.append(html);
            } else {
                this.$element.itemListBox.html(html);
            }

        }
    };

    SelectInput.prototype.batchAdd = function(mapList){
        var html = '';
        var arr = new Array();
        if (!this.options.multiple) {
            var tmp = mapList.shift();
            arr.push(tmp);
        } else {
            arr = mapList;
        }
        for (var i=0; i<arr.length; i++) {
            if (inArrObject(arr[i].value, this.values) !== false) {
                continue;
            }
            html += this.add(arr[i].value, arr[i].text, true);
            this.values.push({value : arr[i].value, text : arr[i].text});
        }
        if (this.options.multiple) {
            this.$element.itemListBox.append(html);
        } else {
            this.$element.itemListBox.html(html);
        }

    };

    SelectInput.prototype.remove = function(value){
        var i = inArrObject(value, this.values);
        if (i !== false) {
            this.$element.itemListBox.find('.input-item[data-value='+value+']').remove();
            delete this.values[i];
        }
    };
    $.fn.selectInput = function(options) {
        var settings = $.extend({}, $.fn.selectInput.defaults, options);
        var _this;
        return this.each(function(){
            _this = $(this);
            var selectInput = new SelectInput(_this, settings);
            selectInput.init();
            selectInput.$element.container.on('click', '.remove', function(){
                var $parent = $(this).parent('.input-item');
                selectInput.remove($parent.data('value'));
            });
            var index = 0;
            selectInput.$element.container.on('click', '.input-btn-add', function(){
                index = layer.open({
                    type:2,
                    content:settings.serverUrl,
                    title:settings.addLayerTitle,
                    btn:['确定'],
                    area:[settings.addLayerWidth+"px", settings.addLayerHeight+"px"],
                    yes:function(index, wrapper){
                        var body = layer.getChildFrame('body', index);


                        var arr = new Array();
                        var $checkedItems;
                        if (settings.multiple) {
                            $checkedItems = body.find('tbody :checkbox:checked');
                        } else {
                            $checkedItems = body.find('tbody :radio:checked');
                        }

                        $checkedItems.each(function(){
                            console.log($(this).val())
                            var $parent = $(this).parents('tr');
                            var obj = {};
                            obj.text = $parent.find('td:eq('+settings.rowIndex+')').text();
                            obj.value = $(this).val();
                            arr.push(obj);
                        });

                        selectInput.batchAdd(arr);
                        layer.close(index);
                    }
                });
            });



        });
    };
    $.fn.selectInput.defaults = {
        'template':
            '<div class="select-input-wrapper">\
                 <div class="select-input-items">\
                 </div>\
                 <a href="javascript:;" class="input-btn-add" title="添加"><i class="{{iconPrefix}} {{iconPlus}}"></i></a>\
            </div>',
        'itemTpl':'<label class="input-item" data-text="{{text}}" data-value="{{value}}">\
                       <input type="hidden" name="{{name}}" value="{{value}}">\
                       <span class="input-item-text">\
                           <i class="{{iconPrefix}} {{iconItem}}"></i> {{text}}\
                       </span>\
                       <div class="remove">\
                           <span class="remove-item-btn">\
                               <i class="{{iconPrefix}} {{iconClose}}"></i>\
                           </span>\
                       </div>\
                   </label>',
        'iconPrefix':'iconfont',
        'iconItem':'icon-tag',
        'rowIndex':1,
        'iconPlus':'icon-plus',
        'iconClose':'icon-close-circle',
        'serverUrl':'',
        'addLayerTitle':'选择',
        'addLayerWidth':800,
        'addLayerHeight':600,
        'confirmBtn':'.confirm-btn'
    };
})(jQuery);