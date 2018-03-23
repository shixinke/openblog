local _M = {_VERSION = '0.01' }
local category = require 'models.category':new()
local tostring = tostring
local table_sort = table.sort


function _M.lists(status)
    local datalist = category:lists(status)
    if datalist then
        for i, v in pairs(datalist) do
            datalist[i] = func.table_camel_style(datalist[i])
            datalist[i].url = '/category-'..v.alias
            if config.routes.url_suffix then
                datalist[i].url = datalist[i].url..config.routes.url_suffix
            end
        end
    end
    return datalist
end

function _M.menulist()
    local datalist = category:where({status = 1, parent_id = 0}):order('weight', 'DESC'):findAll()
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.get_by_alias(alias)
    local data = category:where({alias = alias, status = 1}):find()
    if data then
        data = func.table_camel_style(data)
    end
    return data
end


function _M.detail(id)
    local data = category:detail(id)
    if data then
        data = func.table_camel_style(data)
    end
    return data
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
                tmp[tostring(row.categoryId)] = row
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

function _M.datalist()
    local tree = _M.tree(1)
    return _M.parse_tree(tree)
end

function _M.parse_tree(tree)
    local rules = {}
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
    return rules
end

function _M.categorylist(is_tree)
    local tree = _M.tree()
    if is_tree then
        return tree
    end
    return  _M.parse_tree(tree)
end


function _M.add(data)
    return category:add(data)
end

function _M.update(data)
    return category:edit(data)
end

function _M.delete(categoryId)
    local info = category:fields({'items'}):where({category_id = categoryId}):find()
    if not info then
        return nil, '该标签不存在'
    end
    if info.items > 0 then
        return nil, '该标签下面有文章，不能删除'
    end
    return category:where({category_id = categoryId}):delete()
end

return _M