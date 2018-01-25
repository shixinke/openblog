local _M = {
    _VERSION = '0.01'
}

function _M.new()

end

function _M.index(self)
    self:display()
end

function _M.detail(self)
    self:display()
end

function _M.lists(self)
    ngx.say('bybyb')
end

return _M