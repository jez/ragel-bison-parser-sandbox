#include <iostream>

#include "parser/parser.hh"

using namespace std;

int main(int argc, char *argv[]) {
    if (argc != 2) {
        cout << "usage: sandbox <program>" << endl;
        return 1;
    }

    string_view source = argv[1];
    cout << "input:  " << source << endl;

    auto result = sandbox::parser::parse(source);
    if (result == nullptr) {
        cout << "TODO(jez) error message when parse failed" << endl;
        return 1;
    }

    cout << "output: " << result->showRaw() << endl;

    return 0;
}
