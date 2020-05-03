#pragma once

#include "parser/driver.hh"
#include "parser/parser_impl.h"

namespace sandbox::parser {

std::unique_ptr<Node> parse(std::string_view source, bool trace = false);

}
