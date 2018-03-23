local _M = {
    _VERSION = '0.01'
}

local posts = require 'service.posts'
local pagination = require 'system.pagination'


function _M.detail(self)
    local info, err
    local alias = self:get('alias')
    if not alias or alias == '' then
        err = '所请求的文章不存在'
    else
        info = posts.deep(alias)
        if not info then
            err = "文章不存在"
        end
    end
    self:assign('info', info)
    self:assign('err', err)
    self:display()
end


function _M.tag(self)
    local alias = self:get('alias')
    local page = self:get('page')
    local ok
    if page then
        ok, page = pcall(tonumber, page)
        if not ok then
            page = 1
        end
    else
        page = 1
    end
    local pagesize = 5
    local info, err
    if not alias then
        func.show_404()
    end
    local data = posts.lists_by_tag(alias, page, pagesize)
    if not data then
        func.show_404()
    end
    local page_obj = pagination.new({page = page, pagesize = pagesize, total = data.datalist.total})
    self:assign('datalist', data.datalist)
    self:assign('info', data.info)
    self:assign('pages', page_obj:show())
    self:display()
end

function _M.category(self)
    local alias = self:get('alias')
    local page = self:get('page')
    local ok
    if page then
        ok, page = pcall(tonumber, page)
        if not ok then
            page = 1
        end
    else
        page = 1
    end
    local pagesize = 5
    local info, err
    if not alias then
        func.show_404()
    end
    local data = posts.lists_by_category(alias, page, pagesize)
    if not data then
        func.show_404()
    end
    local page_obj = pagination.new({page = page, pagesize = pagesize, total = data.datalist.total})
    self:assign('datalist', data.datalist)
    self:assign('info', data.info)
    self:assign('pages', page_obj:show())
    self:display()
end

function _M.archive(self)
    local alias = self:get('alias')
    local page = self:get('page')
    local ok
    if page then
        ok, page = pcall(tonumber, page)
        if not ok then
            page = 1
        end
    else
        page = 1
    end
    local pagesize = 5
    local info, err
    if not alias then
        func.show_404()
    end
    local data = posts.lists_by_archive(alias, page, pagesize)
    if not data then
        func.show_404()
    end
    local page_obj = pagination.new({page = page, pagesize = pagesize, total = data.datalist.total})
    self:assign('datalist', data.datalist)
    self:assign('info', data.info)
    self:assign('pages', page_obj:show())
    self:display()
end

function _M.topic(self)
    local alias = self:get('alias')
    local page = self:get('page')
    local ok
    if page then
        ok, page = pcall(tonumber, page)
        if not ok then
            page = 1
        end
    else
        page = 1
    end
    local pagesize = 5
    local info, err
    if not alias then
        func.show_404("所请求专题不存在")
    end
    local data = posts.lists_by_topic(alias, page, pagesize)
    if not data then
        func.show_404("专题不存在")
    end
    local page_obj = pagination.new({page = page, pagesize = pagesize, total = data.datalist.total})
    self:assign('datalist', data.datalist)
    self:assign('info', data.info)
    self:assign('pages', page_obj:show())
    self:display()
end

return _M