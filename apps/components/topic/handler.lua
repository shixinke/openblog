local _M = {_VERSION = '0.01' }
local topic = require 'service.topic'

function _M.data()
    return topic.topiclist()
end

return _M