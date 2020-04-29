%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.3.2"
%defines

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires {
  #include <string>
  class driver;
}

// The parsing context.
%param { driver& drv }

// TODO(jez) locations?
// %locations

%define parse.trace
%define parse.error verbose

%code {
#include "parser/driver.hh"
}

// TODO(jez) String literal for backslash
%define api.token.prefix {TOK_}
%token
  BACKSLASH
  THINARROW "->"
  LET "let"
  EQ "="
  IN "in"
  TRUE "True"
  FALSE "False"
  IF "if"
  IFZ "ifz"
  THEN "then"
  ELSE "else"
  LPAREN "("
  RPAREN ")"
;


%token <std::string> NUMERAL
%token <std::string> IDENT

// TODO(jez) Add this to form below
// TODO(jez) This is here so you remember where to update things
// if you ever add any infix operators.
// See http://dev.stephendiehl.com/fun/008_extended_parser.html

// TODO(jez) What's up with this? For printing tokens I guess?
%printer { yyo << $$; } <*>;

%%
%start program;
program: term  { drv.result = std::move($1); };

%nterm <unique_ptr<Node>> term
term
  : BACKSLASH ident "->" term
      { $$ = std::make_unique<sandbox::parser::Lam>(std::move($2), std::move($4)); }
  | "let" ident "=" term "in" term
      { $$ = std::make_unique<sandbox::parser::Let>(std::move($2), std::move($4)); }
  | form { $$ = std::move($1); }
  ;

%nterm <unique_ptr<Node>> form
form
  : fact { $$ = std::move($1); }
  ;

%nterm <unique_ptr<Node>> fact
fact
  : fact atom
      { $$ = std::make_unique<sandbox::parser::App>(std::move($1), std::move($2)); }
  | atom
      { $$ = std::move($1); }
  ;

%nterm <unique_ptr<Node>> atom
atom
  : "(" term ")" { $$ = std::move($2); }
  | ident { $$ = std::make_unique<sandbox::parser::Var>($1); }
  ;

%%

// TODO(jez) locations
// void yy::parser::error (const location_type& l, const std::string& m) {
void yy::parser::error (const std::string& m) {
  // std::cerr << l << ": " << m << '\n';
  std::cerr << ": " << m << '\n';
}
