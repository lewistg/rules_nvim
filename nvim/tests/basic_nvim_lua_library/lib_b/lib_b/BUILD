load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "lib_b",
    srcs = ["b.lua"],
    visibility = ["//nvim/tests/basic_nvim_lua_library:__subpackages__"],
    deps = [
        "//nvim/tests/basic_nvim_lua_library/lib_c/lib_c",
    ],
)
