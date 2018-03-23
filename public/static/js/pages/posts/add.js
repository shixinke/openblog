requirejs.config({
    baseUrl: "/static/js/libs/editor.md/lib/",
    paths: {
        jquery          : "../../jquery/1.12.3/jquery.min",
        marked          : "marked.min",
        prettify        : "prettify.min",
        raphael         : "raphael.min",
        underscore      : "underscore.min",
        flowchart       : "flowchart.min",
        jqueryflowchart : "jquery.flowchart.min",
        sequenceDiagram : "sequence-diagram.min",
        katex           : "katex.min",
        editormd        : '../editormd.amd.min',
        'jquery.form'   : '../../jquery.form/3.51/jquery.form.min',
        'jquery.validate':'../../jquery.validate/1.15.1/jquery.validate.min',
        'layer':'../../layer/2.4/layer',
        'laydate':'../../laydate/5.0.7/laydate',
        'selectInput'  :'../../jquery.selectinput/1.0.0/jquery.selectInput'
    },
    waitSeconds: 30
});

var deps = [
    "jquery",
    "editormd",
    //"../languages/en",
    "../plugins/link-dialog/link-dialog",
    "../plugins/reference-link-dialog/reference-link-dialog",
    "../plugins/image-dialog/image-dialog",
    "../plugins/code-block-dialog/code-block-dialog",
    "../plugins/table-dialog/table-dialog",
    "../plugins/emoji-dialog/emoji-dialog",
    "../plugins/goto-line-dialog/goto-line-dialog",
    "../plugins/help-dialog/help-dialog",
    "../plugins/html-entities-dialog/html-entities-dialog",
    "../plugins/preformatted-text-dialog/preformatted-text-dialog"
];

var editor;

require(deps, function($, editormd) {


    // if enable codeFold
    // or <link rel="stylesheet" href="../lib/codemirror/addon/fold/foldgutter.css" />
    editormd.loadCSS("./lib/codemirror/addon/fold/foldgutter");

    var mdContent = $('#md-content');
    var markdownContent = '';
    if (mdContent.length > 0) {
        markdownContent = mdContent.val();
    }

    editor = editormd("posts-content", {
        width: "100%",
        height: 640,
        path : '/static/js/libs/editor.md/lib/',
        markdown : markdownContent,
        codeFold : true,
        searchReplace : true,
        saveHTMLToTextarea : true,                // 保存HTML到Textarea
        htmlDecode : "style,script,iframe|on*",       // 开启HTML标签解析，为了安全性，默认不开启
        emoji : true,
        taskList : true,
        tex : true,
        tocm            : true,         // Using [TOCM]
        autoLoadModules : false,
        previewCodeHighlight : true,
        flowChart : true,
        sequenceDiagram : true,
        //dialogLockScreen : false,   // 设置弹出层对话框不锁屏，全局通用，默认为true
        //dialogShowMask : false,     // 设置弹出层对话框显示透明遮罩层，全局通用，默认为true
        //dialogDraggable : false,    // 设置弹出层对话框不可拖动，全局通用，默认为true
        //dialogMaskOpacity : 0.4,    // 设置透明遮罩层的透明度，全局通用，默认值为0.1
        //dialogMaskBgColor : "#000", // 设置透明遮罩层的背景颜色，全局通用，默认为#fff
        imageUpload : true,
        imageFormats : ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
        imageUploadURL : "./php/upload.php",
        onload : function() {
            console.log('onload', this);
            //this.fullscreen();
            //this.unwatch();
            //this.watch().fullscreen();

            //this.setMarkdown("#PHP");
            //this.width("100%");
            //this.height(480);
            //this.resize("100%", 640);
        }
    });

    var datepicker = function(selector, options){
        var selector = selector || '.date-picker';
        var options = options || {};
        options.type = options.type || 'datetime';
        require(['laydate'], function(laydate){
            laydate.path = '/static/js/libs/laydate/5.0.7/';
            laydate.render({
                elem: selector,
                type:options.type
            });
        });

    };

    require(['selectInput'], function(){
        var obj = $('#select-tags');
        var data = obj.data();
        var options = {
            serverUrl : data.url,
            addLayerTitle:'请选择标签'
        }
        obj.selectInput(options);
    });

    /*
    options.clearBtn.on('click', function(){
        options.inputSelectHidden.val("");
        options.inputSelectText.val("");
        options.inputSelectWrapper.removeClass('active');
    });
    */

    datepicker('#create-time');

    require(['jquery.validate', 'jquery.form', 'layer'], function(validate, jqueryForm, layer){
        $('#posts-form').validate({
            errorPlacement: function(error, element) {
                var $label = $( element ).closest( "form" ).find( "div[for='" + element.attr( "id" ) + "']" );
                $label.append(error).show();
            },
            submitHandler: function(form){
                $(form).ajaxSubmit({
                    dataType:'json',
                    success:function(res){
                        var res = res || {}
                        if (res.code == 200) {
                            res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作成功';
                            layer.alert(res.message, {shade:[0, 'transparent'], icon:1}, function(){
                                 window.location.href = res.data.url;
                            });
                        } else {
                            res.message = typeof res.message != 'undefined' && res.message != '' ? res.message : '操作失败';
                            res.data = res.data || {};
                            layer.alert(res.message, {shade:[0, 'transparent'], icon:5}, function(index){
                                if (typeof res.data.url != 'undefined' && res.data.url != '') {
                                    window.location.href = res.data.url;
                                }
                                else {
                                    layer.close(index);
                                }
                            });
                        }
                    },
                    error:function(){
                        layer.msg("网络不稳定，请稍候重试", {icon : 5});
                    }
                });
            }
        });
    })

});