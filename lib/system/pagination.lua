local _M = {
    _VERSION = '0.01',
    data = {}
}

local mt = {
    __index = _M
}
local math_ceil = math.ceil

local function merge(tab1, tab2)
    local obj = tab1 or {}
    for k, v in pairs(tab2) do
        if v ~= nil then
            obj[k] = v
        end
    end
    return obj
end

local function get_pages(total, pagesize)
    local pages = 0
    if total > 0 then
        pages = math_ceil(total / pagesize)
    end
    return pages
end

function _M.new(opts)
    local defaults = {
        format = '<>',
        pages = 0,
        total = 0,
        page = 1,
        pagesize = 15,
        className = 'pagination',
        baseUrl = '/page-',
        firstPageUrl = '/',
        suffix = '.html',
        activeClassName = 'current'
    }
    local data = opts or {}
    local options = merge(defaults, data)
    options.pages = get_pages(options.total, options.pagesize)
    return setmetatable(options, mt)
end

function _M.show(self)
    if self.pages == 1 then
        return ''
    end
    local html = '<div id="page-nav" class="'..self.className..'">';
    for i =1, self.pages do
        if i == self.page then
            html = html .. '<li class="page-number '..self.activeClassName..'">'..i..'</li>'
        else
            local href = self.baseUrl..tostring(i)..self.suffix
            if i == 1 then
                href = self.firstPageUrl
            end

            html = html .. '<li class="page-number"><a href="'..href..'">'..i..'</a></li>'
        end
    end
    html = html ..'</div>'
    return html
end

return _M