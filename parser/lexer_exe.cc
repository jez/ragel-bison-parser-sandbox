#include <cstdio>
#include "parser/token.hh"

using namespace std;

// TODO(jez) Move this to a header file
#include <string>
#include <vector>
#include <memory>
vector<unique_ptr<Token>> all_tokens(string_view source);

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("usage: lexer_exe <program>");
        return 1;
    }

    string_view source = argv[1];
    auto tokens = all_tokens(source);

    printf("tokens.size() = %lu\n[\n", tokens.size());
    for (auto &token : tokens) {
        printf("  %s,\n", token->showRaw().c_str());
    }
    printf("]\n");
    return 0;
}
