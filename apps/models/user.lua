local _M = {
    _VERSION = '0.01',
    table_name = 'blog_user',
    pk = 'uid'
}

function _M.checklogin(self, account, password)
    local res = self:where({account = account}):find()
    if res and res.uid then
        if res.password == password then
            if res.status == 1 then
                return res
            else
                return nil, '该账号已被冻结'
            end
        else
            return nil, '密码错误'
        end
    else
        return false, '该账号不存在'..self.sql
    end
end



function _M.search(self, condition, offset, limit)
    self:where(condition)
    local count, err = self:count()
    self:limit(offset, limit)
    local res = self:findAll()
    return {count = count, data = res}
end

function _M.detail(self, uid)
    return self:where({uid = uid}):find()
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
        return nil, '请选择用户'
    end
    self:where(self.pk, '=', data[self.pk])
    return self:update(self.table_name)
end

function _M.remove(self, uid)
    return self:where({uid = uid}):delete()
end


func.extends_model(_M)

return _M