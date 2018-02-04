local _M = {_VERSION = '0.01' }
local attachment = require 'models.attachment':new()
local os_remove = os.remove
local ngx_var = ngx.var



function _M.upload(file_info)
    local id, err = attachment:add(file_info)
    if id then
        return id
    else
        return nil, '上传失败'..err
    end
end

function _M.remove(file_id, uid)
   local file_info = attachment:fields({'uid', 'path'}):where({file_id = file_id}):find()
    if not file_info or not file_info['uid'] then
        return nil, '文件不存在'
    end
    if uid and uid ~= file_info['uid'] then
        return nil, '没有权限'
    end
    local rows = attachment:remove(file_id)
    if rows and rows > 0 then
        return _M.remove_file(file_info['path'])
    else
        return nil, '删除失败'
    end
end

function _M.remove_file(path)
    local path = ngx_var.document_root..path
    local ok, err = os_remove(path)
    if not ok then
        return nil, '删除失败'
    end
    return true
end

return _M