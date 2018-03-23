local _M = {
    _VERSION = '0.01',
    table_name = 'blog_posts',
    pk = 'posts_id'
}

local tonumber = tonumber
local ngx_null = ngx.null

function _M.search(self, condition, offset, limit)
    self:where(condition)
    local count, err = self:count()
    self:limit(offset, limit)
    local res = self:findAll()
    return {total = count, list = res}
end

function _M.total(self)
    return self:where({type = 1}):count()
end

function _M.views(self)
    local sql = 'SELECT SUM(views) AS views FROM '..self:get_table_name()
    local result, err = self:query(sql)
    if result and result[1] and result[1]['views'] and result[1]['views'] ~= ngx_null  then
        return tonumber(result[1]['views'])
    else
        return 0
    end
end

function _M.detail(self, id)
    return self:where({posts_id = id}):find()
end

function _M.add(self, data)
    if data == nil then
        return false, '请填写数据'
    end
    return self:insert(self.table_name, data)
end


function _M.edit(self, data)
    if data[self.pk] == nil then
        return nil, '请选择评论'
    end
    self:where(self.pk, '=', data[self.pk])
    return self:update(self.table_name, data)
end

function _M.remove(self, id)
    return self:where({posts_id = id}):delete()
end

function _M.archive(self)
    local sql = 'SELECT DATE_FORMAT(create_time, "%Y%m") AS archive,count(*) AS total FROM '..self.table_name..' GROUP BY archive ORDER BY archive DESC'
    local data = self:query(sql)
    return data
end

function _M.topic(self, topicId)
    local sql = 'SELECT * FROM '..self.table_name..' AS p JOIN blog_topic_relation AS r ON p.posts_id = r.posts_id WHERE topic_id = '..topicId
    local data = self:query(sql)
    return data
end


func.extends_model(_M)

return _M