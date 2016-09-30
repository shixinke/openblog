local _M = {
    _VERSION = '0.01'
}

local session = require 'resty.session'

function _M.init(self)
    self.layout = 'admin/layouts/layout.html'
end

function _M.index(self)
    local sess = session.open()
    --ngx.say(func.table_length(sess.data))
    --ngx.say(sess.data.uid)
    self:display()
end

function _M.detail(self)

end

return _M