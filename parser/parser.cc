#include "parser/parser.hh"

using namespace std;

namespace sandbox::parser {

unique_ptr<Node> parse(string_view source, bool trace) {
    sandbox::parser::Driver driver(source);
    yy::parser parser(driver);

    if (trace) {
        parser.set_debug_level(1);
    }

    auto error = parser.parse();
    if (error != 0) {
        // TODO(jez) Parser errors
        return nullptr;
    }

    return move(driver.result);
}

}
