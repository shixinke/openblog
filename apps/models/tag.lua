local _M = {
    _VERSION = '0.01',
    table_name = 'blog_tag',
    pk = 'tag_id'
}

function _M.search(self, condition, offset, limit)
    self:where(condition)
    local count, err = self:count()
    self:limit(offset, limit)
    local res = self:findAll()
    return {count = count, data = res}
end

function _M.lists(self, num)
    local num = num and tonumber(num) or 0
    if num > 0 then
        self:where('items', '>=', num)
    end
    self:where({status = 1, display = 1})
    self:order('sort', 'DESC')
    return self:findAll()
end

function _M.detail(self, id)
    return self:where({tag_id = id}):find()
end

function _M.add(self, data)
    if data == nil or type(data) ~= 'table' then
        return false, '请填写数据'
    end
    data.create_time = func.datetime()
    data.status = 1
    ngx.log(ngx.ERR, cjson.encode(data))
    return self:insert(self.table_name, data)
end

function _M.edit(self, data)
    if data == nil then
        return false, '请填写数据'
    end
    if not data.tag_id then
        return nil, '请选择要删除的标签'
    end

    return self:where({tag_id = data.tag_id}):update(self.table_name, data)
end

function _M.save(self, tags)
    local data = {}
    for _, tag in pairs(tags) do
        local res = self:where({tag_name = tag}):find()
        if res and res.tag_id then
            data[#data+1] = res.tag_id
            self:where({tag_id = res.tag_id}):incr('items', 1)
        else
            local res = self:add({tag_name = tag, items = 1})
            if res then
                data[#data+1] = res
            end
        end
    end
end

function _M.remove(self, id)
    return self:where({tag_id = id}):delete()
end


func.extends_model(_M)

return _M