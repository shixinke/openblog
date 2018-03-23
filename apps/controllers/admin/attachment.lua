local _M = {
    _VERSION = '0.01'
}

local attachment = require 'service.attachment'


function _M.init(self)
    self.layout = 'admin/layout/layout.html'
    self:check_login()
end

function _M.index(self)
    self:assign('title', '附件列表')
    self:display()
end


function _M.datalist(self)
    local posts = self:get()
    local display
    local params = {}
    if func.is_empty_str(posts.display) ~= true  then
        params.display = posts.display
    end

    if func.is_empty_str(posts.position) ~= true  then
        params.position = tonumber(posts.position)
    end

    if func.is_empty_str(posts.attachmentType) ~= true  then
        params.attachment_type = tonumber(posts.attachmentType)
    end

    local page = self:get('page')
    local pagesize = self:get('pageSize')
    local ok, page = pcall(tonumber, page)
    if not ok then
        page = 1
    end
    local ok, pagesize = pcall(tonumber, pagesize)
    if not ok then
        pagesize = 15
    end
    local attachments = attachment.search(params, page, pagesize)
    if attachments then

        self.json(200, '获取成功', attachments)
    else
        self.json(5003, "获取失败")
    end
end


local function check_form(self, action)
    local posts = self:post()
    local params = {}
    posts = posts and posts or {}
    if func.is_empty_str(posts.title)  then
        self.json(5001, "请输入附件名称")
    end
    params.title = posts.title
    if func.is_empty_str(posts.url)  then
        self.json(5002, "请输入附件链接")
    end
    params.remark = posts.remark
    params.status = 1
    params.weight = posts.weight
    if func.is_empty_str(posts.fileInfoExt) ~= true then
        local ok, ext = pcall(cjson.decode, posts.fileInfoExt)
        if ok then
            params.file_id = ext.fileId
        end
    end
    return params
end

function _M.add(self)
    local tab = self:get('tab')
    if func.is_empty_str(tab) then
        tab = 'normal'
    end
    if self:is_post() then
        local posts = check_form(self)
        local info, err = attachment.save(posts)
        if info then
            self.json(200, '添加成功', {url = '/admin/attachment/index'})
        else
            self.json(5003, "添加失败")
        end
    else
        self:assign('title', '添加附件')
        self:assign('tab', tab)
        self:display()
    end
end

function _M.edit(self)
    if self:is_post() then
        local posts = self:post()
        if func.is_empty_str(posts.fileId)  then
            self.json(5005, '请选择要编辑的文件')
        end
        local ok ,id = pcall(tonumber, posts.fileId)
        if not ok then
            self.json(5005, '请选择要编辑的文件')
        end
        posts.file_id = id
        posts.fileId = nil
        posts.media_type = posts.mediaType
        posts.mediaType = nil
        local info, err = attachment.save(posts)
        if info then
            self.json(200, '修改成功', {url = '/admin/attachment/index'})
        else
            self.json(5003, "修改失败"..err)
        end
    else
        local info
        local err
        local id = self:get('id')
        if func.is_empty_str(id) then
            err = "请选择要编辑的附件"
        else
            local ok, attachmentId = pcall(tonumber, id)
            if not ok then
                err = "请选择合法的附件"
            else
                info = attachment.detail(attachmentId)
                if not info then
                    err = "未查询到相应的附件信息"
                end
            end
        end

        self:assign('title', '编辑附件')
        self:assign('info', info)
        self:assign('error', err)
        self:display()
    end
end

function _M.delete(self)
    local id = self:post('id')
    if func.is_empty_str(id) then
        self.json(5005, '请选择要删除的附件')
    end
    local ok, attachmentId = pcall(tonumber, id)
    if not ok then
        self.json(5008, "请选择合法的附件")
    end

    local status, err = attachment.delete(attachmentId)
    if not status then
        self.json(6002, '删除失败,'..err)
    else
        self.json(200, '删除成功', {url = '/admin/attachment/index'})
    end
end

return _M