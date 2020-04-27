#pragma once

#include <cstdint>
#include <string>

class Token {
public:
    virtual ~Token() = default;
    virtual std::string showRaw() = 0;
};

class TokBackslash : public Token {
    virtual std::string showRaw() { return "TokBackslash"; }
};

class TokThinArrow : public Token {
    virtual std::string showRaw() { return "TokThinArrow"; }
};

class TokLet : public Token {
    virtual std::string showRaw() { return "TokLet"; }
};

class TokEq : public Token {
    virtual std::string showRaw() { return "TokEq"; }
};

class TokIn : public Token {
    virtual std::string showRaw() { return "TokIn"; }
};

class TokTrue : public Token {
    virtual std::string showRaw() { return "TokTrue"; }
};

class TokFalse : public Token {
    virtual std::string showRaw() { return "TokFalse"; }
};

class TokIf : public Token {
    virtual std::string showRaw() { return "TokIf"; }
};

class TokIfz : public Token {
    virtual std::string showRaw() { return "TokIfz"; }
};

class TokThen : public Token {
    virtual std::string showRaw() { return "TokThen"; }
};

class TokElse : public Token {
    virtual std::string showRaw() { return "TokElse"; }
};

class TokLParen : public Token {
    virtual std::string showRaw() { return "TokLParen"; }
};

class TokRParen : public Token {
    virtual std::string showRaw() { return "TokRParen"; }
};

class TokNumeral : public Token {
public:
    // TODO(jez) Numbers
    // int32_t value;
    std::string value;

    TokNumeral(std::string value) : value(value) {}
    virtual std::string showRaw() { return "TokNumeral { value = " + this->value + " }"; }
};

class TokTermIdent : public Token {
public:
    std::string value;

    TokTermIdent(std::string value) : value(value) {}
    virtual std::string showRaw() { return "TokTermIdent { value = " + this-> value + " }"; }
};
