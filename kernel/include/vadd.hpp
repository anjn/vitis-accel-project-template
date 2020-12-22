#pragma once

template<typename T>
void vadd(const T* a, const T* b, T* c, int size) {
  for (int i=0; i<size; i++) {
    c[i] = a[i] + b[i];
  }
}
