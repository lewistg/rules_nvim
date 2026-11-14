load("@rules_shell//shell:sh_test.bzl", "sh_test")
load("//nvim:defs.bzl", "nvim_lua_binary")

nvim_lua_binary(
    name = "basic_nvim_lua_binary",
    entry_point = "main.lua",
)

# Run the binary launcher as a test
# Pattern taken from Aspect's rules_py (see https://github.com/aspect-build/rules_py/tree/v2.0.0-alpha.10/py/tests/data-files)
sh_test(
    name = "test",
    srcs = ["test.sh"],
    data = [":basic_nvim_lua_binary"],
)

nvim_lua_binary(
    name = "basic_nvim_lua_binary_with_data",
    data = [
        "data.txt",
    ],
    entry_point = "read_data_file.lua",
    lua_path_roots = [
        "//nvim/lua:lua_path_root",
    ],
    deps = [
        "//nvim/lua/rlocation",
    ],
)

sh_test(
    name = "basic_nvim_lua_binary_with_data_test",
    srcs = ["read_data_file_test.sh"],
    data = [
        ":basic_nvim_lua_binary_with_data",
    ],
)
