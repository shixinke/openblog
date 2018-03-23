local _M = {_VERSION = '0.01' }
local role = require 'models.role':new()
local tostring = tostring
local table_sort = table.sort

function _M.search(condition, page, pagesize)
    local resp = {
        list = {},
        total = 0
    }
    local tab = func.page_util(page, pagesize)
    local datalist =  role:where(condition):order('weight', 'DESC'):limit(tab.offset, tab.limit):findAll()
    if datalist then
        resp.list = func.array_camel_style(datalist)
        resp.count = role:where(condition):count()
    end
    return resp
end

function _M.lists()
    local datalist =  role:where({status = 1}):order('weight', 'DESC'):findAll()
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end


function _M.add(data)
    return role:add(data)
end

function _M.update(data)
    return role:edit(data)
end

function _M.detail(id)
    local info =  role:detail(id)
    if info then
        info = func.table_camel_style(info)
    end
    return info
end

function _M.delete(id)
    return role:remove(id)
end

return _M