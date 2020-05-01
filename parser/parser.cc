#include "parser/parser.hh"

using namespace std;

namespace sandbox::parser {

unique_ptr<Node> parse(string_view source) {
    sandbox::parser::Driver driver(source);
    yy::parser parse(driver);

    auto error = parse();
    if (error != 0) {
        // TODO(jez) Parser errors
        return nullptr;
    }

    return move(driver.result);
}

}
