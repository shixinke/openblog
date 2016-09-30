local _M = {
    _VERSION = '0.01'
}

function _M.new()

end

function _M.init(self)
    self.withLayout = true
end

function _M.index(self)
    ngx.say('admin test')
end

function _M.detail(self)
    ngx.say('admin test detail')
end

return _M