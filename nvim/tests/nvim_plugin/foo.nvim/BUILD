load("//nvim:defs.bzl", "nvim_plugin")

nvim_plugin(
    name = "foo.nvim",
    deps = [
        "//nvim/tests/nvim_plugin/foo.nvim/lua/foo",
    ],
    visibility = [
        "//nvim/tests/nvim_plugin:__subpackages__"
    ]
)
