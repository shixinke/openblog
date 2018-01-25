local _M = {
    _VERSION = '0.01',
    table_name = 'blog_comment'
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

    return self:insert(self.table_name, data)
end

function _M.add_tags(self, posts_id, tag_ids)
    local datalist = {}
    for _, tag_id in pairs(tag_ids) do
        datalist[#datalist+1] = {tag_id = tag_id, posts_id = posts_id}
    end
    return self:insertAll(self.table_name, datalist)
end


function _M.remove(self, posts_id, tag_id)
    if not posts_id and not tag_id then
        return nil, '请选择文章或标签'
    end
    if posts_id then
        self:where({posts_id = posts_id})
    end
    if tag_id then
        self:where({tag_id = tag_id})
    end
    return self:delete()
end


func.extends_model(_M)

return _M