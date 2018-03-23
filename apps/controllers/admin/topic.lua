local _M = {
    _VERSION = '0.01'
}

local topic = require 'service.topic'
local category = require 'service.category'
local htmlutils = require 'resty.htmlutils.htmlutils'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '专题列表')
    self:display()
end

function _M.lists(self)
    local multi = self:get('multi')
    local isMulti = 0
    local ok, multi = pcall(tonumber, multi)
    if ok then
        isMulti = multi
    end
    self:assign('title', '专题列表')
    self:assign('multi', isMulti)
    self:display()
end


function _M.datalist(self)
    local params = {}
    local posts = self:get()
    posts = posts and posts or {}
    if func.is_empty_str(posts.topicName) ~= true  then
        params.topicName = posts.topicName
    end
    if func.is_empty_str(posts.topicAlias) ~= true  then
        params.topicAlias = posts.topicAlias
    end
    if func.is_empty_str(posts.status) ~= true  then
        params.status = tonumber(posts.status)
    end
    if func.is_empty_str(posts.display) ~= true  then
        params.display = tonumber(posts.display)
    end

    local topics = topic.search(params)
    if topics then
        self.json(200, '获取成功', topics)
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.topicName) ~= true  then
        posts.topic_name = posts.topicName
        posts.topicName = nil
    else
        self.json(5001, "请输入专题名称")
    end
    if func.is_empty_str(posts.topicAlias) ~= true  then
        posts.topic_alias = posts.topicAlias
        posts.topicAlias = nil
    else
        self.json(5002, "请输入专题别名")
    end
    posts.markdown = ''
    if func.is_empty_str(posts['topic-content-markdown-doc'])  then
        self.json(5002, "请填写文章内容")
    else
        posts.markdown = posts['topic-content-markdown-doc']
        posts['topic-content-markdown-doc'] = nil
    end

    if func.is_empty_str(posts['topic-content-html-code'])  then
        self.json(5002, "请填写文章内容")
    else
        posts.content = posts['topic-content-html-code']
        posts.summary = htmlutils:sub_html(posts.content, 200)
        posts['topic-content-html-code'] = nil
    end
    if func.is_empty_str(posts.createTime) then
        posts.create_time = func.datetime()
    else
        posts.create_time = posts.createTime
        posts.createTime = nil
    end
    if not posts.display then
        posts.display = 0
    end

    if action == 'edit'  then

        if not posts.topicId then
            self.json(5001, "请选择要编辑的专题")
        end
        local ok, topicId = pcall(tonumber, posts.topicId)
        if topicId and topicId > 0 then
            posts.topic_id = posts.topicId
            posts.topicId = nil
        else
            self.json(5001, "请选择要编辑的专题")
        end

    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = topic.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/topic/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        self:assign('title', '添加专题')
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = topic.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/topic/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的专题"
        else
            local ok, topicId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的专题"
            else
                info = topic.detail(topicId)
                if not info then
                    err = "未查询到相应的专题信息"
                end
            end
        end

        ngx.log(ngx.ERR, cjson.encode(info))

        self:assign('title', '编辑专题')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.detail(self)
    if self:is_post() then
        self.json(5003, "非法操作")
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的专题"
        else
            local ok, topicId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的专题"
            else
                info = topic.detail(topicId)
                if not info then
                    err = "未查询到相应的专题信息"
                end
            end
        end

        local categorylist = category.categorylist()
        self:assign('title', '专题')
        self:assign('info', info)
        self:assign('categoryList', categorylist)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的专题')
    end
    local ok, topicId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的专题")
    end

    local status, err = topic.delete(topicId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/topic/index'})
    end
end

return _M