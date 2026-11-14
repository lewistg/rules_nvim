describe('nvim_environment', function()
  it('loads plugins from the nvim_environment', function()
    local rlocation = require('rules_nvim.rlocation')

    local nvim_bin = rlocation.rlocation('nvim/bin/nvim')

    local nvim_environment = require('rules_nvim.nvim_environment')
    local xdg_env_vars = nvim_environment.set_up_nvim_environment('nvim_env')

    local nvim_channel = vim.fn.jobstart({ nvim_bin, '--embed' }, {
      rpc = true,
      env = xdg_env_vars,
    })

    local greeting =
      vim.rpcrequest(nvim_channel, 'nvim_exec_lua', 'return require("foo").greeting', {})

    assert.equal('hello', greeting)
  end)
end)
