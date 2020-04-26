BAZEL_VERSION = "3.1.0"

workspace(name = "io_jez_sandbox")

load("//third_party:externals.bzl", "sandbox_register_dependencies")
sandbox_register_dependencies()

load("@com_grail_bazel_toolchain//toolchain:deps.bzl", "bazel_toolchain_dependencies")
bazel_toolchain_dependencies()

load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "llvm_toolchain")
llvm_toolchain(
    name = "llvm_toolchain",
    absolute_paths = True,
    llvm_version = "9.0.0",
)

load("@rules_ragel//ragel:ragel.bzl", "ragel_register_toolchains")
ragel_register_toolchains()

load("@rules_m4//m4:m4.bzl", "m4_register_toolchains")
m4_register_toolchains()

load("@rules_flex//flex:flex.bzl", "flex_register_toolchains")
flex_register_toolchains()

load("@rules_bison//bison:bison.bzl", "bison_register_toolchains")
bison_register_toolchains()


BAZEL_INSTALLER_VERSION_darwin_SHA = "5cfa97031b43432b3c742c80e2e01c41c0acdca7ba1052fc8cf1e291271bc9cd"
# TODO(jez) Test on linux
BAZEL_INSTALLER_VERSION_linux_SHA = "0"
