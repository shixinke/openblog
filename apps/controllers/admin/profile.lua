local _M = {
    _VERSION = '0.01'
}

local user_service = require 'service.user'

function _M.init(self)
    self:check_login()
    self.layout = 'admin/layout/layout.html'
end

function _M.index(self)
    if self:is_post() then
        local data = {}

        data.nickname = self:post('nickname')
        if data.nickname == nil or data.nickname == '' then
            self.json(4003, '请输入昵称')
        end

        data.email = self:post('email')
        if data.email == nil or data.email == '' then
            self.json(4003, '请输入邮箱')
        end

        local avatar = self:post('avatar')
        if avatar ~= nil and avatar ~= '' then
            data.avatar = avatar
        end

        local res, err = user_service.save_profile(data)
        if res then
            self.json(200, '保存成功', {url = '/admin/profile/index'})
        else
            self.json(201, err)
        end
    else
        local avatarList = {}
        for i = 1, 12 do
            avatarList[i] = '/static/images/avatar/'..i..'.jpg'
        end
        self:assign('title', '个人资料')
        self:assign('avatarList', avatarList)
        self:assign('userInfo', self.get_login_info())
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
        local res, err = user_service.save_password(password)
        if res then
            self.json(200, '保存成功', {url = '/admin/profile/index'})
        else
            self.json(201, err)
        end
    else
        local avatarList = {}
        for i = 1, 12 do
            avatarList[i] = '/static/images/avatar/'..i..'.jpg'
        end
        self:assign('title', '修改个人密码')
        self:assign('avatarList', avatarList)
        self:assign('userInfo', self.get_login_info())
        self:display()
    end
end




return _M