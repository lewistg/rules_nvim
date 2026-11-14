load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "runner",
    srcs = ["init.lua"],
    lua_path_root = "//nvim/lua:lua_path_root",
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "//nvim/lua/rules_nvim/rlocation",
        "//nvim/lua/rules_nvim/test/suite",
    ],
)

exports_files(["entry_point.lua"])
