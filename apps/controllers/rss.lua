local _M = {
    _VERSION = '0.01'
}

local atom = require 'resty.feed.atom'


function _M.init(self)
end

function _M.index(self)
    local feed = atom.new()
    ngx.say(feed:create())
end

return _M
