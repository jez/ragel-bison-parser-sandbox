#pragma once

#include <string>
#include <map>
#include <memory>
#include "parser/node.hh"
#include "parser/parser_impl.h"

namespace sandbox::parser {

// Conducting the whole scanning and parsing of Calc++.
class driver {
public:
  driver();

  std::unique_ptr<Node> result;

  // Run the parser on file F.  Return 0 on success.
  int parse(const std::string_view f);

  // The name of the file being parsed.
  std::string file;

  // Whether to generate parser debug traces.
  bool trace_parsing;

  // TODO(jez) locations
  // // The token's location used by the scanner.
  // yy::location location;
};

}
