load("@rules_ragel//ragel:ragel.bzl", "ragel")
load("@rules_bison//bison:bison.bzl", "bison")

ragel(
    name = "lexer_impl_ragel",
    src = "lexer_impl_ragel.rl",
    language = "c++",
)

bison(
    name = "parser_impl",
    src = "parser_impl.yy",
    bison_options = [],
)

cc_library(
    name = "parser",
    srcs = [
        "token.hh",
        "lexer.hh",
        ":lexer_impl_ragel",
        "node.hh",
        "driver.hh",
        "driver.cc",
        ":parser_impl",
    ],
#     hdrs = glob(["*.h", "*.hh"]),
    copts = [
        "-Wno-unused-const-variable",
    ],
    visibility = ["//visibility:public"],
)
