local _M = {
    _VERSION = '0.01'
}

local link = require 'service.link'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '友情链接列表')
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

    if func.is_empty_str(posts.linkName) ~= true  then
        params.link_name = tonumber(posts.linkName)
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

    local links = link.search(params, page, pagesize)
    if links then

        self.json(200, '获取成功', links)
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.websiteName)  then
        self.json(5001, "请输入网站名称")
    end
    posts.website_name = posts.websiteName
    posts.websiteName = nil
    if func.is_empty_str(posts.linkName)  then
        posts.link_name = posts.website_name
    else
        posts.link_name = posts.linkName
        posts.linkName = nil
    end
    if func.is_empty_str(posts.url)  then
        self.json(5002, "请输入友情链接链接地址")
    end
    if not posts.display then
        posts.display = 0
    end
    if not posts.status then
        posts.status = 0
    end
    if action == 'edit'  then
        if not posts.linkId or tonumber(posts.linkId) < 1 then
            self.json(5001, "请选择要编辑的友情链接")
        end
        posts.link_id = posts.linkId
        posts.linkId = nil
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = link.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/link/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        self:assign('title', '添加友情链接')
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = link.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/link/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的友情链接"
        else
            local ok, linkId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的友情链接"
            else
                info = link.detail(linkId)
                if not info then
                    err = "未查询到相应的友情链接信息"
                end
            end
        end

        self:assign('title', '编辑友情链接')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的友情链接')
    end
    local ok, linkId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的友情链接")
    end

    local status, err = link.delete(linkId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/link/index'})
    end
end

return _M