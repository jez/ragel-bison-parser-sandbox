#include <string>
#include <vector>
#include <memory>

// TODO(jez) Parser will generate functions to make tokens;
// need to use them here, instead of our own constructors.
#include "parser/token.hh"

using namespace std;

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

vector<unique_ptr<Token>> all_tokens(string_view source) {
    vector<unique_ptr<Token>> tokens;

    int cs = 0;

    // Used by ragel to keep track of the input
    auto p = source.begin();
    auto pe = source.end();
    auto eof = source.end();

    // For accessing the match text from within the actions.
    auto ts = source.begin();
    auto te = source.begin();

    // TODO(jez) why? Something to do with scanners
    int act = 0;

    %% write init;
    %% write exec;

    return tokens;
}
