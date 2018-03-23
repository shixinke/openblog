local _M = {
    _VERSION = '0.01'
}

local category = require 'service.category'

local function parse_request(obj, action)
    local params = {}
    local posts = obj:post()
    posts = posts and posts or {}
    params = posts
    if func.is_empty_str(posts.categoryName)  then
        obj.json(5001, "请输入分类名称")
    end

    params.category_name = posts.categoryName
    params.categoryName = nil
    if func.is_empty_str(posts.alias)   then
        obj.json(5002, "请输入分类别名")
    end
    if func.is_empty_str(posts.weight) ~= true  then
        local ok, num = pcall(tonumber, posts.weight)
        if not ok then
            params.weight = 0
        else
            params.weight = num
        end
    end
    if func.is_empty_str(posts.status) ~= true  then
        params.status = posts.status and 1 or 0
    end
    if func.is_empty_str(posts.parentId) ~= true  then
        params.parent_id = posts.parentId
        params.parentId = nil
    end
    if action == 'edit' then
        local ok, categoryId = pcall(tonumber, posts.categoryId)
        if not ok   then
            obj.json(5002, "请选择要修改的分类")
        end
        params.category_id = categoryId
        params.categoryId = nil
    end
    return params
end

function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    local category_list = category.datalist()
    if category_list then
        category_list =  func.array_camel_style(category_list)
    end
    self:assign('title', '分类')
    self:assign('dataList', category_list)
    self:display()
end


function _M.add(self)
    if self:is_post() then
        local params = parse_request(self)
        local info, err = category.add(params)
        if info then
            self.json(200, '添加成功', {url = '/admin/category/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        local menuList = category.menulist()
        self:assign('title', '添加分类')
        self:assign('menuList', menuList)
        self:display()
    end    
end

function _M.edit(self)
    if self:is_post() then
        local posts = parse_request(self, 'edit')
        local info, err = category.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/category/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的分类"
        else
            local ok, categoryId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的分类项"
            else
                info = category.detail(categoryId)
                if not info then
                    err = "未查询到相应的分类信息"
                end
            end
        end


        local menuList = category.menulist()
        self:assign('title', '编辑权限分类')
        self:assign('menuList', menuList)
        self:assign('info', info)
        self:assign('error', err)
        self:display()
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