load("@rules_ragel//ragel:ragel.bzl", "ragel")
load("@rules_bison//bison:bison.bzl", "bison")

ragel(
    name = "lexer",
    src = "lexer.rl",
    language = "c++",
)

bison(
    name = "parser_impl",
    src = "parser_impl.yy",
    bison_options = [],
)

cc_library(
    name = "parser",
    srcs = glob(["*.hh", "*.cc"]) + [
        ":lexer",
        ":parser_impl",
    ],
    hdrs = glob(["parser.hh"]),
    copts = [
        "-Wno-unused-const-variable",
    ],
    deps = [
        "//core"
    ],
    visibility = ["//visibility:public"],
)
