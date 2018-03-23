local _M = {
    _VERSION = '0.01'
}

local posts = require 'service.posts'
local pagination = require 'system.pagination'

function _M.init(self)
    --self.withoutLayout = true
end

function _M.index(self)
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
    local datalist = posts.homepage(page, pagesize)
    local page_obj = pagination.new({page = page, pagesize = pagesize, total = datalist.total})
    self:assign('datalist', datalist)
    self:assign('pages', page_obj:show())
    self:display()
end


return _M