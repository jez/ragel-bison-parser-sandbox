%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.3.2"
%defines

%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires {
#include "parser/node.hh"
namespace sandbox::parser {
class Driver;
}
}

// TODO(jez) Which namespace should we be using?
%param { sandbox::parser::Driver &driver }

// TODO(jez) locations
// %locations

%define parse.trace
%define parse.error verbose

%code {
#include "parser/driver.hh"
// TODO(jez) Is this %code block needed?
yy::parser::symbol_type yylex(sandbox::parser::Driver &driver);
}

// TODO(jez) String literal for backslash
%define api.token.prefix {TOK_}
%token
  EOF 0 "end of file"
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
