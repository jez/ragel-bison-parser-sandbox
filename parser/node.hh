#pragma once

#include <string>
#include <memory>

#include "spdlog/fmt/fmt.h"

namespace sandbox::parser {

class Node {
public:
    virtual ~Node() = default;

    virtual std::string showRaw() = 0;
};

class Var : public Node {
public:
    Var(std::string &&var) : var(std::move(var)) {};

    std::string var;

    std::string showRaw() {
        return fmt::format("Var {{ var = {} }}", this->var);
    }
};

class App : public Node {
public:
    App(std::unique_ptr<Node> f, std::unique_ptr<Node> arg) : f(std::move(f)), arg(std::move(arg)) {}

    std::unique_ptr<Node> f;
    std::unique_ptr<Node> arg;

    std::string showRaw() {
        return fmt::format("App {{ f = {}, arg = {} }}", this->f->showRaw(), this->arg->showRaw());
    }
};

class Lam : public Node {
public:
    Lam(std::string &&param, std::unique_ptr<Node> body) : param(std::move(param)), body(std::move(body)) {}

    std::string param;
    std::unique_ptr<Node> body;

    std::string showRaw() {
        return fmt::format("Lam {{ param = {}, body = {} }}", this->param, this->body->showRaw());
    }
};

class Let : public Node {
public:
    Let(std::string &&bind, std::unique_ptr<Node> what, std::unique_ptr<Node> inWhere) : bind(std::move(bind)),
        what(std::move(what)), inWhere(std::move(inWhere)) {}

    std::string bind;
    std::unique_ptr<Node> what;
    std::unique_ptr<Node> inWhere;

    std::string showRaw() {
        return fmt::format("Let {{ bind = {}, what = {}, inWhere = {} }}", this->bind, this->what->showRaw(), this->inWhere->showRaw());
    }
};

}
