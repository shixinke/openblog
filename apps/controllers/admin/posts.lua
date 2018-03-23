local _M = {
    _VERSION = '0.01'
}

local posts = require 'service.posts'
local category = require 'service.category'
local user = require 'service.user'
local htmlutils = require 'resty.htmlutils.htmlutils'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    local categorylist = category.categorylist()
    self:assign('title', '文章列表')
    self:assign('categoryList', categorylist)
    self:display()
end

function _M.lists(self)
    local url = '/admin/posts/datalist?type=1'
    local topicId = self:get('topicId')
    local multi = self:get('multi')
    if topicId then
        url = url..'&topicId='..topicId
    end
    local isMulti = 1
    if multi and multi == 0 then
        isMulti = 0
    end
    local categorylist = category.categorylist()
    self:assign('title', '文章列表')
    self:assign('categoryList', categorylist)
    self:assign('url', url)
    self:assign('multi', isMulti)
    self:display()
end


function _M.datalist(self)
    local data = self:get()
    local display
    local params = {}

    local page = self:get('page')
    local pagesize = self:get('pageSize')
    local ok, page = pcall(tonumber, page)
    if not ok then
        page = 1
    end
    local ok, pagesize = pcall(tonumber, pagesize)
    if not ok then
        pagesize = 15
    end

    local postss = posts.search(params, page, pagesize)
    if postss then

        self.json(200, '获取成功', postss)
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.title)  then
        self.json(5001, "请输入文章标题")
    end

    if func.is_empty_str(posts.categoryId)  then
        self.json(5001, "请选择文章分类")
    else
        posts.category_id = posts.categoryId
        posts.categoryId = nil
    end
    if posts['posts-content-markdown-doc'] then
        posts.markdown = posts['posts-content-markdown-doc']
        posts['posts-content-markdown-doc'] = nil
    end

    if func.is_empty_str(posts['posts-content-html-code'])  then
        self.json(5002, "请填写文章内容")
    else
        posts.content = posts['posts-content-html-code']
        posts.summary = htmlutils:sub_html(posts.content, 200)
        posts['posts-content-html-code'] = nil
    end
    if func.is_empty_str(posts.createTime) then
        posts.create_time = func.datetime()
    else
        posts.create_time = posts.createTime
        posts.createTime = nil
    end

    if action == 'edit'  then
        if not posts.postsId or tonumber(posts.postsId) < 1 then
            self.json(5001, "请选择要编辑的文章")
        end
        posts.posts_id = posts.postsId
        posts.postsId = nil
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local data = check_form(self)
        local info, err = posts.add(data)
        if info then
            self.json(200, '添加成功', {url = '/admin/posts/index'})
        else
            self.json(5003, "添加失败")
        end
    else
        local categorylist = category.categorylist()
        local userList = user:lists()
        self:assign('title', '添加文章')
        self:assign('categoryList', categorylist)
        self:assign('userList', userList)
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local data = check_form(self, 'edit')
        local info, err = posts.update(data)
        if info then
            self.json(200, '修改成功', {url = '/admin/posts/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的文章"
        else
            local ok, postsId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的文章"
            else
                info = posts.detail(postsId)
                if not info then
                    err = "未查询到相应的文章信息"
                end
            end
        end
        local categorylist = category.categorylist()
        self:assign('title', '编辑文章')
        self:assign('categoryList', categorylist)
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.detail(self)
        local userInfo
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的文章"
        else
            local ok, postsId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的文章"
            else
                info = posts.detail(postsId)
                if not info then
                    err = "未查询到相应的文章信息"
                else
                    userInfo = user.detail(tonumber(info.author))
                end
            end
        end
        local categorylist = category.categorylist()
        local userList = user:lists()
        self:assign('title', '文章详情')
        self:assign('categoryList', categorylist)
        self:assign('userList', userList)
        self:assign('info', info)
        self:assign('userInfo', userInfo)
        self:assign('error', err)
        self:display()
    
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的文章')
    end
    local ok, postsId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的文章")
    end

    local status, err = posts.delete(postsId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/posts/index'})
    end
end

return _M