local _M = {_VERSION = '0.01' }
local tag = require 'models.tag':new()

function _M.search(params)
    if params.name then
        tag:where("tag_name", "LIKE", params.name)
    end
    if params.alias then
        tag:where("tag_alias", "LIKE", params.alias)
    end
    if params.status then
        tag:where({status = params.status})
    end
    if params.display then
        tag:where({display = params.display})
    end
    return tag:findAll()

end

function _M.lists()

end

function _M.query(params)
    if params ~= nil then
        return _M.search(params)
    end
    return _M.lists()
end

function _M.add(data)
    local id, err =  tag:add(data)
    if id then
        data.id = id
        return data
    else
        return nil, err
    end
end

function _M.update(data)
    return tag:edit(data)
end

function _M.delete(tagId)
    local info = tag:fields({'items'}):where({tag_id = tagId}):find()
    if not info then
        return nil, '该标签不存在'
    end
    if info.items > 0 then
        return nil, '该标签下面有文章，不能删除'
    end
    return tag:where({tag_id = tagId}):delete()
end

return _M