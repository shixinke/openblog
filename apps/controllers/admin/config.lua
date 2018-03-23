local _M = {
    _VERSION = '0.01'
}

local config = require 'service.config'

local function parse_request(obj, action)
    local params = {}
    local posts = obj:post()
    posts = posts and posts or {}
    params = posts
    if func.is_empty_str(posts.title)  then
        obj.json(5001, "请输入配置项名称")
    end

    if func.is_empty_str(posts.key)   then
        obj.json(5002, "请输入配置项键")
    end

    if func.is_empty_str(posts.value)   then
        obj.json(5002, "请输入配置项值")
    end
    if posts.datatype == 'JSON' then
        params.value = cjson.encode(params.value)
    end
    return params
end

function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    local config_list = config.lists()
    self:assign('title', '配置管理')
    self:assign('dataList', config_list)
    self:display()
end

function _M.lists(self)
    local groups = config.grouplist()
    local dataTypes = config.dataTypes()
    self:assign('title', '配置列表')
    self:assign('groups', groups)
    self:assign('dataTypes', dataTypes)
    self:display()
end

function _M.datalist(self)
    local params = {}
    local posts = self:get()
    posts = posts and posts or {}
    if func.is_empty_str(posts.group) ~= true  then
        params.group = posts.group
    end
    if func.is_empty_str(posts.key) ~= true  then
        params.key = posts.key
    end
    if func.is_empty_str(posts.title) ~= true  then
        params.title = posts.title
    end

    local lists = config.search(params)
    if lists then
        self.json(200, '获取成功', lists)
    else
        self.json(5003, "获取失败")
    end
end


function _M.add(self)
    if self:is_post() then
        local params = parse_request(self)
        local info, err = config.add(params)
        if info then
            self.json(200, '添加成功', {url = '/admin/config/lists'})
        else
            self.json(5003, "添加失败"..err)
        end
    else
        local groups = config.grouplist()
        local dataTypes = config.dataTypes()
        self:assign('title', '添加配置项')
        self:assign('groups', groups)
        self:assign('dataTypes', dataTypes)
        self:display()
    end
end

function _M.save(self)
    if self:is_post() then
        local posts = self:post()
        local params = {}
        if posts.key then
            for i, v in pairs(posts.key) do
                if posts.datatype[i] and posts.value[i] then
                    params[v] = {
                        datatype = posts.datatype[i],
                        value = posts.value[i]
                    }
                end
            end
        end
        ngx.log(ngx.ERR, cjson.encode(params))
        local res = config.save(params)
        if res then
            self.json(200, '修改成功', {url = '/admin/config/index'})
        else
            self.json(5003, "修改失败")
        end
    else
        self.json(404, "非法操作")
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = parse_request(self)
        local info, err = config.update(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/config/lists'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的配置项"
        else
            info = config.detail(id)
            if not info then
                err = "未查询到相应的配置信息"
            end
        end


        local groups = config.grouplist()
        local dataTypes = config.dataTypes()
        self:assign('title', '编辑权限配置项')
        self:assign('groups', groups)
        self:assign('dataTypes', dataTypes)
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的配置项')
    end

    local status, err = config.delete(id)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功')
    end
end


return _M