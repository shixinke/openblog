local _M = {
    _VERSION = '0.01',
    table_name = 'blog_config',
    pk = 'key'
}

function _M.search(self, condition, offset, limit)
    self:where(condition)
    local count, err = self:count()
    self:limit(offset, limit)
    local res = self:findAll()
    return {count = count, data = res}
end

function _M.lists(self, group)
    self:where({group = group})
    return self:findAll()
end

function _M.item(self, key)
    local res = self:where({key = key}):find()
    if res and res.key then
        local val
        if res.datatype == 'STRING' then
            val = tostring(res.value)
        elseif res.datatype == 'NUMBER' then
            val = tonumber(res.value)
        elseif res.datatype == 'JSON' then
            val = cjson.decode(res.value)
        end
        return val
    else
        return false, '该账号不存在'..self.sql
    end
end

function _M.items(self, keys)
    local res,data
    if keys then
        res = self:where('key', 'IN', keys):findAll()
    else
        res = self:findAll()
    end
    if res and type(res) == 'table' then
        data = {}
        for _, v in pairs(res) do
            local val
            if v.datatype == 'STRING' then
                val = tostring(v.value)
            elseif v.datatype == 'NUMBER' then
                val = tonumber(v.value)
            elseif v.datatype == 'JSON' then
                val = cjson.decode(v.value)
            end
            data[v.key] = val
        end
    end
    return data
end

function _M.detail(self, key)
    return self:where({key = key}):find()
end

function _M.add(self, data)
    if data == nil then
        return false
    end
    return self:insert(self.table_name, data)
end

function _M.edit(self, data)
    if data[self.pk] == nil then
        return nil, '请填写配置键'
    end
    self:where(self.pk, '=', data[self.pk])
    return self:update(self.table_name)
end

function _M.save(self, data)
    local res
    for k, v in pairs(data) do
        res = self:where({key = k}):update(self.table_name, {value = v})
        if res then
            func.set_item(k, v)
        end
    end
    return res
end

function _M.remove(self, key)
    return self:where({key = key}):delete()
end


func.extends_model(_M)

return _M