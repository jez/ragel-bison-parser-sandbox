#pragma once

#include <cstdint>
#include <string_view>


// The names of these abstractions correspond to the LSP spec's interface
// definitions, with an important difference that lines and characters are
// 1-indexed (like most editors display) instead of 0-indexed.
//
// https://microsoft.github.io/language-server-protocol/specification.html#position

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
private:
    constexpr static uint32_t INVALID_OFFSET = UINT32_MAX;

public:

    // 0-indexed character offset into file source contents, inclusive
    uint32_t start;

    // 0-indexed character offset into file source contents, exclusive
    uint32_t end;

    // Builds a Range for which Range::exists() is false.
    //
    // We prefer this over using something like std::optional because we want to guarantee that
    // Range fits in a single machine word.
    Range();

    // Builds a Range that exists.
    Range(uint32_t start, uint32_t end);

    // Checks whether this Range actually exists
    bool exists() const;

    std::string showRaw() const;
};

class Location {
public:
    // TODO(jez) This should store a FileRef instead of a strinv_view eventually
    std::string_view source;

    Range range;

    // TODO(jez) Location constructors
};

}
