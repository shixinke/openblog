local _M = {
    _VERSION = '0.01',
    data = {}
}

local mt = {
    __index = _M
}

function _M.new(opts)
    local data = opts or {}
    return setmetatable({
        data = data
    }, mt)
end

function _M.set(self, key, value)
    self.data[key] = value
end
function _M.get(self, key)
    return self.data[key]
end
function _M.delete(self, key)
    self.data[key] = nil
end
return _M