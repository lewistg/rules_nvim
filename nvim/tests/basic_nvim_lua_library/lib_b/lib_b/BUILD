load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "lib_b",
    srcs = ["b.lua"],
    lua_path_root = "//nvim/tests/basic_nvim_lua_library/lib_b:lua_path_root",
    visibility = ["//nvim/tests/basic_nvim_lua_library:__subpackages__"],
    deps = [
        "//nvim/tests/basic_nvim_lua_library/lib_c/lib_c",
    ],
)
