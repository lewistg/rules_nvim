load(":nvim_toolchain.bzl", "nvim_toolchain")

toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

nvim_toolchain(
    name = "nvim_linux",
    nvim_bin = "@nvim//:bin/nvim",
)

toolchain(
    name = "nvim_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":nvim_linux",
    toolchain_type = ":toolchain_type",
)
