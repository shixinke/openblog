local _M = {
    _VERSION = '0.01'
}

local session = require 'system.session'
local user_model = require 'models.user'
local user = user_model:new()

local md5 = ngx.md5

function _M.init(self)
    self.disabled_view = true
end

function _M.checklogin(self)
    if self:is_post() then
        local data = self:post()
        if data.account == nil or data.account == '' then
            self.json(4003, '请输入账号')
        end

        if data.password == nil or data.password == '' then
            self.json(4003, '请输入密码')
        end

        data.password = func.password(data.password)
        local res, err = user:checklogin(data.account, data.password)
        if res then
            local user_info = res
            user_info.password = nil
            local sess = session.get_session(true)
            sess.data.user_info = user_info
            sess:save()
            self.json(200, '登录成功')
        else
            self.json(5002, err)
        end
    else
        self.json(4002, '请求非法')
    end
end

function _M.register(self)
    if self:is_post() then
        local data = {}

        data.account = self:post('account')
        if data.account == nil or data.account == '' then
            self.json(4003, '请输入账号')
        end
        local password = self:post('password')
        if password == nil or password == '' then
            self.json(4003, '请输入密码')
        end
        data.password = func.password(password)
        local confirm_password = self:post('confirm_password')
        if confirm_password ~= password then
            self.json(4003, '两次输入密码不一致,password:'..password..',confirm:'..confirm_password)
        end
        local res, err, errcode, sqlstate = user:add(data)
        if res then
            self.json(200, '添加成功')
        else
            self.json(201, '添加失败'..err)
        end
    else
        self.json(4002, '请求非法')
    end
end

function _M.logout(self)
    local sess = session.start()
    sess:destroy()
    self.json(200, '退出成功', {url = '/admin/passport/login'})
end

return _M