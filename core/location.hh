#pragma once

#include <cstdint>
#include <string_view>


// The names of these abstractions correspond to the LSP spec's interface
// definitions, with an important difference that lines and characters are
// 1-indexed (like most editors display) instead of 0-indexed.
//
// https://microsoft.github.io/language-server-protocol/specification.html#position

// TODO(jez) Why doesn't compile_commands.json see this as C++17?
namespace sandbox::core {

class Position {
public:
    uint32_t line;
    uint32_t character;
};

// In the context of a file's source, a Range's start/end offsets can be
// converted to Positions, but a Range itself does not store the file.
// This is is because Range is designed to fit within a single 64-bit machine
// word (Ranges are far more commonly manipulated and copied than Locations
// are).
class Range {
public:
    constexpr static uint32_t INVALID_OFFSET = UINT32_MAX;

    // 0-indexed character offset into file source contents, inclusive
    uint32_t start;

    // 0-indexed character offset into file source contents, exclusive
    uint32_t end;

    Range() : start(INVALID_OFFSET), end(INVALID_OFFSET) {}
    Range(uint32_t start, uint32_t end) : start(start), end(end) {}

    bool exists() {
        return start != INVALID_OFFSET && end != INVALID_OFFSET;
    }
};

class Location {
public:
    // TODO(jez) This should store a FileRef instead of a strinv_view eventually
    std::string_view source;

    Range range;

    // TODO(jez) Location constructors
};

}
