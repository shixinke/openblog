local _M = {
    _VERSION = '0.01'
}

function _M.index(self)
    ngx.say('search page')
    local key = self:get('key')
    ngx.say(key)
end


return _M