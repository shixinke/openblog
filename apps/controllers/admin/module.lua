local _M = {
    _VERSION = '0.01'
}

local module = require 'service.module'
local ngx_var = ngx.var
local io_open = io.open
local cmd = require 'system.cmd'



function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    local datalist = module.lists_by_hooks()
    func.error_log(datalist)
    self:assign('title', '模块列表')
    self:assign('items', datalist.items)
    self:assign('groups', datalist.hooks)
    self:display()
end


local function list_components()
    local dir = ngx_var.app_root..'/components'
    local lines = cmd.exec('ls '..dir, true)
    local values = {}
    if lines then
        for _, line in pairs(lines) do
            if line ~= 'component.lua' then
                local json_file = dir..'/'..line..'/config.json'
                local tab, err = func.read_json(json_file)
                if tab then
                    values[line] = tab
                end
            end
        end
    end
    return values
end


local function check_form(self, action)
    local posts = self:post()
    posts = posts and posts or {}
    if func.is_empty_str(posts.moduleName)  then
        self.json(5001, "请输入模块名称")
    end
    posts.module_name = posts.moduleName
    posts.moduleName = nil
    if func.is_empty_str(posts.alias)  then
        self.json(5001, "请输入模块标识")
    end
    if not posts.content then
        posts.content = ''
    end
    if posts.moduleType then
        posts.module_type = posts.moduleType
        posts.moduleType = nil
    end
    if posts.maxItems then
        posts.max_items = tonumber(posts.maxItems)
        posts.maxItems = nil
    end
    if posts.showTitle then
        posts.show_title = tonumber(posts.showTitle)
        posts.showTitle = nil
    else
        posts.show_title = 0
    end
    if action == 'edit'  then
        if not posts.moduleId or tonumber(posts.moduleId) < 1 then
            self.json(5001, "请选择要编辑的模块")
        end
        posts.module_id = posts.moduleId
        posts.moduleId = nil
    end
    return posts
end

function _M.add(self)
    if self:is_post() then
        local posts = check_form(self)
        local info, err = module.add(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/module/index'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        local hooks = config.hooks
        local components = list_components()
        self:assign('title', '添加模块')
        self:assign('hooks', hooks)
        self:assign('components', components)
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = check_form(self, 'edit')
        local info, err = module.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/module/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的模块"
        else
            local ok, moduleId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的模块"
            else
                info = module.detail(moduleId)
                if not info then
                    err = "未查询到相应的模块信息"
                end
            end
        end
        local components = list_components()
        self:assign('title', '编辑模块')
        self:assign('info', info)
        self:assign('error', err)
        self:assign('hooks', config.hooks)
        self:assign('components', components)
        self:display()
    end
end

function _M.select(self)
    if self:is_post() then
        local posts = self:post()
        if func.is_empty_str(posts.moduleId) then
            self.json(5005, '请选择要删除的模块')
        end
        local ok, moduleId = pcall(tonumber, posts.moduleId)
        if not ok then
            self.json(5008, "请选择合法的模块")
        end
        if func.is_empty_str(posts.hook) then
            self.json(5005, '请选择位置')
        end
        local info, err = module.update({module_id = moduleId, hook = posts.hook, status = 1})
        if info then
            self.json(200, '选择成功', {url = '/admin/module/index'})
        else
            self.json(5003, "选择失败")
        end
    else
        local position = self:get('position')
        local datalist = module.lists(0)
        local err
        if func.is_empty_str(position) then
            err = "请选择位置"
        end
        local hooks_tab = {}
        for name, v in pairs(config.hooks) do
            if v.position == position then
                hooks_tab[name] = v
            end
        end
        self:assign('title', '选择模块')
        self:assign('error', err)
        self:assign('hooks', hooks_tab)
        self:assign('datalist', datalist)
        self:display()
    end
end

function _M.cancel(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的模块')
    end
    local ok, moduleId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的模块")
    end

    local status, err = module.update({module_id = moduleId, status = 0})
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/module/index'})
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的模块')
    end
    local ok, moduleId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的模块")
    end

    local status, err = module.delete(moduleId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/module/index'})
    end
end

function _M.lists(self)
    list_components()
end

return _M