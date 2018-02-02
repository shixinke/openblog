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
local type = type
local gsub = string.gsub



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

local function upload()
    local file
    local file_name
    local form = upload:new(chunk_size)
    local conf = {max_size = 1000000, allow_exts = {'jpg', 'png', 'gif'}}
    while true do
        local typ, res, err = form:read()
        if typ == "header" then
            if res[1] ~= "Content-Disposition" then

                local file_id = md5('upload'..os.time())
                local extension = get_ext(res[2])

                if not extension then
                    return nil, nil, '未获取文件后缀'
                end

                if not func.in_array(extension, conf.allow_exts) then
                    return nil, nil, '不支持该文件格式'
                end

                local dir = '/uploads/images/avatar/'..os_date('%Y')..'/'..os_date('%m')..'/'..os_date('%d')..'/'
                local status = os_exec('mkdir -p '..dir)
                if status ~= 0 then
                    return nil, nil, '创建目录失败'
                end
                file_name = dir..file_id.."."..extension
                if file_name then
                    file = io_open(file_name, "w+")
                    if not file then
                        return nil, nil, '打开文件失败'
                    end
                end
            end
        elseif typ == "body" then
            if type(tonumber(res)) == 'number' and tonumber(res) > conf.max_size then
                return nil, nil, '文件超过规定大小'
            end
            if file then
                file:write(res)
            end
        elseif typ == "part_end" then
            if file then
                file:close()
                file = nil
            end
        elseif typ == "eof" then
            file_name = gsub(file_name, '/uploads/', '')
            return file_name
        else

        end
    end
end

function _M.avatar()
    ngx.say("avatar")
end


return _M