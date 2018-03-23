local _M = {
    _VERSION = '0.01',
    table_name = 'blog_node',
    pk = 'id'
}

function _M.lists(self, status)
    if status ~= nil then
        self:where({status = status})
        self:where({display = 1})
    end
    self:order('parent_id', 'ASC')
    self:order('weight', 'DESC')
    return self:findAll()
end

function _M.menulist(self)
    return self:where({status = 1, parent_id = 0}):order('weight', 'DESC'):findAll()
end

function _M.detail(self, id)
    return self:where({id = id}):find()
end

function _M.add(self, data)
    if data == nil or type(data) ~= 'table' then
        return false, '请填写菜单数据'
    end

    return self:insert(self.table_name, data)
end

function _M.edit(self, data)
    if data == nil then
        return false, '请填写菜单数据'
    end
    if not data.id then
        return nil, '请选择要修改的菜单'
    end

    return self:where({id = data.id}):update(self.table_name, data)
end

function _M.remove(self, id)
    return self:where({id = id}):delete()
end


func.extends_model(_M)

return _M