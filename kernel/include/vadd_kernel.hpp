#pragma once

extern "C" {
void vadd_kernel(const float* a, const float* b, float *c, int size);
}
