load("//tools:clang.bzl", "clang_tool")
load("@bazel-compilation-database//:aspects.bzl", "compilation_database")

clang_tool("clang-format")

clang_tool("clang-tidy")

compilation_database(
    name = "compile_commands_json",
    testonly = True,
    targets = [
        # BEGIN compile_commands targets
        "//main:sandbox",
        "//parser:lexer_exe",
        # END compile_commands targets
    ],
)

