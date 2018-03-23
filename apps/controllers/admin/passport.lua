local _M = {
    _VERSION = '0.01'
}

local session = require 'system.session'
local user_service = require 'service.user'


function _M.init(self)
    self.withoutLayout = true
end

function _M.login(self)
    if self:is_post() then
        local data = self:post()
        if data.account == nil or data.account == '' then
            self.json(4003, '请输入账号')
        end

        if data.password == nil or data.password == '' then
            self.json(4003, '请输入密码')
        end

        data.password = func.password(data.password)
        local res, err = user_service.checklogin(data.account, data.password)
        if res then
            self.json(200, '登录成功', {url = '/admin/index'})
        else
            self.json(5002, err)
        end
    else
        self:assign('register', config.pages.register)
        self:assign('title', '管理登录')
        self:display()
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
        local confirm_password = self:post('confirmPassword')
        if confirm_password == nil or confirm_password == '' then
            self.json(4003, '请输入确认密码')
        end
        if confirm_password ~= password then
            self.json(4003, '两次输入密码不一致')
        end
        local res, err, errcode, sqlstate = user_service.add(data)
        if res then
            self.json(200, '申请成功')
        else
            self.json(201, '申请失败'..err)
        end
    else
        self:assign('register', config.pages.register)
        self:assign('title', '管理账号申请')
        self:display()
    end
end

function _M.reset(self)
    local uid = 1
    local password = func.password("e10adc3949ba59abbe56e057f20f883e")
    local res, err, errcode, sqlstate = user_service.save_password(password, uid)
    if res then
        self.json(200, '重置成功')
    else
        self.json(201, '重置失败'..err)
    end

end

function _M.status(self)
    local user_info = self:get_login_info()
    if user_info then
        self.json(200, '用户已登录', user_info)
    else
        self.json(5006, '用户未登录')
    end
end

function _M.logout(self)
    session.destroy()
    if func.is_ajax() then
        self.json(200, '退出成功', {url = '/admin/passport/login'})
    else
        ngx.redirect('/admin/passport/login')
    end
end

return _M