local rlocation = require('rlocation')
local data = rlocation.rlocation("_main/nvim/tests/basic_nvim_lua_binary/data.txt")
local lines = vim.fn.readfile(data)

io.write(lines[1])
