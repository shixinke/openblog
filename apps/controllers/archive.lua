local _M = {
    _VERSION = '0.01'
}

local posts = require 'service.posts'
local pagination = require 'system.pagination'



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
    local info, err
    self:display()
end

return _M