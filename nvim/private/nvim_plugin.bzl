load(":nvim_lua_info.bzl", "NvimLuaInfo")
load(":nvim_plugin_info.bzl", "NvimPluginInfo")

def _nvim_plugin_impl(ctx):
    lua_sources = []
    for dep in ctx.attr.deps:
        if NvimLuaInfo in dep:
            lua_sources.append(dep[NvimLuaInfo].sources)

    other_sources = [dep[DefaultInfo].files for dep in ctx.attr.deps]

    return [
        NvimPluginInfo(
            sources = depset(None, transitive = lua_sources + other_sources),
        ),
    ]

nvim_plugin = rule(
    implementation = _nvim_plugin_impl,
    attrs = {
        "deps": attr.label_list(
            allow_files = True,
        ),
    },
)
