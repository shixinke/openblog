local _M = {_VERSION = '0.01' }
local config = require 'models.config':new()

local groups = {
    SITE = '基础设置',
    GLOBAL = "全局设置",
    PAGE = "页面设置",
    AUTHOR = "博主设置",
    FUNC = "功能设置"
}

local dataTypes = {
    STRING = "字符串",
    NUMBER = "数字型",
    JSON = "JSON类型",
    BOOLEAN = '布尔型'
}


function _M.search(condition, offset, limit)
    return config:search(condition, offset, limit)
end

function _M.lists(group)
    local datalist = config:lists(group)
    local tab = {}
    if datalist then
        for _, v in pairs(datalist) do
            tab[v.key] = v
        end
    end
    return tab
end

function _M.grouplist()
    return groups
end

function _M.dataTypes()
    return dataTypes
end

function _M.detail(id)
    return config:detail(id)
end

function _M.add(data)
    return config:add(data)
end

function _M.update(data)
    local res = config:edit(data)
    if res then
        _M.reset_item(data.key)
    end
    return res
end

function _M.delete(configId)
    return config:remove(configId)
end

function _M.save(data)
    local tab = {}
    local keys = {}
    for k, v in pairs(data) do
        local val = v.value
        if v.datatype == 'JSON' then
            val = cjson.encode(v.value)
        elseif v.datatype == 'BOOLEAN' and func.is_empty_str(val) then
            val = '0'
        end
        tab[k] = val
        keys[#keys + 1] = k
    end
    local res =  config:save(tab)
    if res then
        _M.reset_items(keys)
    end
    return res
end

function _M.item(key)
    local val = func.dict_get(key, true)
    if val then
        return config.parse_value(val)
    end
    return _M.reset_item(key)
end

function _M.items(keys)
    if type(keys) ~= 'table' then
        return nil, 'the params must be a table'
    end
    local tab = {}
    local uncached = {}
    for _, v in pairs(keys) do
        local val = func.dict_get(v, true)
        if not val then
            uncached[#uncached + 1] = v
        else
            tab[v] = config.parse_value(val)
        end
    end

    if #uncached > 0 then
        local values = _M.reset_items(uncached)
        if values then
            for i, v in pairs(values) do
                tab[i] = v.value
            end
        end
    end
    return tab
end

function _M.reset_item(key)
    local val = config:item(key)
    if val then
        func.dict_set(key, val)
        return val.value
    end
    return val
end

function _M.reset_items(keys)
    local items = config:items(keys)
    if items then
        for k, v in pairs(items) do
            func.dict_set(k, v)
        end
    end
    return items
end

return _M