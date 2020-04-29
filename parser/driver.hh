#pragma once

#include <string>
#include <map>
#include "parser/parser_impl.h"

// // Give Flex the prototype of yylex we want ...
// # define YY_DECL \
//   yy::parser::symbol_type yylex (driver& drv)
// // ... and declare it for the parser's sake.
// YY_DECL;

// Conducting the whole scanning and parsing of Calc++.
class driver {
public:
  driver();


  int result;

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

int yylex(driver &drv);

