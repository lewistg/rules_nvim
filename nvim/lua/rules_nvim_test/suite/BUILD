load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "suite",
    srcs = glob(["*.lua"]),
    lua_path_root = "//nvim/lua:lua_path_root",
    visibility = [
        "//visibility:public",
    ],
)
