--[[
-- @description : RSS library for openresty
-- @author : shixinke <ishixinke@qq.com>
-- @website : www.shixinke.com
-- @date : 2018-02-02
--]]
local _M = {
    _version = '0.01'
}

local io_open = io.open
local substr = string.sub
local str_gmatch = string.gmatch
local strlen = string.len
local ngx_var = ngx.var
local internal_request = ngx.location.capture
local http_ok = ngx.HTTP_OK


local mt = {
    __index = _M
}

local function parse_content(content)
    local tab = {}
    for line in str_gmatch(content, 'name">([^<]+)') do
        tab[#tab + 1] = {name = line}
    end
    local idx = 0
    for line in str_gmatch(content, 'fontclass">([^<]+)') do
        idx = idx + 1
        if tab[idx] then
            tab[idx].class = substr(line, 2, strlen(line))
        end
    end
    return tab
end

local function content_from_file(file)
    local fd = io_open(file)
    if not fd then
        return nil, 'the file '..file..' does not exists'
    end
    local content = fd:read('*a')
    fd:close()
    return content
end

local function content_from_http(url)
    local res = internal_request(url)
    if res.status == http_ok then
        return res.body
    else
        return nil, 'request failed'
    end
end

function _M.new(self, opts)
    local options = opts or {}
    local mode = options.mode or 'file'
    if mode == 'file' then
        if not options.file or options.file == '' then
            return nil, 'the filename is empty'
        end
        local root = options.root or ngx_var.document_root or ''
        if substr(options.file, 1, 1) ~= '/' then
            options.file = root..'/'..options.file
        end
    end
    if mode == 'http' then
        if not options.url or options.url == '' then
            return nil, 'the http url is empty'
        end
        if substr(options.url, 1, 4) == 'http' then
            return nil, 'does not support external requests'
        end
    end
    return setmetatable({
        mode = mode,
        file = options.file,
        url = options.url,
        content = nil,
        result = {}
    }, mt)
end

function _M.parse(self)
    local content = self.content
    if content == nil then
        if self.mode == 'file' then
            content = content_from_file(self.file)
        elseif self.mode == 'http' then
            content = content_from_http(self.url)
        end
        self.content = content
    end
    if not self.content then
        return nil, 'get content failed'
    end
    return parse_content(self.content)
end

return _M
