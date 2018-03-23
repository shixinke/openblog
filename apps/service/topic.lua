local _M = {_VERSION = '0.01' }
local topic = require 'models.topic':new()
local relation = require 'models.topic_relation':new()

function _M.search(params)
    local resp = {total = 0, list = {}}
    if params.topicName then
        topic:where("topic_name", "LIKE", params.topicName)
    end
    if params.topicAlias then
        topic:where("topic_alias", "LIKE", params.topicAlias)
    end
    if params.display then
        topic:where({display = params.display})
    end
    resp.total = topic:count()
    resp.count = count
    topic.remains = true
    resp.list = topic:order('weight', 'DESC'):findAll()
    if resp.list then
        resp.list = func.array_camel_style(resp.list)
    end
    return resp

end

local function format_datalist(datalist)
    if datalist then
        for i, v in pairs(datalist) do
            datalist[i] = func.table_camel_style(datalist[i])
            datalist[i].url = '/topic/'..v.topic_alias
            if config.routes.url_suffix then
                datalist[i].url = datalist[i].url..config.routes.url_suffix
            end
        end
    end
    return datalist
end

function _M.topiclist()
    local datalist =  topic:where({display = 1}):order('weight', 'DESC'):findAll()
    return format_datalist(datalist)
end

function _M.get_by_alias(alias)
    local info = topic:where({display = 1, topic_alias = alias}):find()
    if info then
        info = func.table_camel_style(info)
    end
    return info
end

function _M.lists()

end

function _M.add(data)
    local id, err =  topic:add(data)
    if id then
        return id
    else
        return nil, err
    end
end

function _M.detail(id)
    local info = topic:detail(id)
    if info then
        info = func.table_camel_style(info)
    end
    return info
end

function _M.update(data)
    return topic:edit(data)
end

function _M.delete(topicId)
    local info = topic:fields({'posts'}):where({topic_id = topicId}):find()
    if not info then
        return nil, '该专题不存在'
    end
    if info.posts > 0 then
        return nil, '该专题下面有文章，不能删除'
    end
    return topic:where({topic_id = topicId}):delete()
end

function _M.add_posts(topic_id, posts_id)
    return relation:add_posts(topic_id, posts_id)
end

function _M.remove_posts(topic_id, posts_id)
    return relation:remove_posts(topic_id, posts_id)
end

return _M