local _M = {
    _VERSION = '0.01',
    table_name = 'blog_topic',
    pk = 'topic_id'
}

function _M.search(self, condition, offset, limit)

end


function _M.detail(self, id)
    return self:where({topic_id = id}):find()
end

function _M.add(self, data)
    if data == nil or type(data) ~= 'table' then
        return false, '请填写数据'
    end
    data.create_time = func.datetime()
    return self:insert(self.table_name, data)
end

function _M.edit(self, data)
    if data == nil then
        return false, '请填写数据'
    end
    if not data.topic_id then
        return nil, '请选择要修改的专题'
    end

    return self:where({topic_id = data.topic_id}):update(self.table_name, data)
end

function _M.remove(self, id)
    return self:where({topic_id = id}):delete()
end


func.extends_model(_M)

return _M