#pragma once

#include <string>

// Defines factory methods that make tokens for the parser.
#include "parser/parser_impl.h"

namespace sandbox::parser {

class Lexer {
private:
    std::string_view source;

    // When Ragel reads a character, this is it. If we don't break out of its control loop (e.g., by returning),
    // it will update this to consume more characters. When we early exit from Ragel's processing loop, it needs
    // to be updated (see Lexer::next).
    //
    // Mnemonic: Pointer
    std::string_view::const_iterator p;

    // Required by ragel. One past the last character to read.
    //
    // Mnemonic: Pointer End
    const std::string_view::const_iterator pe;

    // Required by ragel when using eof actions, because pe might not be the last character.
    // (Ragel is designed so that the buffer can grow and reallocate as data becomes available)
    // We always read in all the data, so for us pe == eof, always.
    const std::string_view::const_iterator eof;

    // Ragel implements a finite state machine.
    // It uses an int to keep track of the state machine's internal state.
    //
    // Mnemonic: Current State
    int cs;

    // We're using an "advanced" feature of Ragel: the ability to make a scanner, which means
    // we give a list of pattern alternatives and ask Ragel to select the one that best matches.
    //
    // When using Ragel as a scanner, it needs ts, te, and act so that it can backtrack.

    // Start of the token matched by the scanner.
    //
    // Mnemonic: Token Start
    std::string_view::const_iterator ts;

    // One past the end of the token matched by the scanner.
    //
    // Mnemonic: Token End
    std::string_view::const_iterator te;

    // Used for recording the identity of the last pattern matched for backtracking in the scanner.
    //
    // Mnemonic: ???
    int act;

    // From the Ragel docs (Chapter 5):
    //
    // > The Ragel code generator is very flexible. The generated code has no dependencies and can be
    // > inserted in any function, perhaps inside a loop if desired. ...
    // > Control of the input processing loop is also possible: the user may break out of the processing
    // > loop and return to it at any time.
    //
    // We take advantage of this: each of our Ragel actions `return`s. `%% write exec;` is written into the
    // body of this exec() method, which means that `return` in a Ragel action returns from this C++ exec()
    // method.
    yy::parser::symbol_type exec();

public:
    Lexer(std::string_view source);

    // This is the public interface to the Lexer. It's used to implement yylex in the parser.
    //
    // Since all of our actions early exit from exec() before Ragel advances the p pointer, we need our own wrapper
    // which advances p after finishing an action.
    yy::parser::symbol_type next();
};

}
