local _M = {
    _VERSION = '0.01'
}

local popen = io.popen
local str_gmatch = string.gmatch
local tab_insert = table.insert
local tonumber = tonumber

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

function _M.memory()
    local lines =  exec_cmd('free -m', true)
    local tab = {
        total = 0,
        used = 0,
        free = 0,
        shared = 0,
        cache = 0,
        available = 0
    }
    if #lines >= 2 then
        local arr = {}
        for tmp in str_gmatch(lines[2], "%S+") do
            tab_insert(arr,tmp)
        end
        tab.total = arr[2] and tonumber(arr[2])
        tab.used = arr[3] and tonumber(arr[3])
        tab.free = arr[4] and tonumber(arr[4])
        tab.shared = arr[5] and tonumber(arr[5])
        tab.cache = arr[6] and tonumber(arr[6])
        tab.available = arr[7] and tonumber(arr[7])
        tab.unit = 'M'
    end
    return tab
end

function _M.disk()
    local lines =  exec_cmd('df -m', true)
    local tab = {}
    if #lines >= 2 then

        for i = 2, #lines do
            local arr = {}
            for tmp in str_gmatch(lines[i], "%S+") do
                tab_insert(arr,tmp)
            end
            tab[#tab + 1] = {
                fs = arr[1],
                blocks = arr[2],
                used = arr[3],
                available = arr[4],
                rate = arr[5],
                mounted = arr[6],
                unit = 'M'
            }
        end
    end
    return tab
end

function _M.uptime()
    return exec_cmd('uptime -s')
end

return _M