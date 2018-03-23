local _M = {
    _VERSION = '0.01'
}

local mt = {
    __index = _M
}
local ngx_var = ngx.var
local regex = ngx.re
local log = ngx.log
local strlen = string.len
local substr = string.sub
local router = require 'system.router':new()
local base_controller = require 'system.controller'
local layers = {}
local ngx_req = ngx.req
local function get_layers()
    if #layers > 0 then
        return layers
    end
    if config.routes.layer_status == 'on' and config.routes.layers then
        for k, v in pairs(config.routes.layers) do
            layers[#layers+1] = k
        end
        layers = layers
    end
    return layers
end



function _M.parse(self)
    local layers = get_layers()
    local uri = ngx_var.uri
    local route_status = config.routes.router_status
    for _, v in pairs(layers) do
        local starts = '/'..v
        local starts_len = strlen(starts)
        if substr(uri, 1, starts_len) == starts then
            route_status = config.routes.layers[v].router_status
        end
    end
    local url_tab
    if route_status == 'on' then
        url_tab = router:route()
    end
    if url_tab == nil then
        if config.routes.url_suffix and config.routes.url_suffix ~= '' then
            uri = func.end_trim(uri, config.routes.url_suffix)
        end
        url_tab = {path = uri, params = ngx_req.get_uri_args() }
    end
    return self:dispatch(url_tab)
end

function _M.parse_url(self, uri, args)
    local layers = get_layers()
    local tab = {}
    local default_controller = config.routes.default_controller or 'index'
    local default_action = config.routes.default_action or 'index'
    if uri == '/' then
        tab.controller = default_controller
        tab.action = default_action
    else
        local mat = func.split(uri, '/([a-zA-Z0-9-_]+)')
        local count = #mat
        if count <= 2 then
            if layers and func.in_array(mat[1], layers) then
                tab.layer = mat[1]
                tab.controller = mat[2] or default_controller
                tab.action = default_action
            else
                tab.controller = mat[1] or default_controller
                tab.action = mat[2] or default_action
            end
        else
            if layers and func.in_array(mat[1], layers) then
                tab.layer = mat[1]
                tab.controller = mat[2]
                tab.action = mat[3]
                for i = 4, count, 2 do
                    if mat[i+1] then
                        args[mat[i]] = mat[i+1]
                    end
                end
            else
                tab.controller = mat[1]
                tab.action = mat[2]
                for i = 3, count, 2 do
                    if mat[i+1] then
                        args[mat[i]] = mat[i+1]
                    end
                end
            end
        end
        tab.params = args
    end
    return tab
end

function _M.call(self, tab)
    local url_tab = tab
    local ok, m_controller,path
    if url_tab.layer then
        path = 'apps.controllers.'..url_tab.layer..'.'..url_tab.controller
        ok, m_controller = pcall(require, path)
    else
        path = 'apps.controllers.'..url_tab.controller
        ok, m_controller = pcall(require, path)
    end

    if not ok then
        return nil, nil, 'the path '..path..' does not exists'
    elseif type(m_controller)  ~= 'table' then
        func.error_log('the path '..path..'  is not a lua module')
        return nil, nil, 'the path '..path..'  is not a lua module'
    else
        if not m_controller[url_tab.action] or type(m_controller[url_tab.action]) ~= 'function' then
            return m_controller, nil, 'the function '..url_tab.action..' does not exists'
        end
        return m_controller, url_tab.action
    end

end

function _M.dispatch(self, url_tab)
    local uri = url_tab.path
    local tab = self:parse_url(uri, url_tab.params)
    local m_controller, m_action, err = self:call(tab)
    if not m_controller or not m_action then
        if router.remains then
            tab = self:parse_url(router.remains.path, router.remains.params)
            m_controller, m_action = self:call(tab)
        end
    end
    if not m_controller then
        local dir = tab.layer and tab.layer..'/'..tab.controller or tab.controller
        func.show_404('the controller file apps/controllers/'..dir..'.lua'..' does not exists or it is not a controller module')
    elseif not m_action then
        func.show_404('the action '..tab.action..' is not exists')
    else
        local mt = {__index = base_controller}
        setmetatable(m_controller, mt)
        local theme_status = config.routes.theme_status
        if tab.layer then
            theme_status = config.routes.layers[tab.layer].theme_status
        end
        local components = registry:get('components')
        local common_view_data = registry:get('view_data')
        if components then
            m_controller.view_data = components
        end
        if common_view_data then
            for key, value in pairs(common_view_data) do
                m_controller.view_data[key] = value
            end
        end
        if theme_status == 'on' then
            local theme
            if tab.layer then
                theme = registry:get(tab.layer..'_default_theme')
            else
                theme = registry:get('default_theme')
                if not theme then
                    theme = 'default'
                end
            end

            m_controller.theme = theme
        else
            m_controller.theme = nil
        end
        if m_controller.init then
            m_controller.init(m_controller)
        end
        if not m_controller.disabled_view then
            m_controller:init_view(m_controller)
        end
        m_controller.layer = tab.layer
        m_controller.controller = tab.controller
        m_controller.action = tab.action
        m_controller.params = tab.params
        return m_controller[tab.action](m_controller)
    end
end

return _M