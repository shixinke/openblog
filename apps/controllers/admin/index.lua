local _M = {
    _VERSION = '0.01'
}

local node = require 'service.node'

function _M.init(self)
    self.withoutLayout = true
    self:check_login()
end

function _M.index(self)
    local menuList = node.tree()
    self:assign('title', '管理后台控制台')
    self:assign('userInfo', self:get_login_info())
    self:assign('menuList', menuList)
    self:display()
end

return _M