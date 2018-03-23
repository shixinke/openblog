local _M = {_VERSION = '0.01' }
local module = require 'models.module':new()

function _M.lists(status)
    local datalist = module:lists(status)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.lists_by_hooks()
    local datalist = module:lists()
    local tab = {}
    if datalist then
        datalist = func.array_camel_style(datalist)
        local hooks = config.hooks
        for i, v in pairs(datalist) do
            if not tab[v.hook] then
                tab[v.hook] = hooks[v.hook]
                tab[v.hook]['items'] = {}
            end
            datalist[i]['hookInfo'] = hooks[v.hook]
            if v.status == 1 then
                tab[v.hook]['items'][#tab[v.hook]['items'] + 1] = v
            end
        end
    end
    return {items = datalist, hooks = tab}
end

function _M.detail(id)
    local data = module:detail(id)
    if data then
        data = func.table_camel_style(data)
    end
    return data
end

function _M.add(data)
    return module:add(data)
end

function _M.update(data)
    return module:edit(data)
end

function _M.delete(moduleId)
    return module:remove(moduleId)
end

return _M