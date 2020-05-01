%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.3.2"
%defines

%define parse.assert

%code requires {
// This code lives in the generated hh file (interface)

#include "parser/node.hh"

namespace sandbox::parser {
    // Lexer.hh depends on parser_impl.hh for token helpers.
    // Driver.hh depends on Lexer.hh because it manages a Lexer instance.
    // So parser_impl.hh can't depend on Driver.hh, which means we need to forward declare it.
    class Driver;
}

}

%param { sandbox::parser::Driver &driver }

// TODO(jez) locations
// %locations

// TODO(jez) Document this option
%define parse.error verbose

%code {
// This code lives in the generated cc file (implementation)

#include "parser/driver.hh"

yy::parser::symbol_type yylex(sandbox::parser::Driver &driver);
}

// TODO(jez) Document these options
%define api.token.constructor
%define api.value.type variant
// TODO(jez) String literal for backslash
%define api.token.prefix {TOK_}
// The token with value 0 is special, and denotes the end of the token stream.
%token EOF 0 "end of file"
%token
  BACKSLASH
  THINARROW "->"
  LET "let"
  EQ "="
  IN "in"
  LPAREN "("
  RPAREN ")"
;
%token <std::string> IDENT

// When tracing the parser, the parser will print tokens and reduced intermediates.
%define parse.trace
// TODO(jez) Try tracing the parser once
// %printer { yyo << $$; } <*>;

%%
%start result;
result: term  { driver.result = std::move($1); };

%nterm <std::unique_ptr<sandbox::parser::Node>> term;
term
  : BACKSLASH IDENT "->" term
      { $$ = std::make_unique<sandbox::parser::Lam>(std::move($2), std::move($4)); }
  | "let" IDENT "=" term "in" term
      { $$ = std::make_unique<sandbox::parser::Let>(std::move($2), std::move($4), std::move($6)); }
  | form { $$ = std::move($1); }
  ;

// TODO(jez) This is here so you remember where to update things
// if you ever add any infix operators.
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

// TODO(jez) locations
// void yy::parser::error (const location_type& l, const std::string& m) {
void yy::parser::error (const std::string& m) {
  // std::cerr << l << ": " << m << '\n';
  std::cerr << ": " << m << '\n';
}

yy::parser::symbol_type yylex(sandbox::parser::Driver &driver) {
    return driver.lexer.next();
}
