local _M = {
    _VERSION = '0.01'
}

local topic = require 'service.topic'


function _M.init(self)
end

function _M.index(self)
    local datalist = topic.topiclist()
    self:assign('title', '标签云')
    self:assign('datalist', datalist)
    self:display()
end



return _M
