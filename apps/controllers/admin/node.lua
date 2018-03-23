local _M = {
    _VERSION = '0.01'
}

local node = require 'service.node'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    local data = node.rules()
    self:assign('title', '权限菜单')
    self:assign('dataList', data)
    self:display()
end

function _M.rules(self)
    local data = node.rules()
    self.json(200, '加载成功', data)
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.title)  then
        self.json(5001, "请输入权限菜单名称")
    end
    if posts.type == 2 and func.is_empty_str(posts.uri)  then
        self.json(5001, "请输入权限菜单地址")
    end
    if not posts.display then
        posts.display = 0
    end
    if posts.parentId then
        posts.parent_id = posts.parentId
        posts.parentId = nil
    end
    if not posts.status then
        posts.status = 0
    end
    if action == 'edit' and (not posts.id or tonumber(posts.id) < 1) then
        self.json(5001, "请选择要编辑的菜单")
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = node.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/node/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        local menuList = node.menulist()
        self:assign('title', '添加权限菜单')
        self:assign('menuList', menuList)
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = node.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/node/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的菜单"
        else
            local ok, nodeId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的菜单项"
            else
                info = node.detail(nodeId)
                if not info then
                    err = "未查询到相应的菜单信息"
                end
            end
        end


        local menuList = node.menulist()
        self:assign('title', '编辑权限菜单')
        self:assign('menuList', menuList)
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的权限菜单')
    end
    local ok, nodeId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的权限菜单")
    end

    local status, err = node.delete(nodeId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/node/index'})
    end
end


return _M