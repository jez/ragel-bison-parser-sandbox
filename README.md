# ragel-bison-parser-sandbox

A small sandbox to play around with some C++ parsing libraries and learn. It
parses lambda calculus expressions to an AST and prints it.

Very much inspired by the build toolchain that [Sorbet] uses.

```bash
./bazel run //main:sandbox -- $'let f = \x -> x in f f'
# input:  let x = \x -> x in x x
# output: Let { bind = x, what = Lam { param = x, body = Var { var = x } }, inWhere = App { f = Var { var = x }, arg = Var { var = x } } }

# if you want to generate a compile_commands.json file:
tools/scripts/build_compilation_db.sh
```

Some things I cared about

- I wrote a lot of comments
  - This was a learning exercise. I don't really intend to pursue this project
    further (I find it way more fun to hack on existing projects than to
    duplicate existing efforts into my own greenfield projects). But still, I
    had never worked with the lexer+parser much in Sorbet, so if I had needed to
    build a project from scratch, I knew this part would have taken me some
    getting used to. So the comments are there to remind me how the whole thing
    works.
- Bazel for the build tool
  - It's what Sorbet uses
  - I'm mostly convinced all build tools are terrible; Bazel just happens to be
    the one that I know the most, and the one for which I know how to set up to
    work with libraries and my editor.
- Ragel for lexing, Bison for parsing
  - They're what Sorbet uses, but I wanted something simpler.
  - Both the generated Ragel lexer and Bison parser are fully self-contained C++
    classes (no global variables tracking state).
- `std::unique_ptr` for the Bison parse result
  - I couldn't find any examples online of a simple Bison parser that used
    `unique_ptr`, so I wasn't sure if it would work or not (e.g., it might have
    been the case that it copy constructed something under the hood, but that's
    not the case; looks like you can use Bison with unique_ptr just fine).
- The Ragel lexer iterates over a `string_view::const_iterator` instead of a
  `char *`.
  - This is actually pretty cool; Ragel doesn't even know that it's not
    operating on a `char *`. The generated Ragel lexer just manipulates whatever
    variables called `p`/`pe`/`ts`/`te` are in scope, and as long as they
    support the operations that it needs them to, it just compiles. Turns out
    that the `string_view::const_iterator` interface supports everything Ragel
    needs it to.
- Move semantics for strings allocated by the lexer.
  - I'm told that one of the big inefficiencies in Sorbet's parser is that it
    does a lot of string copying. I made the `sandbox::parser::Node`
    constructors always take `std::string&&`'s to require that they're `move`'d
    when constructing an AST node, instead of copied.
- There are a lot of TODO's
  - I tried to write TODOs for most of the things I like about Sorbet that I'd
    want to cargo cult if I ever used this as a starting point for something
    bigger.

Anyways, if you read this far, you might also want to look at some other things
I work on:

- [Sorbet]
  - The internals are documented and the codebase is using pretty modern C++.
    It's also relatively small compared to it's peer projects.
- [rust-lc-interp]
  - I used a similar project (lambda calculus interpretter) to learn about Rust.
    That one not only parses but also interprets the output.
- [stlc-infer]
  - At one point, I worked through an exercise from TAPL to write (naive) type
    inference for the simply-typed lambda calculus. It lexes, parses, type
    checks/infers, and interprets. It's written in Haskell.

The Rust project and the Haskell project use basically the same surface syntax,
so you can get a more or less equal comparison of Ragel/Bison, Alex/Happy, and
lalrpop.

[Sorbet]: https://github.com/sorbet/sorbet
[rust-lc-interp]: https://github.com/jez/rust-lc-interp
[stlc-infer]: https://github.com/jez/stlc-infer
