load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "lib_a",
    srcs = ["a.lua"],
    lua_path_root = "//nvim/tests/basic_nvim_lua_library/lib_a:lua_path_root",
    visibility = ["//nvim/tests/basic_nvim_lua_library:__subpackages__"],
)
