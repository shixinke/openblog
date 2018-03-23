local _M = {
    _VERSION = '0.01'
}

local comment = require 'service.comment'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '评论列表')
    self:display()
end


function _M.datalist(self)
    local posts = self:get()
    local display
    local params = {}
    if func.is_empty_str(posts.display) ~= true  then
        params.display = tonumber(posts.display)
    end

    if func.is_empty_str(posts.status) ~= true  then
        params.status = tonumber(posts.status)
    end

    if func.is_empty_str(posts.websiteName) ~= true  then
        params.website_name = tonumber(posts.websiteName)
    end

    if func.is_empty_str(posts.commentName) ~= true  then
        params.comment_name = tonumber(posts.commentName)
    end

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

    local comments = comment.search(params, page, pagesize)
    if comments then

        self.json(200, '获取成功', comments)
    else
        self.json(5003, "获取失败")
    end
end

function _M.lists(self)
    local postsId = self:get('postsId')
    if not postsId then
        self.json(5003, '请选择文章')
    end
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
    local comments = comment.search({posts_id = tonumber(postsId)}, page, pagesize)
    local pages = math.ceil(comments.total / pagesize)
    if comments then
        comments.page = page
        comments.pagesize = pagesize
        comments.pages = pages
    end
    self.json(200, "获取成功", comments)
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.content)  then
        self.json(5001, "请输入评论内容")
    end
    if func.is_empty_str(posts.postsId)  then
        self.json(5002, "请选择要评论的文章")
    end
    posts.posts_id = posts.postsId
    posts.postsId = nil
    local userInfo = self:get_login_info()
    posts.uid = userInfo.uid
    posts.username = userInfo.nickname
    posts.email = userInfo.email
    posts.create_time = func.datetime()
    posts.ip = func.get_client_ip()
    posts.user_agent = ngx.var.http_user_agent
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = comment.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/comment/index'})
        else
            self.json(5003, "添加失败")
        end
    else
        self:assign('title', '添加评论')
        self:display()
    end
end

function _M.detail(self)
    if self:is_get() then
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的评论"
        else
            local ok, commentId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的评论"
            else
                info = comment.detail(commentId)
                if not info then
                    err = "未查询到相应的评论信息"
                end
            end
        end

        self:assign('title', '查看评论')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的评论')
    end
    local ok, commentId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的评论")
    end

    local status, err = comment.delete(commentId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/comment/index'})
    end
end

return _M