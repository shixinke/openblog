local _M = {_VERSION = '0.01' }
local link = require 'models.link':new()


function _M.data(limit)
    return link:lists(limit)
end

function _M.html(config)
    local str = '<dl class="plugin_box" id="plugin_'..config.html_id..'">\n<dt>'..config.module_name..'</dt><dd class="plugin_content"><ul class="tags-box">';
    local data = _M.data(config.meta.limit)
    for _, v in pairs(data) do
        if config.meta.display == 1 then
            str = str..'<li class="li-tag"><a href="'..v.url..'">'..v.link_name..'</a></li>'
        else
            str = str..'<li class="li-tag"><a href="'..v.url..'"><img src="'..v.logo..'" title="'..v.link_name..'"></a></li>'
        end
    end
    str = str..'</ul></dd></dl>'
    return str
end

return _M