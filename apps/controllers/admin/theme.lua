local _M = {
    _VERSION = '0.01'
}

local config = require 'service.config'
local ngx_var = ngx.var
local cmd = require 'system.cmd'

function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

local function list_themes()
    local dir = ngx_var.template_root
    local lines = cmd.exec('ls '..dir, true)
    local values = {}
    if lines then
        for _, line in pairs(lines) do
            if line ~= 'admin' then
                local json_file = dir..'/'..line..'/config.json'
                local tab, err = func.read_json(json_file)
                if tab then
                    values[line] = tab
                end
            end
        end
    end
    return values
end

function _M.index(self)
    local value = config.item('default_theme')
    local themes = list_themes()
    self:assign('title', '主题管理')
    self:assign('value', value)
    self:assign('themes', themes)
    self:display()
end


function _M.set(self)
    if self:is_post() then
        local theme = self:post('theme')
        local info, err = config.update({key = 'default_theme', value = theme})
        if info then
            self.json(200, '设置成功', {url = '/admin/theme/index'})
        else
            self.json(5003, "设置失败"..err)
        end
    else
        self.json(5003, "非法操作")
    end
end


return _M