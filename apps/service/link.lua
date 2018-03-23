local _M = {_VERSION = '0.01' }
local link = require 'models.link':new()

function _M.search(condition, page, pagesize)
    local tab = func.page_util(page, pagesize)
    local datalist = link:search(condition, tab.offset, tab.limit)
    if datalist.list then
        datalist.list = func.array_camel_style(datalist.list)
    end
    return datalist
end

function _M.lists(limit)
    local datalist = link:lists(limit)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.detail(id)
    local data = link:detail(id)
    if data then
        data = func.table_camel_style(data)
    end
    return data
end

function _M.add(data)
    return link:add(data)
end

function _M.update(data)
    return link:edit(data)
end

function _M.delete(linkId)
    return link:remove(linkId)
end

return _M