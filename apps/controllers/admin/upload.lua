local _M = {
    _VERSION = '0.01'
}

local upload = require "resty.upload"
local chunk_size = 4096
local os_exec = os.execute
local os_date = os.date
local md5 = ngx.md5
local io_open = io.open
local tonumber = tonumber
local gsub = string.gsub
local ngx_var = ngx.var
local ngx_req = ngx.req
local os_time = os.time
local attachment = require 'service.attachment'


local function get_ext(res)
    local ext = 'jpg'
    if res == 'image/png' then
        ext = 'png'
    elseif res == 'image/jpg' or res == 'image/jpeg' then
        ext = 'jpg'
    elseif res == 'image/gif' then
        ext = 'gif'
    end
    return ext
end

local function file_exists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end


local function uploadfile(conf)
    local file
    local file_name
    local form = upload:new(chunk_size)
    local root_path = ngx_var.document_root
    local file_info = {extension = '', filesize = 0, url = '', mime = '', fileId = '', filetype = 'image' }
    local content_len = ngx_req.get_headers()['Content-length']
    local body_size = content_len and tonumber(content_len) or 0
    if not form then
        return nil, '没有上传的文件'
    end
    if body_size > 0 and body_size > conf.max_size then
        return nil, '文件过大'
    end
    file_info.filesize = body_size
    while true do
        local typ, res, err = form:read()
        if typ == "header" then
            if res[1] == "Content-Type" then
                file_info.mime = res[2]
            elseif res[1] == "Content-Disposition" then

                local file_id = md5('upload'..os_time())
                local extension = get_ext(res[2])
                file_info.extension = extension

                if not extension then
                    return nil,  '未获取文件后缀'
                end

                if not func.in_array(extension, conf.allow_exts) then
                    return nil,  '不支持该文件格式'
                end
                local sub_dir = ''
                if conf.mode == 'date' then
                    sub_dir = os_date('%Y')..'/'..os_date('%m')..'/'..os_date('%d')..'/'
                end
                local dir = root_path..'/uploads/'..conf.path..'/'..sub_dir
                if file_exists(dir) ~= true then
                    local status = os_exec('mkdir -p '..dir)
                    if status ~= true then
                        return nil, '创建目录失败'
                    end
                end
                file_name = dir..file_id.."."..extension
                if file_name then
                    file = io_open(file_name, "w+")
                    if not file then
                        return nil, '打开文件失败'
                    end
                end
            end
        elseif typ == "body" then
            if file then
                file:write(res)
            end
        elseif typ == "part_end" then
            if file then
                file:close()
                file = nil
            end
        elseif typ == "eof" then
            file_name = gsub(file_name, root_path, '')
            file_info.url = file_name
            return file_info
        else

        end
    end
end

function _M.init(self)
    self.disabled_view = true
    self:check_login()
end

function _M.avatar(self)
    local user_info = self:get_login_info()
    local uid = user_info and user_info.uid or 0
    local nickname = user_info and user_info.nickname or user_info.account
    local conf = {max_size = 1000000, allow_exts = {'jpg', 'png', 'gif'}, path = 'images/avatar', mode = 'static' }
    local file_info, err = uploadfile(conf)
    if file_info then
        local attachment_data = {
            uid = uid,
            size = file_info.filesize,
            title = nickname..'的头像',
            path = file_info.url,
            mime_type = file_info.mime,
            relation_type = 2,
            relation_id = uid,
            remark = nickname..'的头像'
        }
        local file_id, err = attachment.upload(attachment_data)
        if file_id then
            file_info.fileId = file_id
            self.json(200, '上传成功', file_info)
        else
            attachment.remove_file(file_info.url)
            self.json(5008, '上传保存失败'..err)
        end

    else
        self.json(5003, err)
    end
end

function _M.posts(self)
    local user_info = self:get_login_info()
    local uid = user_info and user_info.uid or 0
    local conf = {max_size = 1000000, allow_exts = {'jpg', 'png', 'gif'}, path = 'images/posts', mode = 'static' }
    local file_info, err = uploadfile(conf)
    if file_info then
        local attachment_data = {
            uid = uid,
            size = file_info.filesize,
            title = '文章图片',
            path = file_info.url,
            mime_type = file_info.mime,
            relation_type = 1,
            relation_id = uid,
            remark = '文章图片'
        }
        local file_id, err = attachment.upload(attachment_data)
        if file_id then
            file_info.fileId = file_id
            self.json(200, '上传成功', file_info)
        else
            attachment.remove_file(file_info.url)
            self.json(5008, '上传保存失败'..err)
        end

    else
        self.json(5003, err)
    end
end

function _M.attach(self)
    local user_info = self:get_login_info()
    local uid = user_info and user_info.uid or 0
    local nickname = user_info and user_info.nickname or user_info.account
    local conf = {max_size = 1000000, allow_exts = {'jpg', 'png', 'gif'}, path = 'images/attach', mode = 'static' }
    local file_info, err = uploadfile(conf)
    if file_info then
        local attachment_data = {
            uid = uid,
            size = file_info.filesize,
            title = '通用图片',
            path = file_info.url,
            mime_type = file_info.mime,
            relation_type = 0,
            remark = '通用图片',
            relation_id = 0
        }
        local file_id, err = attachment.upload(attachment_data)
        if file_id then
            file_info.fileId = file_id
            self.json(200, '上传成功', file_info)
        else
            attachment.remove_file(file_info.url)
            self.json(5008, '上传保存失败'..err)
        end

    else
        self.json(5003, err)
    end
end

function _M.remove(self)
    local user_info = self:get_login_info()
    local uid = user_info and user_info.uid or 0
    local type = self:post('type')
    local file_id = self:post('fileId')
    if not type then
        self.json(6001, '请选择删除的文件类型')
    end
    if not file_id or file_id == '' then
        self.json(6002, '请选择删除的文件')
    end
    local status, err = attachment.remove(file_id, uid)
    if not status then
        self.json(5003, err)
    end
    self.json(200, "文件删除成功")
end


return _M