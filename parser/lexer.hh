#include <string>
#include <vector>
#include <memory>

// TODO(jez) Parser will generate functions to make tokens;
// need to use them here, instead of our own constructors.
#include "parser/token.hh"

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

    std::unique_ptr<Token> exec();

public:
    Lexer(std::string_view source);

    std::unique_ptr<Token> next();
    std::vector<std::unique_ptr<Token>> allTokens();
};

}
