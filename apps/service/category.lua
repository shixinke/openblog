local _M = {_VERSION = '0.01' }
local category = require 'models.category':new()


function _M.lists(status)
    return category:lists(status)
end

function _M.add(data)
    local id, err =  category:add(data)
    if id then
        data.id = id
        return data
    else
        return nil, err
    end
end

function _M.update(data)
    return category:edit(data)
end

function _M.delete(categoryId)
    local info = category:fields({'items'}):where({category_id = categoryId}):find()
    if not info then
        return nil, '该标签不存在'
    end
    if info.items > 0 then
        return nil, '该标签下面有文章，不能删除'
    end
    return category:where({category_id = categoryId}):delete()
end

return _M