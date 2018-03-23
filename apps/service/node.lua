local _M = {_VERSION = '0.01' }
local node = require 'models.node':new()
local tostring = tostring
local table_sort = table.sort

function _M.lists(status)
    local datalist =  node:lists(status)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.tree(all)
    local datalist
    if all then
        datalist = _M.lists()
    else
        datalist = _M.lists(1)
    end
    local tree = {}
    if datalist then
        local tmp = {}
        for _, row in pairs(datalist) do
            if row.parentId == 0 then
                tmp[tostring(row.id)] = row
            else
                local pid = tostring(row.parentId)
                if not tmp[pid]['children'] then
                    tmp[pid]['children'] = {}
                end
                tmp[pid]['children'][#tmp[pid]['children'] + 1] = row
            end
        end
        for _, v in pairs(tmp) do
            tree[#tree +1] = v
        end
        table_sort(tree, function(first, second)
            if first.weight > second.weight then
                return true
            else
                return false
            end
        end)
    end
    return tree
end

function _M.rules()
    local rules = {}
    local tree = _M.tree(1)
    if tree then
        for _, v in pairs(tree) do
            rules[#rules + 1] = v
            if v.children and #v.children > 0 then
                for _, child in pairs(v.children) do
                    rules[#rules + 1] = child
                end
            end
        end
    end
    ngx.log(ngx.ERR, cjson.encode(rules))
    return rules
end

function _M.menulist()
    local menulist =  node:menulist()
    if menulist then
        menulist = func.array_camel_style(menulist)
    end
    return menulist
end

function _M.add(data)
    return node:add(data)
end

function _M.update(data)
    return node:edit(data)
end

function _M.detail(id)
    local info =  node:detail(id)
    if info then
        info = func.table_camel_style(info)
    end
    return info
end

function _M.delete(id)
    return node:remove(id)
end

return _M