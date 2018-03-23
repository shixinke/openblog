local _M = {
    _VERSION = '0.01'
}

local user = require 'service.user'
local role = require 'service.role'

function _M.init(self)
    self:check_login()
    self.layout = 'admin/layout/layout.html'
end


function _M.index(self)
    local roleList = role.lists()
    self:assign('title', '管理员列表')
    self:assign('roleList', roleList)
    self:display()
end

function _M.datalist(self)
    local params = {}
    local gets = self:get()
    if func.is_empty_str(gets.roleId) ~= true then
        params.role_id = gets.roleId
    end
    if func.is_empty_str(gets.nickname) ~= true then
        params.nickname = gets.nickname
    end
    if func.is_empty_str(gets.account) ~= true then
        params.account = gets.account
    end
    if func.is_empty_str(gets.email) ~= true then
        params.email = gets.email
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
    local data = user.search(params, page, pagesize)
    self.json(200, '加载成功', data)
end

local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.account)  then
        self.json(5001, "请输入账号")
    end
    if func.is_empty_str(posts.nickname)  then
        self.json(5001, "请输入昵称")
    end
    if not posts.status then
        posts.status = 0
    end
    local uid = posts.uid and tonumber(posts.uid) or 0
    if action == 'edit' and uid < 1 then
        self.json(5001, "请选择要编辑的角色")
    end
    if action == 'add' then
        if func.is_empty_str(posts.password) then
            self.json(5008, '请输入密码')
        end
        posts.password = func.password(posts.password)
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local data = check_form(self)
        local res, err = user.add(data)
        if res then
            self.json(200, '添加成功', {url = '/admin/user/index'})
        else
            self.json(5002, err)
        end
    else
        local avatarList = {}
        for i = 1, 12 do
            avatarList[i] = '/static/images/avatar/'..i..'.jpg'
        end

        local roleList = role.lists()
        self:assign('avatarList', avatarList)
        self:assign('title', '添加管理员')
        self:assign('roleList', roleList)
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local data = check_form(self)
        local res, err = user.update(data)
        if res then
            self.json(200, '修改成功', {url = '/admin/user/index'})
        else
            self.json(5002, err)
        end
    else
        local uid = self:get('uid')
        local err
        local info
        local ok, uid = pcall(tonumber, uid)
        if not ok then
            err = '请选择要修改的用户'
        else
            info = user.detail(uid)
            if not info then
                err = "未查询到该用户信息"
            end
        end

        local avatarList = {}
        for i = 1, 12 do
            avatarList[i] = '/static/images/avatar/'..i..'.jpg'
        end
        local roleList = role.lists()
        self:assign('title', '编辑管理员')
        self:assign('roleList', roleList)
        self:assign('avatarList', avatarList)
        self:assign('err', err)
        self:assign('info', info)
        self:display()
    end
end

function _M.password(self)
    if self:is_post() then
        local password = self:post('password')
        if password == nil or password == '' then
            self.json(4003, '请输入新密码')
        end

        local confirm_password = self:post('confirmPassword')
        if confirm_password == nil or confirm_password == '' then
            self.json(4003, '请输入确认密码')
        end

        if confirm_password ~= password then
            self.json(4003, '两次输入密码不一致')
        end

        local uid = self:post('uid')
        local ok, uid = pcall(tonumber, uid)
        if not ok then
            self.json(4003, '请选择要修改的用户')
        end
        local res, err = user.save_password(password, uid)
        if res then
            self.json(200, '修改成功', {url = '/admin/user/index'})
        else
            self.json(5002, err)
        end
    else
        local avatarList = {}
        for i = 1, 12 do
            avatarList[i] = '/static/images/avatar/'..i..'.jpg'
        end
        local uid = self:get('uid')
        local err
        local info
        local ok, uid = pcall(tonumber, uid)
        if not ok then
            err = '请选择要修改的用户'
        else
            info = user.detail(uid)
            if not info then
                err = "未查询到该用户信息"
            end
        end
        self:assign('title', '修改用户密码')
        self:assign('avatarList', avatarList)
        self:assign('err', err)
        self:assign('info', info)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的用户')
    end
    local ok, uid = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的用户")
    end

    local status, err = user.delete(uid)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/user/index'})
    end
end





return _M