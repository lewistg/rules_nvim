load("@rules_shell//shell:sh_test.bzl", "sh_test")
load("//nvim:defs.bzl", "nvim_lua_binary", "nvim_lua_path_root")

nvim_lua_binary(
    name = "basic_nvim_lua_library",
    entry_point = "main.lua",
    lua_path_roots = [
        "//nvim/tests/basic_nvim_lua_library/lib_a:path_root",
        "//nvim/tests/basic_nvim_lua_library/lib_b:path_root",
        # TODO: The nvim_lua_binary should not have to know the lua path roots
        # of its transitive dependencies.
        "//nvim/tests/basic_nvim_lua_library/lib_c:path_root",
    ],
    deps = [
        "//nvim/tests/basic_nvim_lua_library/lib_a/lib_a",
        "//nvim/tests/basic_nvim_lua_library/lib_b/lib_b",
    ],
)

sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [":basic_nvim_lua_library"],
)
