load("@bazel_skylib//lib:paths.bzl", "paths")
load(":nvim_plugin_info.bzl", "NvimPluginInfo")

def _nvim_environment_impl(ctx):
    runfile_symlinks = {}

    root = "nvim_environment_" + ctx.label.name
    empty_dir = ctx.actions.declare_directory(root + "_empty_dir")
    ctx.actions.run_shell(
        outputs = [empty_dir],
        command = "mkdir $1",
        arguments = [empty_dir.basename],
    )

    # XDG_STATE_HOME
    runfile_symlinks[paths.join(root, ".local/state/nvim")] = empty_dir

    # XDG_DATA_HOME
    xdg_data_home = paths.join(root, ".local/share")
    plugin_sources = []
    if len(ctx.attr.plugins) == 0:
        runfile_symlinks[paths.join(root, ".local/share/nvim")] = empty_dir
    else:
        for plugin in ctx.attr.plugins:
            sources = plugin[NvimPluginInfo].sources
            plugin_sources += [sources]
            runfile_symlinks |= _create_plugin_symlinks(xdg_data_home, plugin, sources)

    # XDG_CONFIG_HOME
    # TODO

    runfiles = ctx.runfiles(
        transitive_files = depset(transitive = plugin_sources),
        root_symlinks = runfile_symlinks,
    )

    return [
        DefaultInfo(
            files = depset([empty_dir]),
            runfiles = runfiles,
        ),
    ]

def _create_plugin_symlinks(xdg_data_home, plugin, files):
    symlinks = {}
    for file in files.to_list():
        relative_path = paths.relativize(file.path, plugin.label.package)
        symlink_path = paths.join(
            xdg_data_home,
            "nvim/site/pack/plugins/start",
            plugin.label.name,
            relative_path,
        )
        symlinks[symlink_path] = file
    return symlinks

nvim_environment = rule(
    implementation = _nvim_environment_impl,
    doc = "Generates a runfile directory with the various XDG directories Neovim uses. This can be used to create an isolated execution environment for Neovim. A common use case is E2E tests.",
    attrs = {
        "plugins": attr.label_list(
            providers = [NvimPluginInfo],
        ),
        "config": attr.label_list(),
    },
)
