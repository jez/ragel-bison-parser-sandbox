// ragel_subtype=cpp

#include <string>
#include <vector>
#include <memory>

#include "parser/lexer.hh"

using namespace std;

%%{
    machine expr;
    main := |*
        space;

        "--" . [^\n]+ "\n";

        "\\"    { return yy::parser::make_BACKSLASH(tokenRange()); };
        "->"    { return yy::parser::make_THINARROW(tokenRange()); };
        "let"   { return yy::parser::make_LET(tokenRange()); };
        "="     { return yy::parser::make_EQ(tokenRange()); };
        "in"    { return yy::parser::make_IN(tokenRange()); };
        "\("    { return yy::parser::make_LPAREN(tokenRange()); };
        "\)"    { return yy::parser::make_RPAREN(tokenRange()); };

        lower ( alnum | "_" | "'" )*
            { return yy::parser::make_IDENT(string(ts, te - ts), tokenRange()); };

        # TODO(jez) Emit error for unexpected character

        # TODO(jez) Consider moving EOF handling into the scanner (sorbet does this)
    *|;
}%%

namespace {

// Static, const tables of data.
%% write data;

}

namespace sandbox::parser {

Lexer::Lexer(string_view source) : source(source), p(source.begin()), pe(source.end()), eof(source.end()),
    cs(expr_start), ts(source.begin()), te(source.begin()), act(0) {}

core::Range Lexer::tokenRange() const {
    uint32_t start = ts - source.begin();
    uint32_t end = te - source.begin();
    return {start, end};
}

yy::parser::symbol_type Lexer::exec() {
    %% write exec;
    return yy::parser::make_EOF(tokenRange());
}

yy::parser::symbol_type Lexer::next() {
    auto result = this->exec();
    this->p++;
    return result;
}

}
