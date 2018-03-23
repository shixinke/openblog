local _M = {_VERSION = '0.01' }
local tag = require 'service.tag'


function _M.data()
    return tag.taglist(30)
end

return _M