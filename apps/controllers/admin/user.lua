local _M = {
    _VERSION = '0.01'
}

local session = require 'resty.session'
local user_model = require 'models.user'
local user = user_model:new()

local md5 = ngx.md5

function _M.init(self)
    self.layout = 'admin/layouts/layout.html'
end


function _M.index(self)
    local condition = {}
    local page = self:get('page')
    page = (page and tonumber(page)) or 1
    local pagesize = (condition.pagesize and tonumber(condition.pagesize)) or 20
    local offset = page > 1 and (page - 1)*pagesize or 0
    local data = user:search(condition, offset, pagesize)
    condition.page = page
    condition.pagesize = pagesize
    self:assign('title', '管理登录')
    self:assign('data', data)
    self:assign('condition', condition)
    self:display()
end

function _M.add(self)
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
            local sess = session.start()
            sess.data.uid = res.uid
            sess.data.user_info = user_info
            sess:save()
            self.json(200, '登录成功')
        else
            self.json(5002, err)
        end
    else
        self:display()
    end
end

function _M.edit(self)
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
            local sess = session.start()
            sess.data.uid = res.uid
            sess.data.user_info = user_info
            sess:save()
            self.json(200, '登录成功')
        else
            self.json(5002, err)
        end
    else
        self:display()
    end
end

function _M.delete(self)
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
            local sess = session.start()
            sess.data.uid = res.uid
            sess.data.user_info = user_info
            sess:save()
            self.json(200, '登录成功')
        else
            self.json(5002, err)
        end
    else
        self.json(4002, '非法操作')
    end
end





return _M