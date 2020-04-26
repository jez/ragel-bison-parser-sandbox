#include "parser/driver.hh"
#include "parser/parser_impl.h"

driver::driver() : trace_parsing (false), trace_scanning (false) {
  variables["one"] = 1;
  variables["two"] = 2;
}

int driver::parse(const std::string &f) {
  file = f;
  // TODO(jez) locations
  // location.initialize (&file);
  scan_begin ();
  yy::parser parse (*this);
  parse.set_debug_level (trace_parsing);
  int res = parse ();
  scan_end ();
  return res;
}

// TODO(jez) look up the signature expected here
int yylex(driver &drv) {
    throw "TODO(jez) Unimplemented";
}
