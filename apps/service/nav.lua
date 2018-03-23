local _M = {_VERSION = '0.01' }
local nav = require 'models.nav':new()
local cache_key = 'navlist'

function _M.search(condition)
    return nav:where(condition):order('weight', 'DESC'):findAll()
end

function _M.lists(display)
    local datalist = nav:lists(display)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.menulist()
    local datalist = func.dict_get(cache_key, true)
    if not datalist or #datalist < 1 then
        datalist = _M.lists(1)
        if datalist then
            func.dict_set(cache_key, datalist)
        end
    end
    return datalist
end

function _M.detail(id)
    local data = nav:detail(id)
    if data then
        data = func.table_camel_style(data)
    end
    return data
end

function _M.add(data)
    return nav:add(data)
end

function _M.update(data)
    return nav:edit(data)
end

function _M.delete(navId)
    return nav:remove(navId)
end

return _M