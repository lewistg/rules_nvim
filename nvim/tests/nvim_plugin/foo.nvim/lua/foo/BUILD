load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "foo",
    srcs = [
        "init.lua",
    ],
    visibility = [
        "//nvim/tests/nvim_plugin:__subpackages__"
    ]
)
