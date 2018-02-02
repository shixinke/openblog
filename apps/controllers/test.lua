local _M = {
    _VERSION = '0.01'
}

function _M.new()

end

function _M.index(self)
    local key = self:get('key')
    ngx.say(key)
end

function _M.detail(self)
    ngx.say('test detail')
end

return _M