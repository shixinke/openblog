local _M = {_VERSION = '0.01' }
local nav = require 'service.nav'


function _M.data()
    local datalist = nav:menulist()
    return datalist
end

return _M