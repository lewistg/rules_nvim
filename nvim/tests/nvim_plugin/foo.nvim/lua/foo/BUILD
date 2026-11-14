load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "foo",
    srcs = [
        "init.lua",
    ],
    lua_path_root = "//nvim/tests/nvim_plugin/foo.nvim/lua:lua_path_root",
    visibility = [
        "//nvim/tests/nvim_plugin:__subpackages__",
    ],
)
