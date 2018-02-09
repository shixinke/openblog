local _M = {
    _VERSION = '0.01'
}

local category = require 'service.category'

local function parse_request(obj)
    local params = {}
    local posts = obj:post()
    posts = posts and posts or {}
    params = posts
    if func.is_empty_str(posts.categoryName) ~= true  then
        params.categoryName = nil
        params.category_name = posts.categoryName
    else
        obj.json(5001, "请输入分类名称")
    end
    if func.is_empty_str(posts.alias) ~= true  then
        params.alias = posts.alias
    else
        obj.json(5002, "请输入分类别名")
    end
    local options = {}
    if func.is_empty_str(posts.icon) ~= true  then
        options.icon = posts.icon
        posts.icon = nil
    end
    if func.is_empty_str(posts.sort) ~= true  then
        local ok, num = pcall(tonumber, posts.sort)
        if not ok then
            params.sort = 0
        else
            params.sort = num
        end
    end
    if func.is_empty_str(posts.status) ~= true  then
        params.status = posts.status and 1 or 0
    end
    if func.is_empty_str(posts.parentId) ~= true  then
        params.parent_id = posts.parentId
        params.parentId = nil
    end
    params.options = cjson.encode(options)
    return params
end

function _M.init(self)
    self.disabled_view = true
    self:check_login()
end

function _M.lists(self)

    local category_list = category.lists()
    if category_list then
        self.json(200, '获取成功', func.array_camel_style(category_list))
    else
        self.json(5003, "获取失败")
    end
end

function _M.add(self)
    local params = parse_request(self)

    local info, err = category.add(params)
    if info then
        self.json(200, '添加成功', func.table_camel_style(info))
    else
        self.json(5003, "添加失败"..err)
    end
end

function _M.edit(self)
    local params = parse_request(self)

    local ok, categoryId = pcall(tonumber, params.categoryId)
    if not ok then
        self.json(5003, '请选择合法分类')
    end
    params.categoryId = nil
    params.category_id = categoryId
    params.createTime = nil

    local info, err = category.update(params)
    if info then
        self.json(200, '修改成功', params)
    else
        self.json(5003, "修改失败:"..err)
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的分类')
    end
    local ok, categoryId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的分类")
    end

    local status, err = category.delete(categoryId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功')
    end
end


return _M