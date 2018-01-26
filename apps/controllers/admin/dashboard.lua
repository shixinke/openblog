local _M = {
    _VERSION = '0.01'
}

local dict = ngx.shared.blog_dict
local ngx_config = ngx.config
local ngx_worker = ngx.worker
local ngx_var = ngx.var
local log = ngx.log
local LOG_ERR = ngx.ERR
local posts_model = require ''


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

function _M.init(self)
    self.disabled_view = true
    self:check_login()
end

function _M.stats(self)
    local user_info = self:get_login_info()
    local stats_data = {
        user = {
            nickname = user_info.nickname,
            avatar = user_info.avatar,
            lastLoginTime = user_info.last_login_time,
            lastLoginLocation = user_info.last_login_ip,
            lastLoginIp = user_info.last_login_ip
        },
        sys = {
            serverVersion = 'Nginx '..ngx_var.nginx_version..'( ngx_lua '..version_format(ngx_config.ngx_lua_version)..')',
            version = config.version,
            workCount = ngx_worker.count(),
            dictCapacity = get_dict_capacity(),
            dictFreeSpace = get_dict_free_space(),
            memory = 0,
            memoryUsed = 0,
            sysDisk = 0,
            sysDiskUsed = 0,
            dataDisk = 0,
            dataDiskUsed = 0
        },
        total = {},
        topics = {},
        tags = {},
        category = {},
        stats = {}
    }
    self.json(200, '获取成功', stats_data)
end

return _M