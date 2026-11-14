local M = {}

local TEST_TMPDIR = os.getenv('TEST_TMPDIR')

function M.set_up_nvim_environment(nvim_environment_target_name)
  -- Note: This prefix must be kept in sync with the nvim_environment rule
  -- definition (see nvim_environment.bzl)
  local runfile_dir = 'nvim_environment_' .. nvim_environment_target_name

  local rlocation = require('rlocation')
  local environment_root = rlocation.rlocation(runfile_dir)

  if not vim.fn.isdirectory(environment_root) then
    error(
      string.format(
        'Unable to find runfile directory for nvim_environment target "%s". Tried path: "%s"',
        nvim_environment_target_name,
        runfile_dir
      )
    )
  end

  local basename = vim.fs.basename(environment_root)

  rlocation.copy_runfile_dir(environment_root, TEST_TMPDIR)

  local root = vim.fs.joinpath(TEST_TMPDIR, basename)
  local xdg_config = vim.fs.joinpath(root, '.config')
  local xdg_state = vim.fs.joinpath(root, '.local/state')
  local xdg_data = vim.fs.joinpath(root, '.local/share')

  return {
    XDG_CONFIG_HOME = xdg_config,
    XDG_DATA_HOME = xdg_data,
    XDG_STATE_HOME = xdg_state,
  }
end

return M
