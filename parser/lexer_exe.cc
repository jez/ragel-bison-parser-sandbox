#include <cstdio>
#include "parser/lexer.hh"

using namespace std;

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("usage: lexer_exe <program>");
        return 1;
    }

    string_view source = argv[1];
    sandbox::parser::Lexer lexer(source);
    auto tokens = lexer.allTokens();

    printf("tokens.size() = %lu\n[\n", tokens.size());
    for (auto &token : tokens) {
        printf("  %s,\n", token->showRaw().c_str());
    }
    printf("]\n");
    return 0;
}
