load("//nvim/private:nvim_environment.bzl", _nvim_environment = "nvim_environment")
load("//nvim/private:nvim_lua_binary.bzl", _nvim_lua_binary = "nvim_lua_binary")
load("//nvim/private:nvim_lua_library.bzl", _nvim_lua_library = "nvim_lua_library")
load("//nvim/private:nvim_lua_path_root.bzl", _nvim_lua_path_root = "nvim_lua_path_root")
load("//nvim/private:nvim_lua_test.bzl", _nvim_lua_test = "nvim_lua_test")
load("//nvim/private:nvim_plugin.bzl", _nvim_plugin = "nvim_plugin")

nvim_lua_binary = _nvim_lua_binary

nvim_lua_test = _nvim_lua_test

nvim_environment = _nvim_environment

nvim_lua_library = _nvim_lua_library

nvim_lua_path_root = _nvim_lua_path_root

nvim_plugin = _nvim_plugin
