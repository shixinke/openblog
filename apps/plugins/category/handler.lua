local _M = {_VERSION = '0.01' }
local category = require 'models.category':new()


function _M.data()
    local data = category:lists()
    local datalist
    if data then
        datalist = {}
        for _, v in pairs(data) do
            v.url = v.alias ~= '' and '/category-'..v.alias..config.routes.url_suffix or '/category-'..v.category_name..config.routes.url_suffix
            if v.parent_id == 0 then
                if datalist[v.category_id] and datalist[v.category_id].children then
                    local children = datalist[v.category_id].children
                    datalist[v.category_id] = v
                    datalist[v.category_id].children = children
                else
                    datalist[v.category_id] = v
                end
            else
                if datalist[v.parent_id] == nil then
                    datalist[v.parent_id] = {}
                end
                if datalist[v.parent_id].children == nil then
                    datalist[v.parent_id].children = {}
                end
                datalist[v.parent_id]['children'][#datalist[v.parent_id]['children']+1] = v
            end
        end
    end
    return datalist
end

function _M.html(config)
    local str = '<dl class="plugin_box" id="plugin_'..config.html_id..'">\n<dt>'..config.module_name..'</dt><dd class="plugin_content"><ul>';
    local data = _M.data()
    for _, v in pairs(data) do
        str = str..'<li class="li-category"><a href="'..v.url..'">'..v.category_name..'('..v.total..')</a>'
        if v.children then
            str = str..'<ul class="ul-subcategory">';
            for _, val in pairs(v.children) do
                str = str..'<li class="li-subcategory"><a href="'..val.url..'">'..val.category_name..'('..val.total..')</a></li>';
            end
            str = str..'</ul>'
        end
        str = str..'</li>'
    end
    str = str..'</ul></dd></dl>'
    return str
end

return _M