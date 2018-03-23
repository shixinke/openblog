local _M = {
    _VERSION = '0.01'
}

local role = require 'service.role'
local node = require 'service.node'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '角色管理')
    self:display()
end

function _M.datalist(self)
    local params = {}
    local gets = self:get()
    if func.is_empty_str(gets.roleName) ~= true then
        params.role_name = gets.roleName
    end
    if func.is_empty_str(gets.roleId) ~= true then
        params.role_id = gets.roleId
    end
    if func.is_empty_str(gets.status) ~= true then
        params.status = gets.status
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
    local data = role.search(params, page, pagesize)
    self.json(200, '加载成功', data)
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.roleName)  then
        self.json(5001, "请输入角色名称")
    end
    posts.role_name = posts.roleName
    posts.roleName = nil
    if not posts.status then
        posts.status = 0
    end
    if action == 'edit'  then
        if not posts.roleId or tonumber(posts.roleId) < 1 then
            self.json(5001, "请选择要编辑的角色")
        end
        posts.role_id = posts.roleId
        posts.roleId = nil
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = role.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/role/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        self:assign('title', '添加角色')
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = role.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/role/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的角色"
        else
            local ok, roleId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的角色项"
            else
                info = role.detail(roleId)
                if not info then
                    err = "未查询到相应的角色信息"
                end
            end
        end

        self:assign('title', '编辑角色')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的角色')
    end
    local ok, roleId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的角色")
    end

    local status, err = role.delete(roleId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/role/index'})
    end
end


return _M