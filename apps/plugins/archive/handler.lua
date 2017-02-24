local _M = {_VERSION = '0.01' }
local posts = require 'models.posts':new()
local substr = string.sub

function _M.data()
    local data = posts:archive()
    if data then
        for i, v in pairs(data) do
            local tmp = tostring(v.archive)
            local year = substr(tmp, 0, 4)
            local month = substr(tmp, -2)
            data[i].url = '/date-'..year..'-'..month..config.routes.url_suffix
            data[i].title = year..'年'..month..'月';
        end
    end
    return data
end

function _M.html(config)
    local str = '<dl class="plugin_box" id="plugin_'..config.html_id..'">\n<dt>'..config.module_name..'</dt><dd class="plugin_content"><ul>';
    local data = _M.data()
    for _, v in pairs(data) do
        str = str..'<li><a href="'..v.url..'">'..v.title..'('..v.total..')</a></li>'
    end
    str = str..'</ul></dd></dl>'
    return str
end

return _M