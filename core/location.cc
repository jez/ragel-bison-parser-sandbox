#include "core/location.hh"

namespace sandbox::core {

Range::Range() : start(INVALID_OFFSET), end(INVALID_OFFSET) {}

Range::Range(uint32_t start, uint32_t end) : start(start), end(end) {}

bool Range::exists() const {
    return this->start != INVALID_OFFSET && this->end != INVALID_OFFSET;
}

}

