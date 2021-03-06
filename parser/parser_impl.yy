//
// parser_impl.yy
//
// This file is heavily commented, but comments only go so far.
// You'll learn a lot by also cross-referencing with the generated code:
//
//   bazel-bin/parser/parser_impl.h
//   bazel-bin/parser/parser_impl.cc
//
// if you've already built the code, and also the Bison docs:
//
//   <https://www.gnu.org/software/bison/manual/bison.html>
//

// Other options are glr / location, so this is effectively the only C++
// skeleton (even if we used IELR).
%skeleton "lalr1.cc"
%require "3.3.2"

// This code lives in parser_impl.hh.
// Since the Lexer also includes parser_impl.hh, these includes are visible there too.
%code requires {

#include "core/location.hh"
#include "parser/node.hh"

namespace sandbox::parser {
    // Lexer.hh depends on parser_impl.hh for token helpers.
    // Driver.hh depends on Lexer.hh because it manages a Lexer instance.
    // So parser_impl.hh can't depend on Driver.hh, which means we need to forward declare it.
    class Driver;
}

}

// Declare an additional argument / instance variable on the parser class.
// All the actions run in the context of the parser, so this instance variable
// is available in all the parser actions.
// Also declares that yylex receives (and will be given) this this as an arg.
%param { sandbox::parser::Driver &driver }

// Include runtime sanity checks in the generated code.
// By default forwards to assert(3), which means these checks will respect NDEBUG.
%define parse.assert

// Give a message to yy:parser::error describing the parse failure.
// (Only other option is to make the message just "syntax error")
%define parse.error verbose

// When tracing the parser, the parser will print tokens and reduced intermediates.
%define parse.trace

// Requests that tokens and non-terminals be printed when the parser is tracing itself.
%printer { yyo << ($$)->showRaw(); } <std::unique_ptr<sandbox::parser::Node>>;
%printer { yyo << $$; } <*>;

// All tokens and non-terminals track locations in addition to their semantic value.
%locations

// Use our own location type, for a number of reasons: (1) we can tailor the
// interface to our needs rather than relying on Bison, (2) we're going to use
// locations elsewhere, and it's nice to use the same one everywhere, and (3)
// %locations depends on generating additional header/source files, and
// rules_bison doesn't (as of May 2020) declare them as outputs so Bazel
// discards them after Bison generates them.
%define api.location.type {sandbox::core::Range}

// This code lives in the generated cc file (implementation), not the header.
%code {

#include "parser/driver.hh"

yy::parser::symbol_type yylex(sandbox::parser::Driver &driver) {
    return driver.lexer.next();
}

// Say how to default initialize the location that bison tracks for a
// non-terminal. (Can be customized by using @$ and @<n> in each action.)
// Since we've specified api.location.type, Current is a Range.
//
// Default action is to set Current to span from RHS[1] to RHS[N]. If N is 0,
// then set Current to the empty location which ends the previous symbol:
// RHS[0] (always defined).
#define YYLLOC_DEFAULT(Current, Rhs, N)                                 \
    do {                                                                \
      if (N) {                                                          \
          (Current).start  = YYRHSLOC(Rhs, 1).start;                    \
          (Current).end    = YYRHSLOC(Rhs, N).end;                      \
      }                                                                 \
      else {                                                            \
          (Current).start = (Current).end = YYRHSLOC(Rhs, 0).end;       \
      }                                                                 \
    } while (false);
}

// Use bison's internal std::variant-esque data structure to model the token
// type (instead of just an int or a C union).
%define api.value.type variant

// Request that bison generate the type safe make_FOO-style token constructors.
%define api.token.constructor

// Adds a prefix to the generated C++ enum for tokens. Doesn't really affect
// us, because it's omitted when referencing tokens in the grammar below and
// also when calling the make_FOO constructors.
%define api.token.prefix {TOK_}

// The token with value 0 is special, and denotes the end of the token stream.
%token EOF 0 "end of file"

%token
  BACKSLASH "\\"
  THINARROW "->"
  LET "let"
  EQ "="
  IN "in"
  LPAREN "("
  RPAREN ")"
;

// IDENT token owns a string
%token <std::string> IDENT

%%
%start result;
result: term  { this->driver.result = std::move($1); };

%nterm <std::unique_ptr<sandbox::parser::Node>> term;
term
  : "\\" IDENT "->" term
      { $$ = std::make_unique<sandbox::parser::Lam>(std::move($2), std::move($4)); }
  | "let" IDENT "=" term "in" term
      { $$ = std::make_unique<sandbox::parser::Let>(std::move($2), std::move($4), std::move($6)); }
  | form { $$ = std::move($1); }
  ;

// This is here so you remember where to update things if you ever add any infix operators.
// See http://dev.stephendiehl.com/fun/008_extended_parser.html
%nterm <std::unique_ptr<sandbox::parser::Node>> form;
form
  : fact { $$ = std::move($1); }
  ;

%nterm <std::unique_ptr<sandbox::parser::Node>> fact;
fact
  : fact atom
      { $$ = std::make_unique<sandbox::parser::App>(std::move($1), std::move($2)); }
  | atom
      { $$ = std::move($1); }
  ;

%nterm <std::unique_ptr<sandbox::parser::Node>> atom;
atom
  : "(" term ")" { $$ = std::move($2); }
  | IDENT { $$ = std::make_unique<sandbox::parser::Var>(std::move($1)); }
  ;

%%

void yy::parser::error (const sandbox::core::Range& range, const std::string& m) {
    // TODO(jez) Show filename:line:column in this error message, or even better
    // build program-wide error reporting so you can show pretty errors like Sorbet.
    (void) this->driver;
    std::cerr << range.showRaw() << ": " << m << '\n';
}

