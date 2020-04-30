#pragma once

#include <string>
#include <vector>
#include <memory>

// To define factory methods that make tokens
#include "parser/parser_impl.h"

namespace sandbox::parser {

class Lexer {
private:
    std::string_view source;

    std::string_view::const_iterator p;
    const std::string_view::const_iterator pe;
    const std::string_view::const_iterator eof;

    int cs;

    std::string_view::const_iterator ts;
    std::string_view::const_iterator te;

    int act;

    yy::parser::symbol_type exec();

public:
    Lexer(std::string_view source);

    yy::parser::symbol_type next();
    std::vector<yy::parser::symbol_type> allTokens();
};

}
