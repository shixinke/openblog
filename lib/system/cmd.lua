local _M = {
    _VERSION = '0.01'
}

local popen = io.popen

local function exec_cmd(command, multi, mode)
    local file, err = popen(command, mode)
    if not file then
        return nil, err
    end
    local result
    if multi then
        result = {}
        for line in file:lines() do
            result[#result + 1] = line
        end
    else
        result = file:read('*all')
    end
    file:close()
    return result
end

function _M.exec(command, multi, mode)
    return exec_cmd(command, multi, mode)
end

return _M