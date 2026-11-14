load("//nvim:defs.bzl", "nvim_environment", "nvim_lua_binary", "nvim_lua_test")

nvim_environment(
    name = "nvim_env",
    plugins = [
        "//nvim/tests/nvim_plugin/foo.nvim",
    ],
)

nvim_lua_test(
    name = "specs",
    srcs = glob(["*_spec.lua"]),
    data = [
        ":nvim_env",
    ],
    deps = [
        "//nvim/lua/rules_nvim/nvim_environment",
    ],
)
