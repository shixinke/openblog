local _M = {
    _VERSION = '0.01',
    table_name = 'blog_role',
    pk = 'role_id'
}

function _M.lists(self, status)
    if status ~= nil then
        self:where({status = status})
    end
    self:order('weight', 'DESC')
    return self:findAll()
end


function _M.detail(self, id)
    return self:where({role_id = id}):find()
end

function _M.add(self, data)
    if data == nil or type(data) ~= 'table' then
        return false, '请填写角色数据'
    end
    data.create_time = func.datetime()
    return self:insert(self.table_name, data)
end

function _M.edit(self, data)
    if data == nil then
        return false, '请填写角色数据'
    end
    if not data.id then
        return nil, '请选择要修改的角色'
    end

    return self:where({role_id = data.id}):update(self.table_name, data)
end

function _M.remove(self, id)
    return self:where({role_id = id}):delete()
end


func.extends_model(_M)

return _M