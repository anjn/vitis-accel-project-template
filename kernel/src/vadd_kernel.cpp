#include "vadd_kernel.hpp"
#include "vadd.hpp"

void vadd_kernel(const float* a, const float* b, float *c, int size) {
#pragma HLS INTERFACE m_axi port=a offset=slave bundle=gmem depth=100
#pragma HLS INTERFACE m_axi port=b offset=slave bundle=gmem depth=100
#pragma HLS INTERFACE m_axi port=c offset=slave bundle=gmem depth=100
#pragma HLS INTERFACE s_axilite port=a
#pragma HLS INTERFACE s_axilite port=b
#pragma HLS INTERFACE s_axilite port=c
#pragma HLS INTERFACE s_axilite port=size
#pragma HLS INTERFACE s_axilite port=return
  vadd(a, b, c, size);
}
