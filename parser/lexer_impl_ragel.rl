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

        "\\"    { return yy::parser::make_BACKSLASH(); };
        "->"    { return yy::parser::make_THINARROW(); };
        "let"   { return yy::parser::make_LET(); };
        "="     { return yy::parser::make_EQ(); };
        "in"    { return yy::parser::make_IN(); };
        "True"  { return yy::parser::make_TRUE(); };
        "False" { return yy::parser::make_FALSE(); };
        "if"    { return yy::parser::make_IF(); };
        "ifz"   { return yy::parser::make_IFZ(); };
        "then"  { return yy::parser::make_THEN(); };
        "else"  { return yy::parser::make_ELSE(); };
        "\("    { return yy::parser::make_LPAREN(); };
        "\)"    { return yy::parser::make_RPAREN(); };

        "0"
            { return yy::parser::make_NUMERAL("0"); };

        [1-9] [0-9]*
            { return yy::parser::make_NUMERAL(string(ts, te - ts)); };

        lower ( alnum | "_" | "'" )*
            { return yy::parser::make_IDENT(string(ts, te - ts)); };
    *|;
}%%

namespace {

// Static, const tables of data.
%% write data;

}

namespace sandbox::parser {

Lexer::Lexer(string_view source) : source(source), p(source.begin()), pe(source.end()), eof(source.end()),
    cs(expr_start), ts(source.begin()), te(source.begin()), act(0) {}

yy::parser::symbol_type Lexer::exec() {
    %% write exec;
    return yy::parser::make_EOF();
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
yy::parser::symbol_type Lexer::next() {
    auto result = this->exec();
    this->p++;
    return result;
}

vector<yy::parser::symbol_type> Lexer::allTokens() {
    vector<yy::parser::symbol_type> result;

    // // TODO(jez) Do we need to do something to figure out when we're done?
    // // TODO(jez) Implement with parser-generated tokens
    // while (true) {
    //     auto it = next();
    //     if (it.token() == yy::parser::symbol_type::token::TOK_EOF()) {
    //         break;
    //     }
    //     result.emplace_back(move(it));
    // }

    return result;
}

}
