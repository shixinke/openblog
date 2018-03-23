local _M = {
    _VERSION = '0.01'
}

local topic = require 'service.topic'
local posts_service = require 'service.posts'
local htmlutils = require 'resty.htmlutils.htmlutils'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end


function _M.datalist(self)
    local params = {}
    local gets = self:get()
    if func.is_empty_str(gets.topicId) then
        self.json(5003, '请选择专题')
    end
    local ok, topicId = pcall(tonumber, gets.topicId)
    if not ok then
        self.json(5003, '请选择合法的专题')
    end

    local items = posts_service.topic(topicId)
    if items then
        self.json(200, '获取成功', {total = #items, list = items})
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    local params = {}
    posts = posts and posts or {}
    if not posts.postsId then
        self.json(5003, "请选择文章")
    end

    if not posts.topicId then
        self.json(5003, "请选择专题")
    end
    params.topic_id = posts.topicId
    params.posts_id = cjson.decode(posts.postsId)
    return params
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = topic.add_posts(posts.topic_id, posts.posts_id)
        if info then
            self.json(200, '添加成功', {url = '/admin/topic/detail?id='..posts.topic_id})
        else
            self.json(5003, "添加失败")
        end
    else
        self.json(5003, "非法操作");
    end
end


function _M.delete(self)
    local id = self:post('id')
    local topic_id = self:post('topicId')
    local get_id = self:get('topicId')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的文章')
    end
    local ok, postsId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的文章")
    end
    if func.is_empty_str(topic_id) then
        if func.is_empty_str(get_id) then
            self.json(5005, '请选择专题')
        else
            topic_id = get_id
        end
    end
    local ok, topicId = pcall(tonumber, topic_id)
    if not ok then
        self.json(5008, "请选择合法的专题")
    end

    local status, err = topic.remove_posts(topicId, postsId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/topic/detail?id='..topicId})
    end
end

return _M