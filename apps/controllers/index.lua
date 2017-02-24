local _M = {
    _VERSION = '0.01'
}

function _M.init(self)
    --self.withoutLayout = true
end

function _M.index(self)
    self:assign('title', self.config.site_title)
    self:display()
end


return _M