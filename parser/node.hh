#pragma once

#include <string>
#include <memory>

namespace sandbox::parser {

class Node {
public:
    virtual ~Node() = default;

    // TODO(jez) fmt-ify
    virtual std::string showRaw() = 0;
};

class Var : public Node {
public:
    Var(std::string &&var) : var(std::move(var)) {};

    std::string var;

    std::string showRaw() {
        return "Var { var = " + this->var + " }";
    }
};

class App : public Node {
public:
    App(std::unique_ptr<Node> f, std::unique_ptr<Node> arg) : f(std::move(f)), arg(std::move(arg)) {}

    std::unique_ptr<Node> f;
    std::unique_ptr<Node> arg;

    std::string showRaw() {
        return "App { f = " + this->f->showRaw() + ", arg = " + this->arg->showRaw() + " }";
    }
};

class Lam : public Node {
public:
    Lam(std::string &&param, std::unique_ptr<Node> body) : param(std::move(param)), body(std::move(body)) {}

    std::string param;
    std::unique_ptr<Node> body;

    std::string showRaw() {
        return "Lam { param = " + this->param + ", body = " + this->body->showRaw() + " }";
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
        return "Let { bind = " + this->bind + ", what = " + this->what->showRaw() + ", inWhere = " + this->inWhere->showRaw() + " }";
    }
};

}
