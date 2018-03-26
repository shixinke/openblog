requirejs.config({
    baseUrl: '/static/js',
    paths: {
        'jquery':'libs/jquery/1.12.3/jquery.min',
        'fn':'common/fn',
        'utils':'common/utils',
        'jquery.cookie':'libs/jquery.cookie/1.4.1/jquery.cookie',
        'jquery.form':'libs/jquery.form/3.51/jquery.form.min',
        'jquery.validate':'libs/jquery.validate/1.15.1/jquery.validate.min',
        'jquery.md5':'libs/jquery.md5/jquery.md5',
        'jquery.slimscroll':'libs/jquery.slimscroll/1.3.8/jquery.slimscroll.min',
        'jquery.iframetabs':'libs/jquery.iframetabs/1.0.0/jquery.iframetabs',
        'jquery.chosen':'libs/jquery.chosen/1.7.0/jquery.chosen',
        'jquery.jstree':'libs/jquery.jstree/3.3.4/jstree.min',
        'jquery.fancybox':'libs/jquery.fancybox/2.1.7/jquery.fancybox.pack',
        'bootstrap.table':'libs/bootstrap.table/1.11.1/bootstrap-table.min',
        'bootstrap.table.cn':'libs/bootstrap.table/1.11.1/locale/bootstrap-table-zh-CN.min',
        'layer':'libs/layer/2.4/layer',
        'laydate':'libs/laydate/5.0.7/laydate',
        'bootstrap':'libs/bootstrap/3.0.3/bootstrap.min',
        'pager':'libs/pager/0.5/bootstrap-paginator',
        'treetable':'libs/treetable/3.2.0/treetable',
        'jquery.dragsort':'libs/jquery.dragsort/0.5.2/jquery.dragsort',
        'sortable':'libs/sortable/1.6.0/Sortable.min',
        'jquery.sortable':'libs/jquery.sortable/0.9.13/jquery.sortable',
        'webuploader':'libs/webuploader/0.1.5/webuploader.min',
        'echarts':'libs/echarts/3.6.2/echarts.min',
        'echarts.theme':'libs/echarts/3.6.2/theme',
        'selectpage':'libs/selectpage/2.6.0/selectpage.min',
        'jquery.transfer':'libs/jquery.transfer/1.0.0/jquery.transfer',
        'jquery.selectInput':'libs/jquery.selectinput/1.0.0/jquery.selectInput',
        'jquery.xpassword':'libs/jquery.xpassword/1.0.0/jquery.xpassword',
        'marked'        : 'libs/editor.md/lib/marked.min',
        'prettify'        : 'libs/editor.md/lib/prettify.min',
        'raphael'         : 'libs/editor.md/lib/raphael.min',
        'underscore'      : 'libs/editor.md/lib/underscore.min',
        'flowchart'       : 'libs/editor.md/lib/flowchart.min',
        'jqueryflowchart' : 'libs/editor.md/lib/jquery.flowchart.min',
        'sequenceDiagram' : 'libs/editor.md/lib/sequence-diagram.min',
        'katex'           : 'libs/editor.md/lib/katex.min',
        'editor.md':'libs/editor.md/editormd.amd.min',
        'link-dialog':'libs/editor.md/plugins/link-dialog/link-dialog',
        'reference-link-dialog':'libs/editor.md/plugins/reference-link-dialog/reference-link-dialog',
        'image-dialog':'libs/editor.md/plugins/image-dialog/image-dialog',
        'code-block-dialog':'libs/editor.md/plugins/code-block-dialog/code-block-dialog',
        'table-dialog':'libs/editor.md/plugins/table-dialog/table-dialog',
        'emoji-dialog':'libs/editor.md/plugins/emoji-dialog/emoji-dialog',
        'goto-line-dialog':'libs/editor.md/plugins/goto-line-dialog/goto-line-dialog',
        'help-dialog':'libs/editor.md/plugins/help-dialog/help-dialog',
        'html-entities-dialog':'libs/editor.md/plugins/html-entities-dialog/html-entities-dialog',
        'preformatted-text-dialog':'libs/editor.md/plugins/preformatted-text-dialog/preformatted-text-dialog'
    },
    shim:{
        'bootstrap':['jquery'],
        'bootstrap.table':['jquery', 'bootstrap'],
        'bootstrap.table.cn':['jquery', 'bootstrap', 'bootstrap.table'],
        'jquery.iframetabs':['jquery'],
        'jquery.jstree':['jquery'],
        'jquery.dragsort':['jquery'],
        'jquery.sortable':['jquery'],
        'jquery.fancybox':['jquery'],
        'treetable':['jquery'],
        'echarts.theme':['echarts'],
        'jquery.chosen':['jquery'],
        'jquery.form':['jquery'],
        'jquery.validate':['jquery'],
        'jquery.cookie':['jquery'],
        'jquery.md5':['jquery'],
        'jquery.slimscroll':['jquery'],
        'layer':['jquery'],
        'ueditor':['ueditor.config'],
        'ueditor.lang.cn':['ueditor'],
        'selectpage':['jquery', 'bootstrap'],
        'jquery.transfer':['jquery'],
        'jquery.selectInput':['jquery'],
        'jquery.insertContent':['jquery'],
        'jquery.xpassword':['jquery']
    }
});