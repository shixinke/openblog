local _M = {
    _VERSION = '0.01'
}

local nav = require 'service.nav'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '导航列表')
    self:display()
end


function _M.datalist(self)
    local posts = self:get()
    local display
    local params = {}
    if func.is_empty_str(posts.display) ~= true  then
        params.display = posts.display
    end

    if func.is_empty_str(posts.position) ~= true  then
        params.position = tonumber(posts.position)
    end

    if func.is_empty_str(posts.navType) ~= true  then
        params.nav_type = tonumber(posts.navType)
    end

    local navs = nav.search(params)
    if navs then

        self.json(200, '获取成功', {total = #navs, list = navs})
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.title)  then
        self.json(5001, "请输入导航名称")
    end
    if func.is_empty_str(posts.url)  then
        self.json(5002, "请输入导航链接")
    end
    if not posts.display then
        posts.display = 0
    end
    if posts.navType then
        posts.nav_type = posts.navType
        posts.navType = nil
    end
    if action == 'edit'  then
        if not posts.navId or tonumber(posts.navId) < 1 then
            self.json(5001, "请选择要编辑的导航")
        end
        posts.nav_id = posts.navId
        posts.navId = nil
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = nav.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/nav/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        self:assign('title', '添加导航')
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = nav.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/nav/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的导航"
        else
            local ok, navId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的导航"
            else
                info = nav.detail(navId)
                if not info then
                    err = "未查询到相应的导航信息"
                end
            end
        end

        self:assign('title', '编辑导航')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的导航')
    end
    local ok, navId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的导航")
    end

    local status, err = nav.delete(navId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/nav/index'})
    end
end

return _M