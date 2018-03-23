local _M = {_VERSION = '0.01'}
local mod = require 'service.module'
local log = ngx.log
local ngx_var = ngx.var

function _M.loads()
    local hooks = config.hooks
    local components = func.dict_get('components')
    local datalist = {}
    if not components then
        components = mod.lists(1)
    else
        components = cjson.decode(components)
    end
    if components then
        for _, v in pairs(components) do
            local row = {title = v.moduleName, content = '', showTitle = v.showTitle, id = v.alias, data = nil, type = v.type}
            if v.type == 1 then
                row.content = v.content
            else
                local ok, file = pcall(require, 'apps.components.'..v.filename..'.handler')
                if not ok then
                    func.error_log('the component file '..v.filename..' does not exists')
                else
                    row.data = file.data(v)
                end
            end
            if row.content ~= '' or row.data ~= nil then
                if datalist[v.hook] == nil then
                    datalist[v.hook] = {}
                end
                if hooks[v.hook] then
                    if (hooks[v.hook].max < 1) or (#datalist[v.hook] < hooks[v.hook].max) then
                        datalist[v.hook][#datalist[v.hook] + 1] = row
                    else
                        func.error_log('the hook '..v.hook..' max length is :'..hooks[v.hook].max)
                    end
                end
            end
        end
    end
    return datalist
end

return _M

