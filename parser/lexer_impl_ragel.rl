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

Lexer::Lexer(string_view source) : source(source), p(source.begin()), pe(source.end()), eof(source.end()),
    cs(expr_start), ts(source.begin()), te(source.begin()), act(0) {}

unique_ptr<Token> Lexer::exec() {
    %% write exec;
    return nullptr;
}

// From the Ragel docs (Chapter 5):
//
// > The Ragel code generator is very flexible. The generated code has no
// > dependencies and can be inserted in any function, perhaps inside a
// > loop if desired. The user is responsible for declaring and
// > initializing a number of required variables, including the current
// > state and the pointer to the input stream. These can live in any
// > scope. Control of the input processing loop is also possible: the user
// > may break out of the processing loop and return to it at any time.
//
// We take advantage of this: the `return` that we've written in the Ragel
// actions returns from where the `%% write exec;` was written. The problem
// is that if we return early, it happens before the Ragel processing loop
// would have advanced the `p` pointer (the next character to read), so we
// have a helper function that makes sure to advance it ourselves after
// returning.
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
