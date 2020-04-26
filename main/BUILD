cc_binary(
    name = "sandbox",
    srcs = [
        "main.cc"
    ],
    # TODO(jez) linkstatic conditionally
    # linkstatic = select({
    #     "@com_stripe_ruby_typer//tools/config:linkshared": 0,
    #     "//conditions:default": 1,
    # }),
    # TODO(jez) jemalloc conditionally
    visibility = ["//visibility:public"],
    deps = [
        "//parser",
    ]
)
