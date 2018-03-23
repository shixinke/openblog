/* jQuery iFrame Tabs Plugin
 *  Version: 1.0.0
 *  Author: shixinke
 *  website:http://github.com/ishixinke/iframetabs
 *  Contact: ishixinke@qq.com
 *  */
;
$.fn.iframeTabs = function (options) {
    var options = options || {};
    var tabs = new iframeTabs(options, this);
    tabs.init();
    return tabs;
};
function iframeTabs(options, wrapper) {
    this.options = $.extend({
        defaultTab:{},
        tabHead:'tab-head-wrapper',
        tabContent:'tab-content-wrapper',
        prevBtn:true,
        prevBtnIcon:'iconfont icon-forward',
        nextBtn:true,
        nextBtnIcon:'iconfont icon-backward',
        dropdownMenu:true,
        dropdownIcon:'iconfont icon-sidebar',
        store:true

    }, options || {});
    var template = {
        tabs:tabTemplate(this.options),
        navTab:'<a href="javascript:;" class="menu-tab-item" data-id="{{id}}" data-url="{{url}}">{{label}}</a>',
        navTabWidthClose:'<a href="javascript:;" class="menu-tab-item" data-id="{{id}}" data-url="{{url}}">{{label}} <i class="iconfont icon-close-with-bg close-tab-item"></i></a>',
        iframe:'<iframe class="tab-iframe-item" data-id="{{id}}" src="{{url}}" width="100%" height="100%" frameborder="0"></iframe>'
    };
    this.template = template;
    this.wrapper = $(wrapper);
    return this;
}

function eventHandler($selector, event, childSelector, fn)
{
    $selector.off(event, childSelector, fn).on(event, childSelector, fn);
}

function sumWidth(objList) {
    var width = 0;
    $(objList).each(function () {
        width += $(this).outerWidth(true)
    });
    return width;
};

function tabTemplate(options)
{
    var options = options || {};
    var html = '<div id="tab-head-wrapper" class="'+options.tabHead+'">'+
                   '<div class="content-tabs">';
    if (options.prevBtn) {
        html +=        '<button class="roll-nav roll-left tab-prev-btn"><i class="'+options.prevBtnIcon+'"></i> </button>';
    }
    if (options.nextBtn) {
        html +=        '<button class="roll-nav roll-right tab-next-btn"><i class="'+options.nextBtnIcon+'"></i> </button>';
    }
    html +=            '<nav class="page-tabs page-menu-tabs">'+
                           '<div class="page-tabs-content" style="margin-left: 0px;">'+
                           '</div>'+
                       '</nav>';
    if (options.dropdownMenu) {
        html +=        '<div class="btn-group roll-nav roll-right tab-more-btn-group">'+
                           '<button class="dropdown tab-more" data-toggle="dropdown" aria-expanded="true"><i class="'+options.dropdownIcon+'"></i><span class="caret"></span></button>'+
                           '<ul role="menu" class="dropdown-menu dropdown-menu-right">'+
                               '<li class="close-all-tabs"><a>关闭全部选项卡</a></li>'+
                               '<li class="close-other-tabs"><a>关闭其他选项卡</a></li>'+
                           '</ul>'+
                        '</div>';
    }
    html +=         '</div>'+
                '</div>'+
                '<div id="tab-content-wrapper" class="'+options.tabContent+'"></div>';
    return html;
}

iframeTabs.prototype.init = function(){
    var self = this;
    var initialize = self.wrapper.data('init');
    if (initialize != 1) {
        self.wrapper.html(self.template.tabs).attr('data-init', 1);
    }
    var element = {
        wrapper:self.wrapper,
        tabHead:self.wrapper.find('#tab-head-wrapper'),
        navTabsWrapper:self.wrapper.find('.page-tabs:first'),
        navTabs:self.wrapper.find('.page-tabs:first>.page-tabs-content:first'),
        prevBtn:self.wrapper.find('.content-tabs .tab-prev-btn:first'),
        nextBtn:self.wrapper.find('.content-tabs .tab-next-btn:first'),
        dropdownBtnGroup:self.wrapper.find('.content-tabs .tab-more-btn-group'),
        tabContent:self.wrapper.find('#tab-content-wrapper')
    };
    this.element = element;
    if (initialize != 1) {
        var cache = self.initTabList();
        if (!cache) {
            self.element.tabHead.append(self.template.tabHead);
            if (self.options.defaultTab && self.options.defaultTab.id) {
                self.add(self.options.defaultTab);
            }
        }
    }

    self.bindEvent();
};

iframeTabs.prototype.setItem = function(key, value, index){
    var self = this;
    var json = false;
    if (typeof value == 'object') {
        json = true;
    }
    if (!window.sessionStorage) {
        return false;
    }
    if (json) {
        var data = self.getItem(key, json);
        data = data || {};
        if (index) {
            data[index] = value;
        } else {
            data = value;
        }
        data = JSON.stringify(data);
        window.sessionStorage.setItem(key, data);
    } else {
        window.sessionStorage.setItem(key, value);
    }
}

iframeTabs.prototype.getItem = function(key, json) {
    if (!window.sessionStorage) {
        return false;
    }
    var data = window.sessionStorage.getItem(key);
    return json ? JSON.parse(data) : data;
};

iframeTabs.prototype.delItem = function(key, index) {
    var self = this;
    if (!window.sessionStorage) {
        return false;
    }
    if (key) {
        if (index) {
            var tabList = self.getItem('open_tab_list', true);
            if (tabList && tabList[index]) {
                delete tabList[index];
                self.setItem('open_tab_list', tabList);
            }
        } else {
            return window.sessionStorage.removeItem(key);
        }
    } else {
        return window.sessionStorage.clear();
    }
};

function inArray(ele, arr) {
    for (var i=0; i< arr.length; i++) {
        if (ele == arr[i]) {
            return true;
        }
    }
    return false;
}

iframeTabs.prototype.remainItem = function(id){
    var self = this;
    if (!window.sessionStorage) {
        return false;
    }
    if (id) {
        var tabList = self.getItem('open_tab_list', true);
        for (var i in tabList) {
            var index = i.replace("i", "")
            if (!inArray(index, id)) {
                delete tabList[i];
            }
        }
        self.setItem('open_tab_list', tabList);
    }
};

iframeTabs.prototype.bindEvent = function(){
    var self = this;
    eventHandler(self.element.dropdownBtnGroup, 'click', '.close-all-tabs', function(){
        self.clear();
    });

    eventHandler(self.element.dropdownBtnGroup, 'click', '.close-other-tabs', function(){
        self.closeOtherTabs();
    });

    eventHandler(self.element.navTabs, 'click', 'a', function(){
        self.setActiveTab($(this));
    });

    eventHandler(self.element.navTabs, 'click', 'a i', function(){
        self.closeTab($(this).closest('a'));
        return false;
    });

    eventHandler(self.element.tabHead, 'click', '.tab-prev-btn', function(){
        self.moveLeft();
        return false;
    });

    eventHandler(self.element.tabHead, 'click', '.tab-next-btn', function(){
        self.moveRight();
        return false;
    });


};

iframeTabs.prototype.add = function (options) {
    var self = this;
    var options = options || {};
    if (!options.id) {
        return false;
    }
    var existsTab = self.getTabById(options.id);
    if (existsTab) {
        self.setActiveTab(existsTab);
        return existsTab;
    }
    var length = self.element.navTabs.find('a').length;
    var withCloseBtn = length == 0 ? false : true;
    var $currentTab = $(getNavTabHtml(self, options, withCloseBtn));
    $currentTab.appendTo(self.element.navTabs);
    var iframeBox = self.getIframeById(options.id);
    if (iframeBox) {
        self.setActiveTab($currentTab);
        return false;
    }
    $(getIframeHtml(self, options)).appendTo(self.element.tabContent);
    self.setActiveTab($currentTab);
    if (self.options.store) {
        self.setItem('open_tab_list', options, 'i'+options.id);
        self.setItem('active_tab', options.id);
    }
    return $currentTab;
};

iframeTabs.prototype.initTabList = function(){
    var self = this;
    var openTabList = self.getItem('open_tab_list', true);
    var activeId = self.getItem('active_tab', false);
    var headHtml = '', iframeHtml = '';
    if (openTabList && activeId) {
        for (var idx in openTabList) {
            var withCloseBtn = self.options.defaultTab.id == openTabList[idx].id ? false : true;
            headHtml += getNavTabHtml(self, openTabList[idx], withCloseBtn);
            iframeHtml += getIframeHtml(self, openTabList[idx]);
        }
        self.element.navTabs.html(headHtml);
        self.element.tabContent.html(iframeHtml);
        self.setActiveTab(self.element.navTabs.find('a[data-id='+activeId+']'));
        return true;
    }
    return false;
};

function getNavTabHtml(wrapper, options, withCloseBtn)
{
    var html;
    if (withCloseBtn) {
        html = wrapper.template.navTabWidthClose.replace('{{id}}', options.id).replace('{{url}}', options.url).replace('{{label}}', options.label);
    } else {
        html = wrapper.template.navTab.replace('{{id}}', options.id).replace('{{url}}', options.url).replace('{{label}}', options.label);
    }
    return html;
}

function getIframeHtml(wrapper, options)
{
    return wrapper.template.iframe.replace('{{id}}', options.id).replace('{{url}}', options.url).replace('{{label}}', options.label);
}


iframeTabs.prototype.setActiveTab = function(obj){
    var self = this;
    if (obj.hasClass('active')) {
        return false;
    }
    var id = obj.data('id');
    obj.addClass('active').siblings().removeClass('active');
    self.element.tabContent.find('iframe').each(function(){
        if ($(this).data('id') == id) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
    self.setItem('active_tab', id);
};

iframeTabs.prototype.getTabById = function(id){
    var self = this;
    var tab;
    self.element.navTabs.find('a').each(function(){
        var current = $(this);
        if ($(this).data('id') == id) {
            tab = current;
        }
    });
    return tab;
};

iframeTabs.prototype.getIframeById = function(id) {
    var self = this;
    var iframe;
    self.element.tabContent.find('iframe').each(function(){
        var current = $(this);
        if ($(this).data('id') == id) {
            iframe = current;
        }
    });
    return iframe;
};

iframeTabs.prototype.closeTab = function(obj, index){
    var self = this;
    var isActive = obj.hasClass('active');

    if (isActive) {
        var prevTab = obj.prev('a:last');
        var nextTab = obj.next('a:first');
        if (nextTab.size()) {
            self.setActiveTab(nextTab)
            self.setItem('active_tab', nextTab.data('id'));
        } else {
            self.setActiveTab(prevTab);
            self.setItem('active_tab', prevTab.data('id'));
        }
    }
    self.delItem('open_tab_list', 'i'+obj.data('id'));
    obj.remove();
    self.element.tabContent.find('iframe[data-id='+obj.data('id')+']').remove();
};

iframeTabs.prototype.closeOtherTabs = function(){
    var self = this;
    var arr = [];
    arr.push(self.element.tabHead.find('.page-tabs a').eq(0).data('id'));
    var activeTabId = self.getItem('active_tab');
    if (activeTabId != arr[0]) {
        arr.push(activeTabId);
    }
    self.remainItem(arr);
    self.element.tabHead.find('.page-tabs a:gt(0)').not('.active').remove();
    self.element.tabContent.find('iframe:gt(0)').not(':visible').remove();
};

iframeTabs.prototype.clear = function () {
    var self = this;
    var arr = [];
    arr.push(self.element.tabHead.find('.page-tabs a').eq(0).data('id'));
    self.remainItem(arr);
    self.element.tabHead.find('.page-tabs a').eq(0).show().addClass('active').siblings().remove();
    self.element.tabContent.find('iframe').eq(0).show().siblings().remove();
}

iframeTabs.prototype.moveLeft = function () {
    var self = this, element = self.element,
        navTabsMarginLeft = Math.abs(parseInt(element.navTabs.css("margin-left"))),
        tabsWrapperWidth = element.navTabsWrapper.outerWidth(true),
        sumTabsWidth = sumWidth(element.navTabs.children('a')),
        leftWidth = 0, marginLeft = 0, navTab;
    if (sumTabsWidth < tabsWrapperWidth) {
        return self
    } else {
        navTab = element.navTabs.children('a:first');
        while ((marginLeft + navTab.width()) <= navTabsMarginLeft) {
            marginLeft += navTab.outerWidth(true);
            navTab = navTab.next();
        }
        marginLeft = 0;
        if (sumWidth(navTab.prevAll()) > tabsWrapperWidth) {
            while (( (marginLeft + navTab.width()) < tabsWrapperWidth) && navTab.length > 0) {
                marginLeft += navTab.outerWidth(true);
                navTab = navTab.prev();
            }
            leftWidth = sumWidth(navTab.prevAll());
        }
    }
    self.element.navTabs.animate({marginLeft : 0 - leftWidth + "px"}, "fast");
    return self;
}

iframeTabs.prototype.moveRight = function () {
    var self = this, element = self.element,
        navTabsMarginLeft = Math.abs(parseInt(element.navTabs.css("margin-left"))),
        tabsWrapperWidth = element.navTabsWrapper.outerWidth(true),
        sumTabsWidth = sumWidth(element.navTabs.children('a')),
        leftWidth = 0, marginLeft = 0, navTab;
    if (sumTabsWidth < tabsWrapperWidth) {
        return self;
    } else {
        navTab = element.navTabs.children('a:first');
        marginLeft = 0;
        while ((marginLeft + navTab.width()) <= navTabsMarginLeft) {
            marginLeft += navTab.outerWidth(true);
            navTab = navTab.next();
        }
        marginLeft = 0;
        while (( (marginLeft + navTab.width()) < tabsWrapperWidth) && navTab.length > 0) {
            marginLeft += navTab.outerWidth(true);
            navTab = navTab.next();
        }
        leftWidth = sumWidth(navTab.prevAll());
        if (leftWidth > 0) {
            element.navTabs.animate({marginLeft : 0 - leftWidth + "px"}, "fast");
        }
    }
    return self;
}

