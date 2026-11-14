load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "nvim_environment",
    srcs = ["init.lua"],
    lua_path_root = "//nvim/lua:lua_path_root",
    visibility = [
        "//nvim/lua/rlocation",
        "//visibility:public",
    ],
)
