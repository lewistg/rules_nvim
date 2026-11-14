load(":nvim_lua_info.bzl", "NvimLuaInfo")
load(":nvim_lua_path_root.bzl", "NvimLuaPathRoot")

def _nvim_lua_library_impl(ctx):
    sources = depset(
        ctx.files.srcs,
        transitive = [dep[NvimLuaInfo].sources for dep in ctx.attr.deps],
    )

    transitive_lua_path_roots = [
        dep[NvimLuaInfo].lua_path_roots
        for dep in ctx.attr.deps
    ]
    lua_path_roots = depset(
        [ctx.attr.lua_path_root],
        transitive = transitive_lua_path_roots,
    )

    return [
        DefaultInfo(files = sources),
        NvimLuaInfo(
            sources = sources,
            lua_path_roots = lua_path_roots,
        ),
    ]

nvim_lua_library = rule(
    implementation = _nvim_lua_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".lua"],
        ),
        "deps": attr.label_list(
            providers = [NvimLuaInfo],
        ),
        "lua_path_root": attr.label(
            providers = [NvimLuaPathRoot],
            mandatory = True,
        ),
    },
)
