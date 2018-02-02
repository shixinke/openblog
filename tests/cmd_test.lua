local cmd = require 'system.cmd'



local function test_pwd()
    ngx.say('获取当前目录:')
    ngx.say(cmd.pwd())
end

local function test_memory()
    ngx.say('memory:')
    ngx.say(#cmd.memory())
end

local function test()
    -- test_pwd()
    test_memory()
end

test()