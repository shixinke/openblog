define(['jquery', 'jquery.validate', 'jquery.form', 'layer', 'jquery.md5'], function($, validate, jqform, layer){
    var options = {
        searchResult:$('.search-result'),
        searchInputGroup:$('.input-group'),
        searchInput:$('.input-key'),
        searchBtn:$('.input-group-btn'),
        searchForm:$('form')
    };
    var init = function(){
        searchEvent();
    };

    var searchEvent = function(){
        options.searchResult.width(options.searchInputGroup.innerWidth());
        var searchResult = options.searchResult;
        options.searchForm.on("blur", "input[name=q]", function () {
            searchResult.addClass("hide");
        }).on("focus", "input[name=q]", function () {
            if ($("a", searchResult).size() > 0) {
                searchResult.removeClass("hide");
            }
        }).on("keyup", "input[name=q]", function () {
            searchResult.html('');
            var val = $(this).val();
            var html = new Array();
            if (!window.sessionStorage) {
                return;
            }
            if (val != '') {
                var menuItems = window.sessionStorage.getItem('open_tab_list');
                if(menuItems) {
                    var menuList = JSON.parse(menuItems);
                    $.each(menuList, function(index, value){
                        if (value.label.indexOf(val) > -1 || value.url.indexOf(val) > -1) {
                            html.push('<a data-url="' + value.url + '" data-id="'+value.id+'" href="javascript:;">' + value.label + '</a>');
                            if (html.length >= 100) {
                                return false;
                            }
                        }
                    });
                }
            }
            searchResult.append(html.join(""));
            if (html.length > 0) {
                searchResult.removeClass("hide");
            } else {
                searchResult.addClass("hide");
            }
        });
        //快捷搜索点击事件
        options.searchForm.on('mousedown click', '.search-result a[data-url]', function () {
            if (window.sessionStorage) {
                window.sessionStorage.setItem('active_tab', $(this).data('id'));
            }
            window.location.href = '/';
        });
    };
    return {
        init:init
    }
})