#include "parser/driver.hh"

using namespace std;

namespace sandbox::parser {

Driver::Driver(string_view source) : source(source), lexer(Lexer(source)) {}

}
