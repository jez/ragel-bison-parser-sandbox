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
        "\("    { return yy::parser::make_LPAREN(); };
        "\)"    { return yy::parser::make_RPAREN(); };

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

yy::parser::symbol_type Lexer::next() {
    auto result = this->exec();
    this->p++;
    return result;
}

}
