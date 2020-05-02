#include "core/location.hh"

Range::Range() : start(INVALID_OFFSET), end(INVALID_OFFSET) {}

Range::Range(uint32_t start, uint32_t end) : start(start), end(end) {}
