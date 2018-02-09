local _M = {
    _VERSION = '0.01'
}

local iconfont = require 'resty.htmlutils.iconfont'


function _M.init(self)
    self.disabled_view = true
end

function _M.lists(self)
    local icon, err = iconfont:new({file = 'static/fonts/demo_fontclass.html'})
    if not icon then
       self.json(404, '未获取到图标信息')
    end
    local tab, err = icon:parse()
    if tab then
        self.json(200, '获取图标成功', tab)
    else
        self.json(500, '图标信息解析失败')
    end
end


return _M