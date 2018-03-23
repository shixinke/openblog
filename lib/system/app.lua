local _M = {
    _VERSION = '0.01'
}

local mt = {
    __index = _M
}

local dispatcher = require 'system.dispatcher'

function  _M.new()
    return setmetatable({
       actions = {
           data = {},
           callback = {}
       }
    }, mt)
end

function _M.init(self)

end

function _M.init_worker(self)

end

function _M.set(self)

end

function _M.rewrite(self)

end

function _M.access(self)

end

function _M.header_filter(self)

end

function _M.body_filter(self)

end

function _M.log() end



function _M.use(tag)

end

function _M.run()
    dispatcher:parse()
end

return _M