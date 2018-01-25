local _M = {
    _VERSION = '0.01',
    table_name = 'blog_link',
    pk = 'link_id'
}

function _M.search(self, condition, offset, limit)
    self:where(condition)
    local count, err = self:count()
    self:limit(offset, limit)
    local res = self:findAll()
    return {count = count, data = res}
end

function _M.lists(self, limit)
    local limit = limit and tonumber(limit) or 15
    self:where({status = 1, display = 1})
    self:order('sort', 'DESC')
    self:limit(limit)
    return self:findAll()
end

function _M.detail(self, id)
    return self:where({link_id = id}):find()
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
        return nil, '请选择友情链接信息'
    end
    self:where(self.pk, '=', data[self.pk])
    return self:update(self.table_name)
end

function _M.remove(self, id)
    return self:where({id = id}):delete()
end


func.extends_model(_M)

return _M