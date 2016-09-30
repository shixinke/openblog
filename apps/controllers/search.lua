local _M = {
    _VERSION = '0.01'
}

function _M.new()

end

function _M.index(self)
    local key = self:get('key')
    ngx.say(key)
end

function _M.hello(self)

end

function _M.lists(self)
    ngx.say('bybyb')
end

return _M