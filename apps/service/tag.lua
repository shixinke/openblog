local _M = {_VERSION = '0.01' }
local tag = require 'models.tag':new()

function _M.search(params)
    local resp = {total = 0, list = {}}
    if params.tagName then
        tag:where("tag_name", "LIKE", params.tagName)
    end
    if params.tagAlias then
        tag:where("tag_alias", "LIKE", params.tagAlias)
    end
    if params.status then
        tag:where({status = params.status})
    end
    if params.display then
        tag:where({display = params.display})
    end
    resp.total = tag:count()
    resp.count = count
    tag.remains = true
    resp.list = tag:order('weight', 'DESC'):findAll()
    if resp.list then
        resp.list = func.array_camel_style(resp.list)
    end
    return resp

end

function _M.lists()

end

function _M.taglist(limit)
    tag:where({status = 1, display = 1})
    if limit then
        tag:limit(limit)
    end
    local datalist =  tag:order('weight', 'DESC'):findAll()
    if datalist then
        for i, v in pairs(datalist) do
            datalist[i].url = '/tags-'..v.tag_alias..'.html'
        end
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.get_tags(tag_ids)
    return tag:where('tag_id', 'IN', tag_ids):findAll()
end

function _M.get_by_alias(alias)
    return tag:where({tag_alias = alias}):find()
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

function _M.detail(id)
    return _M.detail(id)
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