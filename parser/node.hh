#pragma once

#include <string>
#include <memory>

namespace sandbox::parser {

class Node {
public:
    // TODO(jez) showRaw
    virtual ~Node() = default;
};

class Var : public Node {
public:
    Var(std::string var) : var(var) {};

    std::string var;
};

class App : public Node {
public:
    App(std::unique_ptr<Node> f, std::unique_ptr<Node> arg) : f(std::move(f)), arg(std::move(arg)) {}

    std::unique_ptr<Node> f;
    std::unique_ptr<Node> arg;
};

class Lam : public Node {
public:
    Lam(std::string param, std::unique_ptr<Node> body) : param(std::move(param)), body(std::move(body)) {}

    std::string param;
    std::unique_ptr<Node> body;
};

class Let : public Node {
public:
    // TODO(jez) Take ownership of string, don't copy
    Let(std::string bind, std::unique_ptr<Node> what, std::unique_ptr<Node> inWhere) : bind(bind), what(std::move(what)), inWhere(std::move(inWhere)) {}

    std::string bind;
    std::unique_ptr<Node> what;
    std::unique_ptr<Node> inWhere;
};

}
