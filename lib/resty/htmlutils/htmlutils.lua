local _M = {_VERSION = '0.01' }
local strbyte = string.byte
local stringlen = string.len
local stringsub = string.sub
local regex = ngx.re
local tab_remove = table.remove
local self_close_tags = {
    'input',
    'img',
    'meta',
    'br',
    'hr',
    'link',
    'base',
    'area',
    'col',
    'command',
    'embed',
    'keygen',
    'param',
    'source',
    'track',
    'wbr'
}

local function char_size(ch)
    if not ch then
        return 0
    elseif ch > 240 then
        return 4
    elseif ch > 225 then
        return 3
    elseif ch > 192 then
        return 2
    else
        return 1
    end
end

function _M.strlen(self, str)
    local len = 0
    local idx = 1
    while idx <= #str do
        local char = strbyte(str, idx)
        idx = idx + char_size(char)
        len = len +1
    end
    return len
end

local function in_array(ele, arr)
    if not ele or type(arr) ~= 'table' then
        return false
    end
    for _, v in pairs(arr) do
        if v == ele then
            return true
        end
    end
    return false
end

function _M.substr(self, str, start, num)
    local idx = 1
    while start > 1 do
        local char = strbyte(str, idx)
        idx = idx + char_size(char)
        start = start - 1
    end

    local cur = idx

    while num > 0 and cur <= #str do
        local char = strbyte(str, cur)
        cur = cur + char_size(char)
        num = num -1
    end
    return str:sub(idx, cur - 1)
end

function _M.textlen(self, html)
    local text, err = self:strip_tags(html)
    if text then
        return self:strlen(text)
    else
        return self:strlen(html)
    end
end

function _M.sub_html(self, html, len)
    if self:textlen(html) <= len then
        return html
    end
    local open_tags = {}
    local pad_tags = {}
    local str
    local num = 0
    local idx = 1
    local tmp = html
    while num < len do
        tmp = stringsub(html, idx)
        local byte = strbyte(tmp, 1)
        if byte == 60 then
            if strbyte(tmp, 2) == 47 then
                local m, err = regex.match(tmp, '\\<\\/([a-zA-Z]+)\\s*[^\\>]*\\>', "isjo")
                if m then
                    tab_remove(open_tags, #open_tags)
                    idx = idx+stringlen(m[0])
                end
            else
                local m, err = regex.match(tmp, '\\<([a-zA-Z]+)\\s*[^\\>]*\\>', "isjo")
                if m then
                    if in_array(m[1], self_close_tags) == false then
                        open_tags[#open_tags+1] = m[1]
                    end
                    idx = idx+stringlen(m[0])
                end
            end
        else
            idx = idx +char_size(byte)
            num = num+1
        end

    end
    str = stringsub(html, 1, idx-1)
    local tag_len = #open_tags
    if tag_len >0 then
        local temp = tag_len
        while temp > 0 do
            pad_tags[#pad_tags+1] = open_tags[temp]
            temp = temp - 1
        end
        for _, val in pairs(pad_tags) do
            str = str ..'</'..val..'>'
        end
    end
    return str
end

function _M.strip_tags(self, html)
    local str, _, err = regex.gsub(html, '\\<[^>]+\\>', '')
    return str, err
end

function _M.truncate(self, html, len)
    return self:sub_html(html, len)
end


return _M