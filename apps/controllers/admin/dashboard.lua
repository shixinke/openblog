local _M = {
    _VERSION = '0.01'
}

require 'resty.core.shdict'
local dict = ngx.shared.blog_dict
local ngx_config = ngx.config
local ngx_worker = ngx.worker
local ngx_var = ngx.var
local log = ngx.log
local LOG_ERR = ngx.ERR
local cmd = require 'system.cmd'
local stats = require 'service.stats'
local region = require 'resty.ip2region.ip2region':new({dict = 'blog_dict'})



local function version_format(version)
    local version = math.floor(version / 1000000) .. '.' .. math.floor(version / 1000) ..'.' .. math.floor(version % 1000)
    return version
end

local function get_dict_capacity()
    if not dict then
        return 0
    end
    if dict.capacity then
        return dict:capacity()
    end
    return 0
end

local function get_dict_free_space()
    if not dict then
        return 0
    end
    if dict.free_space then
        return dict:free_space()
    end
    return 0
end

local function get_data_disk(data)
    local data_disk = {}
    local data_mounted = config.sys.disk.data
    for _, v in pairs(data) do
        if v.mounted == data_mounted then
            data_disk = v
            return data_disk
        end
    end
    return data_disk
end

local function get_system_disk(data)
    local system_disk = {}
    local system_mounted = config.sys.disk.system
    for _, v in pairs(data) do
        if v.mounted == system_mounted then
            system_disk = v
            return system_disk
        end
    end
    return system_disk
end

function _M.init(self)
    self.disabled_view = true
    self:check_login()
end


function _M.stats(self)
    local user_info = self:get_login_info()
    local total = stats.overview()
    user_info = user_info or {}
    local disk = cmd.disk()
    local region_info = region:search(user_info.last_login_ip)
    local stats_data = {
        user = {
            nickname = user_info.nickname,
            avatar = user_info.avatar,
            lastLoginTime = user_info.last_login_time,
            lastLoginLocation = region_info and region_info['city'] or '',
            lastLoginIp = user_info.last_login_ip
        },
        sys = {
            serverVersion = 'Nginx '..ngx_var.nginx_version..'( ngx_lua '..version_format(ngx_config.ngx_lua_version)..')',
            version = config.version,
            workCount = ngx_worker.count(),
            dictCapacity = get_dict_capacity(),
            dictFreeSpace = get_dict_free_space(),
            memory = cmd.memory(),
            sysDisk = get_system_disk(disk),
            dataDisk = get_data_disk(disk),
            uptime = func.pretty_time(func.time(cmd.uptime()), true)
        },
        total = total,
        topics = {},
        tags = {},
        category = {},
        stats = {}
    }
    self.json(200, '获取成功', stats_data)
end

return _M