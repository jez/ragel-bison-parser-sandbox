load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

# We define our externals here instead of directly in WORKSPACE so that
# libraries can pin to our versions.
def sandbox_register_dependencies():
    http_archive(
        name = "com_grail_bazel_toolchain",
        url = "https://github.com/grailbio/bazel-toolchain/archive/0.5.zip",
        sha256 = "33011cd77021017294d1982b48d0c3a081c777b9aad9a75f3e4eada0e10894d1",
        strip_prefix = "bazel-toolchain-0.5",
    )

    http_archive(
        name = "com_google_absl",
        url = "https://github.com/abseil/abseil-cpp/archive/62f05b1f57ad660e9c09e02ce7d591dcc4d0ca08.zip",
        sha256 = "afcab9f226ac4ca6b6b7c9ec704a995fe32a6b555d6935b0de247ae6ac6940e0",
        strip_prefix = "abseil-cpp-62f05b1f57ad660e9c09e02ce7d591dcc4d0ca08",
    )

    http_archive(
        name = "rules_ragel",
        url = "https://github.com/jmillikin/rules_ragel/archive/f99f17fcad2e155646745f4827ac636a3b5d4d15.zip",
        sha256 = "f957682c6350b2e4484c433c7f45d427a86de5c8751a0d2a9836f36995fe0320",
        strip_prefix = "rules_ragel-f99f17fcad2e155646745f4827ac636a3b5d4d15",
    )

    # Required by rules_flex and rules_bison
    http_archive(
        name = "rules_m4",
        url = "https://github.com/jmillikin/rules_m4/releases/download/v0.2/rules_m4-v0.2.tar.xz",
        sha256 = "c67fa9891bb19e9e6c1050003ba648d35383b8cb3c9572f397ad24040fb7f0eb",
    )

    http_archive(
      name = "rules_flex",
      urls = ["https://github.com/jmillikin/rules_flex/releases/download/v0.2/rules_flex-v0.2.tar.xz"],
      sha256 = "f1685512937c2e33a7ebc4d5c6cf38ed282c2ce3b7a9c7c0b542db7e5db59d52",
    )

    http_archive(
        name = "rules_bison",
        url = "https://github.com/jmillikin/rules_bison/releases/download/v0.2/rules_bison-v0.2.tar.xz",
        sha256 = "6ee9b396f450ca9753c3283944f9a6015b61227f8386893fb59d593455141481",
    )




    # TODO(jez) Useful common dependencies
    # TODO(jez) BUILD formatters
    # TODO(jez) C/C++ formatters
    # TODO(jez) compile_commands.json
    # TODO(jez) jemalloc
    # TODO(jez) spdlog / fmt
    # TODO(jez) rapidjson
    # TODO(jez) pdqsort

