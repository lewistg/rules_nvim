load("//nvim:defs.bzl", "nvim_lua_library")

nvim_lua_library(
    name = "runner",
    srcs = ["init.lua"],
    visibility = [
        "//visibility:public",
    ],
    deps = [
        "//nvim/lua/rlocation",
        "//nvim/lua/rules_nvim_test/suite",
    ],
)

exports_files(["entry_point.lua"])
