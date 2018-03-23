local _M = {_VERSION = '0.01' }
local comment = require 'models.comment':new()
local user = require 'service.user'

function _M.search(condition, page, pagesize)
    local tab = func.page_util(page, pagesize)
    local datalist = comment:search(condition, tab.offset, tab.limit)
    if datalist.list then
        local values = datalist.list
        local userlists = user.lists()
        for i, v in pairs(values) do
            for _, u in pairs(userlists) do
                if u.uid == v.uid then
                    values[i].avatar = u.avatar
                end
            end
        end

        datalist.list = func.array_camel_style(values)
    end
    return datalist
end

function _M.lists(limit)
    local datalist = comment:lists(limit)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end


function _M.detail(id)
    local data = comment:detail(id)
    if data then
        data = func.table_camel_style(data)
    end
    return data
end

function _M.add(data)
    return comment:add(data)
end

function _M.update(data)
    return comment:edit(data)
end

function _M.delete(commentId)
    return comment:remove(commentId)
end

return _M