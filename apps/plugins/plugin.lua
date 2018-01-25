local _M = {_VERSION = '0.01'}
local mod = require 'models.module':new()
local log = ngx.log

function _M.loads()
    local plugins = func.dict_get('plugins')
    local datalist = {}
    if not plugins then
        local plugins = {}
        local datalist = mod:lists()
        if datalist then
            for _, v in pairs(datalist) do
                plugins[v.alias] = {type = v.type, position = v.position}
            end
        end
    else
        plugins = cjson.decode(plugins)
        for i, _ in pairs(plugins) do
            local tmp = func.dict_get('plugin:'..i)
            if tmp then
                datalist[i] = cjson.decode(tmp)
            end
        end
    end
    return plugins,datalist
end

function _M.html()
    local views = {}
    local plugins,datalist = _M.loads()
    if plugins and datalist and #datalist > 0 then
        for i, v in pairs(datalist) do
            v.meta = cjson.decode(v.meta)
            if views[v.position] == nil then
                views[v.position] = {}
            end
            if v.type == 'HTML' then
                views[v.position][#views[v.position]+1] = v.content
            else
                local status, res = pcall(require, 'plugins.'..v.filename)
                if status then
                    views[v.position][#views[v.position]+1] = res.html(v)
                else
                    log(ngx.ERR, 'load the plugin '..i..' failed,maybe the file '..v.filename..' does not exists')
                end
            end
        end
    end
    return views
end

