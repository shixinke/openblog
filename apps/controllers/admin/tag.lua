local _M = {
    _VERSION = '0.01'
}

local tag = require 'service.tag'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '标签列表')
    self:display()
end

function _M.lists(self)
    local multi = self:get('multi')
    local isMulti = 0
    local ok, multi = pcall(tonumber, multi)
    if ok then
        isMulti = multi
    end
    self:assign('title', '标签列表')
    self:assign('multi', isMulti)
    self:display()
end


function _M.datalist(self)
    local params = {}
    local posts = self:get()
    posts = posts and posts or {}
    if func.is_empty_str(posts.tagName) ~= true  then
        params.tagName = posts.tagName
    end
    if func.is_empty_str(posts.tagAlias) ~= true  then
        params.tagAlias = posts.tagAlias
    end
    if func.is_empty_str(posts.status) ~= true  then
        params.status = tonumber(posts.status)
    end
    if func.is_empty_str(posts.display) ~= true  then
        params.display = tonumber(posts.display)
    end

    local tags = tag.search(params)
    if tags then
        self.json(200, '获取成功', tags)
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    local params = {}
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
    if not posts.display then
        posts.display = 0
    end
    if not posts.status then
        posts.status = 0
    end
    if posts.weight then
        params.weight = posts.weight
    end
    if action == 'edit'  then
        if not posts.tagId or tonumber(posts.tagId) < 1 then
            self.json(5001, "请选择要编辑的标签")
        end
        params.tag_id = posts.tagId
    end
    return params
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = tag.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/tag/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        self:assign('title', '添加标签')
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = tag.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/tag/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的标签"
        else
            local ok, tagId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的标签"
            else
                info = tag.detail(tagId)
                if not info then
                    err = "未查询到相应的标签信息"
                end
            end
        end

        self:assign('title', '编辑标签')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
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
        self.json(200, '删除成功', {url = '/admin/tag/index'})
    end
end

return _M