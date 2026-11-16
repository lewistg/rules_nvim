NvimInfo = provider(
    doc = "Information about nvim binary",
    fields = {
        "nvim_bin": "The binary file"
    }
)

def _nvim_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        nvim_info = NvimInfo(nvim_bin = ctx.file.nvim_bin)
    )
    return [toolchain_info]

nvim_toolchain = rule(
    implementation = _nvim_toolchain_impl,
    attrs = {
        "nvim_bin": attr.label(
            allow_single_file = True,
            executable = True,
            mandatory = True,
            cfg = "target"
        )
    }
)
