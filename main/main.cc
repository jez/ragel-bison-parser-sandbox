#include <iostream>

#include "parser/driver.hh"
// TODO(jez) Make a proper public interface for the parser
#include "parser/parser_impl.h"

using namespace std;

int main(int argc, char *argv[]) {
    cout << "Hello, world!" << endl;

    if (argc != 2) {
        printf("usage: sandbox <program>");
        return 1;
    }

    string_view source = argv[1];

    sandbox::parser::Driver driver(source);

    yy::parser parse(driver);
    auto error = parse();

    if (error != 0) {
        printf("TODO(jez) error message\n");
        return error;
    }

    auto result = std::move(driver.result);

    printf("%s\n", result->showRaw().c_str());

    return 0;
}
