--[[
-- @description : FEED library for openresty
-- @author : shixinke <ishixinke@qq.com>
-- @website : www.shixinke.com
-- @date : 2018-03-23
--]]
local _M = {
    _version = '0.01'
}

local str_format = string.format
local date = os.date
local time = ngx.time
local ngx_var = ngx.var
local io_open = io.open

local mt = {
    __index = _M
}

local function merge(tab1, tab2)
    local obj = tab1 or {}
    for k, v in pairs(tab2) do
        if v ~= nil then
            obj[k] = v
        end
    end
    return obj
end

local function date_format(datetime)
    if datetime == nil then
        datetime = time()
    end
    return date('%Y-%m-%dT%H%M%S.000Z', datetime)
end

function _M.new(opts)
    opts = opts or {}
    local defaults = {
        xmlns = 'http://www.w3.org/2005/Atom',
        filename = 'atom.xml',
        title = '诗心博客',
        subtitle = '专注于WEB开发与文学创作',
        domain = 'www.shixinke.com',
        author = 'shixinke',
        path = ngx_var.document_root
    }
    local options = merge(defaults, opts)
    local data = opts.data or {}
    return setmetatable({
        options = options,
        data = data
    }, mt)
end

function _M.add(self, row)
    if type(row) ~= 'table' then
        return nil, 'the data can not be nil'
    end
    if not row.title or row.title == '' then
        return nil, 'title required'
    end
    if not row.link or row.link == '' then
        return nil, 'link required'
    end
    if not row.id or row.id == '' then
        return nil, 'id required'
    end
    if not row.published or row.published == '' then
        return nil, 'published required'
    end
    if not row.updated or row.updated == '' then
        row.updated = row.published
    end
    if not row.content or row.content == '' then
        return nil, 'content required'
    end
    if not row.summary or row.summary == '' then
        return nil, 'summary required'
    end
    if type(row.category) ~= 'table' then
        return nil, 'category required'
    end

    self.data[#self.data +1] = row
end

function _M.xml(self)
    local xml = '<feed xmlns="%s">'..'\n'
    xml = xml   ..'  <title>%s</title>'..'\n'
    xml = xml   ..'  <subtitle>%s</subtitle>'..'\n'
    xml = xml   ..'  <link href="/%s" rel="self"/>'..'\n'
    xml = xml   ..'  <link href="%s/"/>'..'\n'
    xml = xml   ..'  <updated>%s</updated>'..'\n'
    xml = xml   ..'  <id>%s</id>'..'\n'
    xml = xml   ..'  <author>'..'\n'
    xml = xml     ..'    <name>%s</name>'..'\n'
    xml = xml   ..'  </author>'..'\n'
    xml = xml   ..'<generator uri="%s/">%s</generator>'
    xml = str_format(xml, self.options.xmlns, self.options.title, self.options.subtitle, self.options.filename,
        self.options.domain, date_format(), self.options.domain, self.options.author, self.options.domain, self.options.title
    )
    for _, v in pairs(self.data) do
        xml = xml   ..'  <entry>'..'\n'
        xml = xml   ..'    <title>%s</title>'..'\n'
        xml = xml   ..'    <link href="%s"/>'..'\n'
        xml = xml   ..'    <id>%s</id>'..'\n'
        xml = xml   ..'    <published>%s</published>'..'\n'
        xml = xml   ..'    <updated>%s</updated>'..'\n'
        xml = xml   ..'    <content type="html"><![CDATA[%s]]></content>'..'\n'
        xml = xml   ..'    <summary type="html">%s</summary>'..'\n'
        xml = str_format(xml, v.title, v.url, v.url, v.published, v.updated, v.content, v.summary)
        if v.category ~= nil then
            for _, c in pairs(v.category) do
                xml = xml .. str_format('    <category term="%s" scheme="%s"/>'..'\n', c.categoryName, c.url)
            end
        end
        if v.tags ~= nil then
            for _, t in pairs(v.tags) do
                xml = xml .. str_format('    <category term="%s" scheme="%s"/>'..'\n', t.tagName, t.url)
            end
        end
        xml = xml   ..'  </entry>'..'\n'
    end
    xml = xml   ..'</feed>'
    return xml
end

function _M.create(self)
    local file = self.options.path..'/'..self.options.filename
    local content = self:xml()
    local fd, err = io_open(file, 'w')
    if not fd then
        return nil, 'open file failed, the reason is:'..err
    end
    local ok = fd:write(content)
    fd:close()
    if not ok then
        return nil, 'write file failed'
    end
    return true
end
return _M
