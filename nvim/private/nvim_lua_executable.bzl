load(":nvim_lua_info.bzl", "NvimLuaInfo")
load(":rlocation_util.bzl", "get_rlocation_path")

BASE_EXECUTABLE_RULE_ATTRS = {
    "entry_point": attr.label(
        allow_single_file = True,
        mandatory = True,
    ),
    "entry_point_args": attr.label(
        allow_single_file = True,
    ),
    "srcs": attr.label_list(
        allow_files = [".lua"],
    ),
    "deps": attr.label_list(
        providers = [NvimLuaInfo],
    ),
    "data": attr.label_list(
        allow_files = True,
    ),
    "_nvim_bin_runner_template": attr.label(
        allow_single_file = True,
        default = ":nvim_lua.sh.tpl",
    ),
    "_runfiles_lib": attr.label(
        default = "@rules_shell//shell/runfiles",
    ),
}

def _nvim_lua_executable_impl(ctx):
    # We pick one of rules_nvim's internal source files to introspect and get
    # rule_nvim's own canoncial name.
    rules_nvim_canonical_repo_name = ctx.attr._nvim_bin_runner_template.label.repo_name

    entry_point_args = get_rlocation_path(ctx.file.entry_point_args) if ctx.file.entry_point_args else ""

    lua_path_deps = depset(transitive = [
        dep[NvimLuaInfo].lua_path_roots
        for dep in ctx.attr.deps
    ])
    lua_paths = [
        (target.label.repo_name or "_main") + "/" + target.label.package
        for target in lua_path_deps.to_list()
    ]

    nvim_info = ctx.toolchains["//nvim/private/nvim_binary_toolchain:toolchain_type"].nvim_info

    runner = ctx.actions.declare_file(ctx.label.name + "_runner.sh")
    ctx.actions.expand_template(
        template = ctx.file._nvim_bin_runner_template,
        output = runner,
        substitutions = {
            "{{NVIM_BIN}}": get_rlocation_path(nvim_info.nvim_bin),
            "{{ENTRY_POINT}}": get_rlocation_path(ctx.file.entry_point),
            "{{ENTRY_POINT_ARGS}}": entry_point_args,
            "{{LUA_PATH_ROOTS}}": "\n".join(lua_paths),
            "{{RULES_NVIM_SOURCE_REPO}}": rules_nvim_canonical_repo_name,
        },
    )

    dep_sources = depset(None, transitive = [dep[NvimLuaInfo].sources for dep in ctx.attr.deps])

    files = [
        ctx.file.entry_point,
        nvim_info.nvim_bin,
    ] + ctx.files.srcs + ctx.files.data
    if ctx.file.entry_point_args:
        files.append(ctx.file.entry_point_args)

    runfiles = ctx.runfiles(files = files, transitive_files = dep_sources)
    runfiles = runfiles.merge(ctx.attr._runfiles_lib[DefaultInfo].default_runfiles)

    for datum in ctx.attr.data:
        transitive_runfiles = datum[DefaultInfo] and datum[DefaultInfo].default_runfiles
        if transitive_runfiles:
            runfiles = runfiles.merge(transitive_runfiles)

    return [DefaultInfo(
        executable = runner,
        runfiles = runfiles,
    )]

def nvim_lua_executable_rule(test = False):
    return rule(
        implementation = _nvim_lua_executable_impl,
        attrs = BASE_EXECUTABLE_RULE_ATTRS,
        executable = True,
        test = test,
        toolchains = [
            "//nvim/private/nvim_binary_toolchain:toolchain_type",
        ],
    )
