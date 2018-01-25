local _M = {
    _VERSION = '0.01',
    table_name = 'blog_comment',
    pk = 'comment_id'
}

function _M.search(self, condition, offset, limit)
    self:where(condition)
    local count, err = self:count()
    self:limit(offset, limit)
    local res = self:findAll()
    return {count = count, data = res}
end

function _M.detail(self, id)
    return self:where({comment_id = id}):find()
end

function _M.add(self, data)
    if data == nil then
        return false, '请填写数据'
    end
    data.create_time = func.datetime()
    return self:insert(self.table_name, data)
end


function _M.edit(self, data)
    if data[self.pk] == nil then
        return nil, '请选择评论'
    end
    self:where(self.pk, '=', data[self.pk])
    return self:update(self.table_name)
end

function _M.remove(self, id)
    return self:where({comment_id = id}):delete()
end


func.extends_model(_M)

return _M