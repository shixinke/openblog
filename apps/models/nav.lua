local _M = {
    _VERSION = '0.01',
    table_name = 'blog_nav',
    pk = 'nav_id'
}

function _M.lists(self, display)
    if display then
        self:where({display = display})
    end
    self:order('weight', 'DESC')
    return self:findAll()
end

function _M.detail(self, id)
    return self:where({nav_id = id}):find()
end

function _M.add(self, data)
    if data == nil then
        return false
    end
    data.create_time = func.datetime()
    return self:insert(self.table_name, data)
end


function _M.edit(self, data)
    if data[self.pk] == nil then
        return nil, '请选择导航'
    end
    self:where(self.pk, '=', data[self.pk])
    return self:update(self.table_name, data)
end

function _M.remove(self, id)
    return self:where({nav_id = id}):delete()
end


func.extends_model(_M)

return _M