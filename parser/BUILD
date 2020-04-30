load("@rules_ragel//ragel:ragel.bzl", "ragel")
load("@rules_flex//flex:flex.bzl", "flex")
load("@rules_bison//bison:bison.bzl", "bison")

ragel(
    name = "lexer_impl_ragel",
    src = "lexer_impl_ragel.rl",
    language = "c++",
)

# flex(
#     name = "lexer_impl_flex",
#     src = "lexer_impl_flex.ll",
#     flex_options = [],
# )

# bison(
#     name = "parser_impl",
#     src = "parser_impl.yy",
#     bison_options = [],
# )

cc_binary(
    name = "lexer_exe",
    # TODO(jez) Eventually just use globs
    srcs = [
        "token.hh",
        "lexer.hh",
        "lexer_exe.cc",
        ":lexer_impl_ragel",
    ],
    copts = [
        "-Wno-unused-const-variable",
    ],
    visibility = ["//visibility:public"],
  )

# cc_library(
#     name = "parser",
#     srcs = glob(["*.cc"]) + [
#         ":lexer_impl_flex",
#         ":parser_impl",
#     ],
#     hdrs = glob(["*.h", "*.hh"]),
#     copts = [
#         "-Wno-unused-const-variable",
#     ],
#     # TODO(jez) linkstatic conditionally
#     # linkstatic = select({
#     #     "@com_stripe_ruby_typer//tools/config:linkshared": 0,
#     #     "//conditions:default": 1,
#     # }),
#     visibility = ["//visibility:public"],
# )

