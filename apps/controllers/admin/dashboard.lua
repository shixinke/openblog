local _M = {
    _VERSION = '0.01'
}

require 'resty.core.shdict'
local dict = ngx.shared.blog_dict
local ngx_config = ngx.config
local ngx_worker = ngx.worker
local ngx_var = ngx.var
local tonumber = tonumber
local log = ngx.log
local LOG_ERR = ngx.ERR
local cmd = require 'system.cmd'
local stats = require 'service.stats'
local date = os.date
local os_time = os.time
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
    self:check_login()
    self.layout = 'admin/layout/layout.html'
end

function _M.index(self)
    local userInfo = self.get_login_info()
    local region_info = region:search(userInfo.lastLoginIp)
    userInfo.lastLoginLocation = region_info and region_info['city'] or ''
    local disk = cmd.disk()
    local dict_capacity = get_dict_capacity()
    local dict_free = get_dict_free_space()
    local sysInfo = {
        serverVersion = 'Nginx '..ngx_var.nginx_version..'( ngx_lua '..version_format(ngx_config.ngx_lua_version)..')',
        version = 'thinklua '..config.version,
        workCount = ngx_worker.count(),
        dictCapacity = dict_capacity,
        dictFreeSpace = dict_free,
        dictUsedRate = func.percent(dict_capacity - dict_free, dict_capacity, 2),
        memory = cmd.memory(),
        sysDisk = get_system_disk(disk),
        dataDisk = get_data_disk(disk),
        uptime = func.pretty_time(func.time(cmd.uptime()), true)
    }
    sysInfo.memory.usedRate = func.percent(sysInfo.memory.used, sysInfo.memory.total, 2)
    self:assign('title', '管理后台控制台')
    self:assign('userInfo', userInfo)
    self:assign('sysInfo', sysInfo)
    self:display()
end


function _M.stats(self)
    local total = stats.overview()
    local hotList = stats.hot()
    local today = stats.daily()
    local stats_data = {
        total = total,
        topicList = func.array_camel_style(hotList.topicList),
        tagList = func.array_camel_style(hotList.tagList),
        categoryList = func.array_camel_style(hotList.categoryList),
        postsList = func.array_camel_style(hotList.postsList),
        today = today
    }
    self.json(200, '获取成功', stats_data)
end


return _M