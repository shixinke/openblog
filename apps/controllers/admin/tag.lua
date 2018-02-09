local _M = {
    _VERSION = '0.01'
}

local tag = require 'service.tag'


function _M.init(self)
    self.disabled_view = true
    self:check_login()
end

function _M.lists(self)
    local params = {}
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.tagName) ~= true  then
        params.name = posts.tagName
    end
    if func.is_empty_str(posts.tagAlias) ~= true  then
        params.alias = posts.tagAlias
    end
    if func.is_empty_str(posts.status) ~= true  then
        params.status = posts.status
    end
    if func.is_empty_str(posts.display) ~= true  then
        params.display = posts.display
    end

    local tags = tag:search(params)
    if tags then
        self.json(200, '获取成功', func.array_camel_style(tags))
    else
        self.json(5003, "获取失败")
    end
end

function _M.add(self)
    local params = {}
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.tagName) ~= true  then
        params.tag_name = posts.tagName
    else
        self.json(5001, "请输入标签名称")
    end
    if func.is_empty_str(posts.tagAlias) ~= true  then
        params.tag_alias = posts.tagAlias
    else
        self.json(5002, "请输入标签别名")
    end

    local info, err = tag.add(params)
    if info then
        self.json(200, '添加成功', func.table_camel_style(info))
    else
        self.json(5003, "添加失败"..err)
    end
end

function _M.edit(self)
    local params = {}
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.tagName) ~= true  then
        params.tag_name = posts.tagName
    else
        self.json(5001, "请输入标签名称")
    end
    if func.is_empty_str(posts.tagAlias) ~= true  then
        params.tag_alias = posts.tagAlias
    else
        self.json(5002, "请输入标签别名")
    end

    if func.is_empty_str(posts.tagId) == true  then
        self.json(5002, "请选择标签")
    end

    local ok, tagId = pcall(tonumber, posts.tagId)
    if not ok then
        self.json(5003, '请选择合法标签')
    end
    params.tag_id = tagId

    local info, err = tag.update(params)
    if info then
        self.json(200, '修改成功', params)
    else
        self.json(5003, "修改失败:"..err)
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的标签')
    end
    local ok, tagId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的标签")
    end

    local status, err = tag.delete(tagId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功')
    end
end


return _M