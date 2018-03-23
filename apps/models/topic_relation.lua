local _M = {
    _VERSION = '0.01',
    table_name = 'blog_topic_relation'
}



function _M.add(self, data)
    if data == nil then
        return false, '请填写数据'
    end

    return self:insert(self.table_name, data)
end

function _M.add_posts(self, topic_id, posts_ids)
    local datalist = {}
    if type(posts_ids) == 'table' then
        for _, posts_id in pairs(posts_ids) do
            datalist[#datalist+1] = {topic_id = topic_id, posts_id = posts_id}
        end
        ngx.log(ngx.ERR, cjson.encode(datalist))
        return self:insertAll(self.table_name, datalist)
    else
        return self:insert(self.table_name, {topic_id = topic_id, posts_id = posts_ids})
    end
end


function _M.remove_posts(self, topic_id, posts_id)
    if not posts_id and not topic_id then
        return nil, '请选择文章或专题'
    end
    if posts_id then
        if type(posts_id) == 'table' then
            self:where('posts_id', 'IN', posts_id)
        else
            self:where({posts_id = posts_id})
        end
    end
    if topic_id then
        self:where({topic_id = topic_id})
    end
    return self:delete()
end


func.extends_model(_M)

return _M