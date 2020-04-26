%{ /* -*- C++ -*- */
#include <cerrno>
#include <climits>
#include <cstdlib>
#include <cstring> // strerror
#include <string>
// TODO(jez) Uppercase private headers, lower case public headers
#include "parser/driver.hh"
#include "parser/parser_impl.h"
%}

%{
// {{{
#if defined __clang__
# define CLANG_VERSION (__clang_major__ * 100 + __clang_minor__)
#endif

// Clang and ICC like to pretend they are GCC.
#if defined __GNUC__ && !defined __clang__ && !defined __ICC
# define GCC_VERSION (__GNUC__ * 100 + __GNUC_MINOR__)
#endif

// TODO(jez) Try deleting these diagnostic ignored things

// Pacify warnings in yy_init_buffer (observed with Flex 2.6.4)
// and GCC 6.4.0, 7.3.0 with -O3.
#if defined GCC_VERSION && 600 <= GCC_VERSION
# pragma GCC diagnostic ignored "-Wnull-dereference"
#endif

// This example uses Flex's C backend, yet compiles it as C++.
// So expect warnings about C style casts and NULL.
#if defined CLANG_VERSION && 500 <= CLANG_VERSION
# pragma clang diagnostic ignored "-Wold-style-cast"
# pragma clang diagnostic ignored "-Wzero-as-null-pointer-constant"
#elif defined GCC_VERSION && 407 <= GCC_VERSION
# pragma GCC diagnostic ignored "-Wold-style-cast"
# pragma GCC diagnostic ignored "-Wzero-as-null-pointer-constant"
#endif

#define FLEX_VERSION (YY_FLEX_MAJOR_VERSION * 100 + YY_FLEX_MINOR_VERSION)
// }}}

%}

%option noyywrap nounput noinput batch debug c++

%{
  // A number symbol corresponding to the value in S.
  // TODO(jez) locations
  // yy::parser::symbol_type make_NUMBER(const std::string &s, const yy::parser::location_type& loc);
  yy::parser::symbol_type make_NUMBER(const std::string &s);
%}

id    [a-zA-Z][a-zA-Z_0-9]*
int   [0-9]+
blank [ \t\r]

%{
  // Code run each time a pattern is matched.
  // TODO(jez) locations
  //# define YY_USER_ACTION  loc.columns (yyleng);
%}
%%
%{
  // TODO(jez) locations
  // // A handy shortcut to the location held by the driver.
  // yy::location& loc = drv.location;
  // // Code run each time yylex is called.
  // loc.step ();
%}
{blank}+   /* loc.step () */;
\n+        /* loc.lines (yyleng); loc.step () */;

"-"        return yy::parser::make_MINUS  (/* loc */);
"+"        return yy::parser::make_PLUS   (/* loc */);
"*"        return yy::parser::make_STAR   (/* loc */);
"/"        return yy::parser::make_SLASH  (/* loc */);
"("        return yy::parser::make_LPAREN (/* loc */);
")"        return yy::parser::make_RPAREN (/* loc */);
":="       return yy::parser::make_ASSIGN (/* loc */);

{int}      return make_NUMBER (yytext/*, loc */);
{id}       return yy::parser::make_IDENTIFIER (yytext/*, loc */);
.          {
             throw yy::parser::syntax_error
               (/* loc, */"invalid character: " + std::string(yytext));
}
<<EOF>>    return yy::parser::make_END (/* loc */);
%%

#include "FlexLexer.h"

// yy::parser::symbol_type make_NUMBER (const std::string &s, const yy::parser::location_type& loc) {
yy::parser::symbol_type make_NUMBER (const std::string &s) {
  errno = 0;
  long n = strtol (s.c_str(), NULL, 10);
  if (! (INT_MIN <= n && n <= INT_MAX && errno != ERANGE))
    /* throw yy::parser::syntax_error (loc, "integer is out of range: " + s); */
    throw yy::parser::syntax_error ("integer is out of range: " + s);
  return yy::parser::make_NUMBER ((int) n);
}

void driver::scan_begin() {
  yy_flex_debug = trace_scanning;
  if (file.empty () || file == "-")
    yyin = stdin;
  else if (!(yyin = fopen (file.c_str (), "r")))
    {
      std::cerr << "cannot open " << file << ": " << strerror(errno) << '\n';
      exit (EXIT_FAILURE);
    }
}

void driver::scan_end() {
  fclose (yyin);
}
// vim:fdm=marker
