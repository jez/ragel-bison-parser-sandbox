#include "spdlog/spdlog.h"

#include "parser/parser.hh"

using namespace std;

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fmt::print("usage: sandbox <program>\n");
        return 1;
    }

    string_view source = argv[1];
    fmt::print("input:  {}\n", source);

    auto result = sandbox::parser::parse(source);
    if (result == nullptr) {
        return 1;
    }

    fmt::print("output: {}\n", result->showRaw());

    return 0;
}
