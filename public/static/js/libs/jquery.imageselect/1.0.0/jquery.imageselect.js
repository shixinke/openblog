/*! jquery-transfer 图片选择器组件 License LGPL  http://github.com/shixinke/jquery-image-select By 诗心客 version:1.0 */
(function($){
    function inArray(ele, arr, key) {
        for (var i = 0; i< arr.length; i++) {
            if (ele == arr[i][key]) {
                return true;
            }
        }
        return false;
    }
    function ImageSelect(selector, options) {
        this.selector = selector;
        this.options = options;
        this.imgItemList = [];
    }
    ImageSelect.prototype.init = function(){
        if (this.options.select.substr(0, 1) == '#') {
            var $source = $(this.options.select);
        } else {
            var $source = this.selector.find(this.options.select);
        }
        if ($source.length < 0) {
            throw new Error('the source selector not found');
            return false;
        }
        this.options.formName = $source.attr('name');
        var self = this;
        $source.find('option').each(function(){
            var obj = {};
            obj.value = $(this).val();
            obj.text = $(this).text();
            if ($(this).attr('selected') == 'selected') {
                self.imgItemList.push(obj);
            }
        });

    };
    ImageSelect.prototype.addItem = function($imageSelect, item, isReturn){
        if (!inArray(item.value, $imageSelect.imgItemList, 'value')) {
            var html = $imageSelect.settings.itemTpl.replace(/\{\{url\}\}/g, item.value).
            replace(/\{\{title\}\}/g, item.text).
            replace(/\{\{iconPrefix}}/g, $imageSelect.settings.iconPrefix).
            replace(/\{\{iconClose}}/g, $imageSelect.settings.iconClose).
            replace(/\{\{itemImgName}}/g, $imageSelect.settings.itemImgName).
            replace(/\{\{itemTitleName}}/g, $imageSelect.settings.itemTitleName);
            $imageSelect.imgItemList.push(item);
            if (isReturn) {
                $imageSelect.$fileList.append(html);
            } else {
                return html;
            }
        }
    };
    ImageSelect.prototype.addItems = function($imageSelect, items){
        var html = '';
        for (var i=0; i< items.length; i++) {
            var exists = this.addItem($imageSelect, items[i], true);
            if (exists) {
                html += exists;
            }
        }
        $imageSelect.$fileList.append(html);
    };
    ImageSelect.prototype.removeItem = function($imageSelect, item, itemSelector){
        for (var i=0; i< $imageSelect.imgItemList.length; i++) {
            if ($imageSelect.imgItemList[i].value == item.value) {
                delete $imageSelect.imgItemList[i];
                itemSelector.remove();
            }
        }
    };
    function toCamelCase(str){
        var strArr=str.split('-');
        for(var i=1;i<strArr.length;i++){
            strArr[i]=strArr[i].charAt(0).toUpperCase()+strArr[i].substring(1);
        }
        return strArr.join('');
    }
    $.fn.imageSelect = function(options) {
        var settings = $.extend({}, $.fn.transfer.defaults, options);
        var _this;
        return this.each(function(){
            _this = $(this);
            var data = $(this).data();
            var dataObj = {};
            for (var ele in data) {
                dataObj[toCamelCase(ele)] = data[ele];
            }
            settings = $.extend(settings, dataObj);
            var imageSelect = new ImageSelect(_this, settings);
            imageSelect.init();
            var display = 'block';
            if (settings.multi == "1" && imageSelect.imgItemList.length > 0) {
                display = "none";
            }
            var template = $.fn.imageSelect.defaults.template.
            replace('{{name}}', imageSelect.options.formName).
            replace(/\{\{iconPrefix}}/g, settings.iconPrefix).
            replace(/\{\{iconAdd}}/g, settings.iconAdd).
            replace(/\{\{display}}/g, display).
            replace(/\{\{iconClose}}/g, settings.iconClose);
            var $html = $(template);
            var sourceHtml = '';
            for (var i=0; i< imageSelect.imgItemList.length; i++) {
                sourceHtml += settings.itemTpl.replace(/\{\{url\}\}/g, imageSelect.imgItemList[i].value).
                replace(/\{\{title\}\}/g, imageSelect.imgItemList[i].text).
                replace(/\{\{iconPrefix}}/g, settings.iconPrefix).
                replace(/\{\{iconClose}}/g, settings.iconClose).
                replace(/\{\{itemImgName}}/g, settings.itemImgName).
                replace(/\{\{itemTitleName}}/g, settings.itemTitleName);
            }

            if (_this.find(settings.source).length == 0) {
                $html.find('.file-list').append(sourceHtml);
                _this.html($html.html());
            }
            _this.settings = settings;
            _this.$hidden = $('#image-select-hidden');
            _this.$fileList = _this.find('.file-list');
            _this.$addBtn = _this.find('.add-item-btn');
            _this.$removeBtn = _this.find('.file-img-delete');
            _this._imgItemList = imageSelect.imgItemList;
            var index = 0;

            _this.$addBtn.click(function(){
                if (!layer) {
                    new Error("must require layer plugin");
                    return false;
                }
                index = layer.open({
                    type:2,
                    content:settings.listUrl+'?multi='+settings.multi,
                    title:settings.dialogTitle,
                    btn:['确定'],
                    area:[settings.dialogWidth+"px", settings.dialogHeight+"px"],
                    yes:function(index, wrapper){
                        var body = layer.getChildFrame('body', index);
                        var $checkedItem = body.find(settings.selectedSelector);
                        var arr = new Array();
                        $checkedItem.each(function(){
                            var obj = {};
                            obj.text = $(this).find(settings.textSelector).text();
                            obj.value = $(this).find(settings.urlSelector).val();
                            arr.push(obj);
                        });
                        imageSelect.addItems(_this, arr);
                        layer.close(index);
                    }
                });
            });
            _this.$removeBtn.click(function(){
                var $parent = $(this).parent('dd');
                var obj = {
                    value : $parent.find(settings.urlSelector).val()
                };
                imageSelect.removeItem(_this, obj, $parent);
            });
            return _this;
        });
    };
    $.fn.imageSelect.defaults = {
        'template':
            '<div class="image-select-box">\
                 <input type="hidden" id="image-select-hidden" name="{{name}}">\
                 <div class="file-img-list" id="upload-file-list">\
                     <ul>\
                         <li class="file-list"></li>\
                         <li class="add-file-btn"><a href="javascript:;" title="添加图片" class="add-upload-btn add-item-btn" style="display:{{display}}"> <i class="{{iconPrefix}} {{iconAdd}}"></i></a></li>\
                     </ul>\
                 </div>\
            </div>',
        'itemTpl':'<dd data-file-id="{{id}}">'+
                      '<a href="javascript:;" class="remove-btn file-img-delete"><i class="{{iconPrefix}} {{iconClose}}"></i></a>'+
                      '<img src="{{url}}" class="file-img-thumb"><input type="hidden" name="{{itemImgName}}" value="{{url}}"><input type="hidden" name="{{itemTitleName}}" value="{{title}}" class="hidden-text">'+
                      '<p class="file-img-title">{{title}}</p>'+
                  '</dd>',
        'source': '.file-list',
        'listUrl':'',
        'addBtn':'.ad-item-btn',
        'removeBtn':'.file-img-delete',
        'itemImgName':'url',
        'itemTitleName':'title',
        'dialogTitle':'选择图片',
        'iconPrefix':'iconfont',
        'iconAdd':'icon-addpic',
        'iconClose':'icon-close-circle',
        'maxSize':0,
        'multi':"1",
        'dialogWidth':800,
        'dialogHeight':600,
        'selectedSelector':'.file-list dd.active',
        'urlSelector':'input[name=url]',
        'textSelector':'input[name=text]'

    }
})(jQuery);