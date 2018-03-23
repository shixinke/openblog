local _M = {_VERSION = '0.01' }
local category = require 'service.category'


function _M.data()
    return category.categorylist(true)
end

return _M