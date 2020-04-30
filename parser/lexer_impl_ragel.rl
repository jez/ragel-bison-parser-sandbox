#include <string>
#include <vector>
#include <memory>

#include "parser/lexer.hh"

using namespace std;

// TODO(jez) Probably need to do locations myself?

%%{
    machine expr;
    main := |*
      space;

      "--" . [^\n]+ "\n";

      "\\"    { return make_unique<TokBackslash>(); };
      "->"    { return make_unique<TokThinArrow>(); };
      "let"   { return make_unique<TokLet>(); };
      "="     { return make_unique<TokEq>(); };
      "in"    { return make_unique<TokIn>(); };
      "True"  { return make_unique<TokTrue>(); };
      "False" { return make_unique<TokFalse>(); };
      "if"    { return make_unique<TokIf>(); };
      "ifz"   { return make_unique<TokIfz>(); };
      "then"  { return make_unique<TokThen>(); };
      "else"  { return make_unique<TokElse>(); };
      "\("    { return make_unique<TokLParen>(); };
      "\)"    { return make_unique<TokRParen>(); };

      "0"
        { return make_unique<TokNumeral>("0"); };

      [1-9] [0-9]*
        { return make_unique<TokNumeral>(string(ts, te - ts)); };

      lower ( alnum | "_" | "'" )*
        { return make_unique<TokTermIdent>(string(ts, te - ts)); };
    *|;
}%%

namespace {

// Static, const tables of data.
%% write data;

}

namespace sandbox::parser {

Lexer::Lexer(string_view source) : source(source), p(source.begin()), pe(source.end()), eof(source.end()), cs(expr_start), ts(source.begin()), te(source.begin()), act(0) {}

unique_ptr<Token> Lexer::exec() {
    %% write exec;
    return nullptr;
}

unique_ptr<Token> Lexer::next() {
    auto result = this->exec();
    this->p++;
    return result;
}

vector<unique_ptr<Token>> Lexer::allTokens() {
    vector<unique_ptr<Token>> result;

    // TODO(jez) Do we need to do something to figure out when we're done?
    while (auto it = next()) {
        result.emplace_back(move(it));
    }

    return result;
}

}
