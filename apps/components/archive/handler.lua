local _M = {_VERSION = '0.01' }
local posts = require 'service.posts'


function _M.data()
    return posts.archive()
end

return _M