#include <cstring>
#include <cstdio>
#include <string>
#include <vector>
#include <memory>

// TODO(jez) For debugging only
#include <typeinfo>

// TODO(jez) Parser will generate functions to make tokens;
// need to use them here, instead of our own constructors.
#include "parser/token.hh"

using namespace std;

// main := ( 'foo' | 'bar' ) %eof{ sawFooOrBar = true; };

// TODO(jez) Probably need to do locations myself?

%%{
    machine expr;
    main := |*
      space;

      "--" . [^\n]+ "\n";

      "\\"    {tokens.emplace_back(make_unique<TokBackslash>());};
      "->"    {tokens.emplace_back(make_unique<TokThinArrow>());};
      "let"   {tokens.emplace_back(make_unique<TokLet>());};
      "="     {tokens.emplace_back(make_unique<TokEq>());};
      "in"    {tokens.emplace_back(make_unique<TokIn>());};
      "True"  {tokens.emplace_back(make_unique<TokTrue>());};
      "False" {tokens.emplace_back(make_unique<TokFalse>());};
      "if"    {tokens.emplace_back(make_unique<TokIf>());};
      "ifz"   {tokens.emplace_back(make_unique<TokIfz>());};
      "then"  {tokens.emplace_back(make_unique<TokThen>());};
      "else"  {tokens.emplace_back(make_unique<TokElse>());};
      "\("    {tokens.emplace_back(make_unique<TokLParen>());};
      "\)"    {tokens.emplace_back(make_unique<TokRParen>());};

      "0"
        {tokens.emplace_back(make_unique<TokNumeral>("0"));};

      [1-9] [0-9]*
        {tokens.emplace_back(make_unique<TokNumeral>(string(ts, te - ts)));};

      lower ( alnum | "_" | "'" )*
        {tokens.emplace_back(make_unique<TokTermIdent>(string(ts, te - ts)));};
    *|;
}%%

%% write data;

int main(int argc, char **argv) {
    vector<unique_ptr<Token>> tokens;

    if (argc > 1) {
        string_view arg1 = argv[1];
        int cs = 0;

        // Used by ragel to keep track of the input
        auto p = arg1.begin();
        auto pe = arg1.end();
        auto eof = arg1.end();

        // For accessing the match text from within the actions.
        auto ts = arg1.begin();
        auto te = arg1.begin();

        // TODO(jez) why? Something to do with scanners
        int act = 0;

        %% write init;
        %% write exec;
    }

    printf("tokens.size() = %lu\n[\n", tokens.size());
    for (auto &token : tokens) {
        printf("  %s,\n", token->showRaw().c_str());
    }
    printf("]\n");
    return 0;
}
