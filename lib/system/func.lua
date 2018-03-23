local _M = {
    _VERSION = '0.01'
}

local ngx = ngx
local type = type
local debug = config.debug
local base_model = require 'system.model'
local regex = ngx.re
local strlen = string.len
local substr = string.sub
local str_replace = string.gsub
local io_open = io.open
local date = os.date
local time = os.time
local log = ngx.log
local LOG_DEBUG = ngx.DEBUG
local LOG_ERR = ngx.ERR
local tonumber = tonumber
local math_floor = math.floor
local ngx_null = ngx.null
local str_gmatch = string.gmatch
local strtoupper = string.upper
local json_decode = cjson.decode
local dict = ngx.shared.blog_dict


function _M.trim(str)
    local m, err = regex.match(str, "[^s]+.+[^s]+", 'ijso')
    if m then
        return m[1]
    else
        return str, err
    end
end

function _M.is_empty_table(tab)
    local num = 0
    for _, _ in pairs(tab) do
        num = num + 1
    end
    if num > 0 then
        return false
    else
        return true
    end
end

function _M.extends(child, parent)
    local mt = {__index = parent}
    return setmetatable(child, mt)
end

function _M.extends_model(model)
    return _M.extends(model, base_model)
end

function _M.merge(tab1, tab2)
    local obj = tab1 or {}
    for k, v in pairs(tab2) do
        if v ~= nil then
            obj[k] = v
        end
    end
    return obj
end

function _M.start_trim(str, contains)
    local sublen = strlen(contains)
    local len = strlen(str)
    if substr(str, 1, sublen) == contains then
        return substr(str, sublen, len)
    end
    return str
end

function _M.end_trim(str, contains)
    local len = strlen(str)
    local sublen = strlen(contains)
    local starts = len - sublen
    if substr(str, -sublen, len) == contains then
        return substr(str, 1, starts)
    end
    return str
end

function _M.in_array(ele, tab)
    if ele == nil or type(ele) == 'table' or type(tab) ~= 'table' then
        return nil
    end
    local matched,i,v
    for i, v in pairs(tab) do
        if v == ele then
            matched = i
            break
        end
    end
    return matched
end

function _M.clear_table(tab)
    local obj = {}
    if type(tab) ~= 'table' then
        return obj
    end
    for k, v in pairs(tab) do
        if v then
            obj[k] = v
        end
    end
    return obj
end

function _M.table_length(tab, except)
    local len = 0
    for k, v in pairs(tab) do
        if v and except then
            len = len+1
        else
            len = len+1
        end
    end
    return len
end

function _M.split(str, pattern)
    local tab = {}
    local iterator, err = regex.gmatch(str, pattern, 'ijso')
    if not iterator then
        tab = {str}
        return tab, err
    end
    local m, err = iterator()
    if not m then
        tab = {str}
        return tab, err
    end
    while m do
        tab[#tab+1] = m[1]
        m = iterator()
    end
    return tab
end

function _M.explode(delimiter, str)
    local tab = {}
    if type(str) ~= 'string' or delimiter == nil then
        return tab
    end

    local delen = -strlen(delimiter)
    local subs = substr(str, delen)
    if subs ~= delimiter then
        str = str..delimiter
    end
    local pattern
    if _M.in_array(delimiter, {'|'}) then
        pattern = '([^'..delimiter..']+)\\'..delimiter
    else
        pattern = '([^'..delimiter..']+)'..delimiter
    end
    return _M.split(str, pattern)
end


function _M.url_parse(url)
    local url_tab = {path = nil, params = {} }
    if url == nil then
        return nil, 'the url is nil'
    end
    local m, err = regex.match(url, '([^\\?]+)\\?([^\\?]+)')
    if not m then
        url_tab.path = url
        return url_tab, err
    end
    url_tab.path = m[1]
    local iterator, err = regex.gmatch(m[2], '([a-zA-Z0-9_-]+)=([a-zA-Z0-9_-]+)', 'ijso')
    if not iterator then
        url_tab.params = {}
        return url_tab, err
    end
    local m, err = iterator()
    if not m then
        url_tab.params = {}
        return url_tab, err
    end
    while m do
        url_tab.params[m[1]] = m[2]
        m = iterator()
    end
    return url_tab
end

function _M.implode(delimiter, tab)
    local str = ''
    if type(tab) ~= 'table' or delimiter == nil then
        return str
    end
    local count = #tab
    for i, v in pairs(tab) do
        if type(v) ~= 'table' then
            str = str..v
            if i ~= count then
                str = str..delimiter
            end
        end
    end
    return str
end

function _M.show_404(msg)
    msg = msg or ''
    if debug then
        local html = '<meta charset="utf-8"><div style="position: relative;padding: 15px 15px 15px 55px;margin-bottom: 20px;font-size: 14px;background-color: #fafafa;border: solid 1px #d8d8d8;border-radius: 3px;">'..msg..'</div>'
        ngx.say(html)
        ngx.exit(ngx.HTTP_OK)
    else
        ngx.redirect(config.pages.not_found)
    end
end

function _M.show_error(code, err)
    if debug then
        local html = '<meta charset="utf-8"><div style="position: relative;padding: 15px 15px 15px 55px;margin-bottom: 20px;font-size: 14px;background-color: #fafafa;border: solid 1px #d8d8d8;border-radius: 3px;line-height:35px;"><p>error code:'..code..'</p><p>error msg:'..err..'</p></div>'
        ngx.say(html)
        ngx.exit(ngx.HTTP_OK)
    else
        ngx.log(LOG_ERR, err)
        ngx.redirect(config.pages.server_error)
    end
end

function _M.is_empty_str(str)
    if not str or str == '' or str == ngx_null then
        return true
    end
    return false
end

function _M.password(password)
    local salt = config.security.password_salt or 'shixinke'
    return ngx.md5(password..salt)
end

function _M.datetime(timestamp)
    local t = timestamp and timestamp or time()
    return date('%Y-%m-%d %H:%M:%S', t)
end

function _M.time(datetime)
    if datetime then
        local year = substr(datetime, 1, 4)
        local month = substr(datetime, 6, 7)
        local day = substr(datetime, 9, 10)
        local hour = substr(datetime, 12, 13)
        local minute = substr(datetime, 15, 16)
        local second = substr(datetime, 18, 19)
        return time({year = year, month = month, day = day, hour = hour, min = minute, sec = second})
    else
        return time()
    end
end

function _M.pretty_time(timestamp, part)
    local now = time()
    local diff = now - timestamp
    local str = ""
    local min = 60
    local hour = 60*min
    local day = 24 * hour
    local mon = 30 * day
    local year = 12 * mon
    if min > diff then
        str = diff.."秒";
    elseif min <= diff and hour > diff then
        str = math_floor(diff /  60) .."分";
        if part then
            local secs = diff % min
            if secs > 0 then
                str = str..secs..'秒'
            end
        end
    elseif hour <= diff and day > diff then
        str = math_floor(diff / hour) .."时";
        if part then
            local mins = math_floor(diff % hour / min)
            local secs = diff % min
            if secs > 0 then
                str = str..mins..'分'..secs..'秒'
            elseif mins > 0 then
                str = str..mins..'分'
            end
        end
    elseif day <= diff and mon > diff then
        str = math_floor(diff / day) .."天"
        if part then
            local mins = math_floor(diff % hour / min)
            local hours = math_floor(diff % day / hour)
            if mins > 0 then
                str = str..hours..'时'..mins..'分'
            elseif hours > 0 then
                str = str..hours..'时'
            end
        end
    elseif mon <= diff and year > diff then
        str = math_floor(diff / mon) .. "月";
        if part then
            local hours = math_floor(diff % day / hour)
            local days = math_floor(diff % mon / day)
            if hours > 0 then
                str = str..days..'天'..hours..'时'
            elseif days > 0 then
                str = str..days..'天'
            end
        end
    else
        str = math_floor(diff / year) .. "年";
        if part then
            local days = math_floor(diff % mon /day)
            local mons = math_floor(diff % year / mon )
            if days > 0 then
                str = str..days..'月'..days..'天'
            elseif mons > 0 then
                str = str..mons..'天'
            end
        end
    end
    return str;
end

function _M.debug_log(message)
    if debug then
        if type(message) == 'table' then
            message = json_decode(message)
        end
        log(LOG_ERR, message)
    end
end

function _M.error_log(message)
    if type(message) == 'table' then
        message = json_decode(message)
    end
    log(LOG_ERR, message)
end

function _M.ucfirst(str)
    if _M.is_empty_str(str) then
        return str
    end

    local len = strlen(str)
    if len == 1 then
        return strtoupper(str)
    end
    local first_char = substr(str, 1, 1)
    return strtoupper(first_char)..substr(str, 2, strlen(str))
end

function _M.log(level, message)
    log(level, message)
end

function _M.str_camel_style(str)
    if type(str) == 'string' and _M.is_empty_str(str) ~= true then
        local index = 1
        local camel_str = ""
        for mat in str_gmatch(str, "[^_]+") do
            if index == 1 then
                camel_str = camel_str..mat
            else
                camel_str = camel_str.._M.ucfirst(mat)
            end
            index = index + 1
        end
        return camel_str
    end
    return str
end

function _M.table_camel_style(tab)
    if type(tab) == 'table' then
        local camel_tab = {}
        for k, v in pairs(tab) do
            camel_tab[_M.str_camel_style(k)] = v
        end
        return camel_tab
    else
        return _M.str_camel_style(tab)
    end
end

function _M.array_camel_style(tab)
    if type(tab) == 'table' then
        local camel_tab = {}
        for k, v in pairs(tab) do
            if type(v) == 'table' then
                camel_tab[k] = _M.table_camel_style(v)
            end
        end
        return camel_tab
    else
        return _M.str_camel_style(tab)
    end
end

function _M.get_client_ip()
    local ip = ngx.req.get_headers()['X-Real-IP'] or ngx.var.remote_addr
    return ip
end

function _M.is_ajax()
    local header = ngx.req.get_headers()['X-Requested-With']
    if header and header == 'XMLHttpRequest' then
        return true
    end
    return false
end

function _M.read_json(file)
    local fd, err = io_open(file)
    if not fd then
        return nil, err
    end
    local content = fd:read('a*')
    local ok, tab = pcall(json_decode, content)
    if not ok then
        return nil, 'parse json file failed'
    end
    return tab
end

function _M.percent(val, total, dot)
    local rate = (val / total) * 100
    local num = dot and tonumber(dot) or 2
    return tonumber(string.format("%."..num.."f", rate))
end

function _M.page_util(page, pagesize)
    local pagesize = pagesize and tonumber(pagesize)  or 0
    local tab = {
        offset = 0,
        limit = pagesize
    }
    if page and page > 0 then
        tab.offset = (page - 1) * pagesize
    end
    return tab
end

function _M.dict_set(k, v)
    if not dict then
        return false, 'dict not exists'
    end
    if type(v) == 'table' then
        v = cjson.encode(v)
    end
    return dict:set(k, v)
end

function _M.dict_get(k, tab)
    if not dict then
        return false, 'dict not exists'
    end
    local val = dict:get(k)
    if tab then
        local ok, val = pcall(cjson.decode, val)
        return val
    end
    return val
end

function _M.addslashes(html, slashes)
    local slash = slashes and slashes or '"'
    return str_replace(html, slash, '\\'..slash)
end

function _M.removeslashes(html, slashes)
    local slash = slashes and slashes or '"'
    return str_replace(html, '\\'..slash, slash)
end

function _M.var_dump(v)
    local tab = {type = nil, value = nil }
    tab.type = type(v)
    tab.value = v
    ngx.say(cjson.encode(tab))
end

function _M.array_column(arr, id)
    if not id then
        return arr
    end
    local tab = {}
    for i, v in pairs(arr) do
        if v[id] then
            tab[tostring(v[id])] = v
        end
    end
    return tab
end

return _M