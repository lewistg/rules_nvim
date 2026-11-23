local M = {}

-- Note: This library was loosely based off the Java runfiles library [1].
--
-- [1]: https://github.com/bazelbuild/rules_java/blob/master/java/runfiles/src/main/java/com/google/devtools/build/runfiles/Runfiles.java#L426

local RUNFILES_DIR = os.getenv('RUNFILES_DIR')
if RUNFILES_DIR == nil then
  error('RUNFILES_DIR environment variable is not set')
end

---@type {[string]: {[string]: string}}
local REPO_MAPPING

---@param key {source_repo: string, apparent_repo_name: string}
---@return string|nil
local function get_canonical_repo_name(key)
  if REPO_MAPPING == nil then
    REPO_MAPPING = {
      ['_main'] = {
        ['_main'] = '_main',
      },
    }
    local lines = vim.fn.readfile(vim.fs.joinpath(RUNFILES_DIR, '_repo_mapping'))
    vim.iter(lines):each(function(line)
      -- source_repo: The canonical name of the source repo
      -- apparent_repo_name: The apparent name of the repo within the context of the source repo
      -- canonical_repo_name: The canonical name of the repo name
      local source_repo, apparent_repo_name, canonical_repo_name = unpack(vim.split(line, ','))

      if source_repo == '' then
        source_repo = '_main'
      end

      if source_repo == nil or apparent_repo_name == nil or canonical_repo_name == nil then
        error('Invalid _repo_mapping entry: ' .. line)
      end

      if REPO_MAPPING[source_repo] == nil then
        REPO_MAPPING[source_repo] = {}
      end
      REPO_MAPPING[source_repo][apparent_repo_name] = canonical_repo_name
    end)
  end
  return vim.tbl_get(REPO_MAPPING, key.source_repo, key.apparent_repo_name)
end

---@param path string
---@param source_repo string | nil
---@return string
function M.rlocation(path, source_repo)
  source_repo = source_repo or '_main'

  local segments = vim.split(path, '/')
  local apparent_repo_name = segments[1]

  local canonical_repo_name =
    get_canonical_repo_name({ source_repo = source_repo, apparent_repo_name = apparent_repo_name })
  if canonical_repo_name ~= nil then
    segments[1] = canonical_repo_name
  end

  return vim.fs.joinpath(RUNFILES_DIR, unpack(segments))
end

---@return string
function M.get_nvim_bin()
  local nvim_bin = os.getenv('RULES_NVIM_NVIM_BIN')
  if nvim_bin == nil then
    error('The RULES_NVIM_NVIM_BIN environment variable is not set')
  end
  return nvim_bin
end

--- This method performs a "deep" copy of a runfile directory. This is useful
--- if you have some runfile directory you would like to use as a test fixture,
--- and you also need to write to that directory. It breaks hermeticity to
--- write to runfiles, so you would use this method to copy the directory
--- somwhere else first.
function M.copy_runfile_dir(src_dir, dest_dir)
  src_dir = vim.fs.abspath(src_dir)

  if not vim.fn.isdirectory(vim.fn.resolve(src_dir)) then
    error(tostring(src_dir) .. ' is not a directory')
  end

  src_dir = vim.fs.abspath(src_dir)
  local src_dir_name = vim.fs.basename(src_dir)

  local function copy_file(name, path)
    local full_path = vim.fs.joinpath(path, name)

    local rel_path = vim.fs.relpath(src_dir, full_path)
    local dest_file = vim.fs.joinpath(dest_dir, src_dir_name, rel_path)

    local real_full_path = vim.fn.resolve(full_path)
    if vim.fn.isdirectory(real_full_path) == 1 then
      vim.fn.mkdir(dest_file, 'p')
    else
      local dest_file_dir = vim.fs.dirname(dest_file)
      if string.len(dest_file_dir) > 0 then
        vim.fn.mkdir(dest_file_dir, 'p')
      end
      -- We want to copy the real file and not the symlink
      vim.fn.filecopy(real_full_path, dest_file)
    end
  end

  vim.fs.find(copy_file, { limit = math.huge, type = 'directory', path = src_dir })
  vim.fs.find(copy_file, { limit = math.huge, type = 'file', path = src_dir })
  vim.fs.find(copy_file, { limit = math.huge, type = 'link', path = src_dir })

  return vim.fs.joinpath(dest_dir, src_dir_name)
end

return M
