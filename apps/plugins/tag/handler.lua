local _M = {_VERSION = '0.01' }
local tag = require 'models.tag':new()


function _M.data()
    local data = tag:lists(1)
    local datalist
    if data then
        datalist = {}
        for _, v in pairs(data) do
            v.url = v.alias ~= '' and '/tag-'..v.tag_alias..config.routes.url_suffix or '/category-'..v.tag_name..config.routes.url_suffix
            datalist[#datalist+1] = v
        end
    end
    return datalist
end

function _M.html(config)
    local str = '<dl class="plugin_box" id="plugin_'..config.html_id..'">\n<dt>'..config.module_name..'</dt><dd class="plugin_content"><ul class="tags-box">';
    local data = _M.data()
    for _, v in pairs(data) do
        str = str..'<li class="li-tag"><a href="'..v.url..'">'..v.tag_name..'('..v.items..')</a></li>'
    end
    str = str..'</ul></dd></dl>'
    return str
end

return _M