#pragma once

#include <string>
#include <memory>
#include "parser/lexer.hh"
#include "parser/node.hh"

namespace sandbox::parser {

class Driver {
private:
    // TODO(jez) Probably eventually want to take in a FileRef
    std::string_view source;
public:
    Driver(std::string_view source);

    // Maintains the lexer machine's current state.
    Lexer lexer;

    // Out parameter for the parse result
    std::unique_ptr<Node> result;
};

}
