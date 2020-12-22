#include <random>

#include <gtest/gtest.h>

#include "vadd.hpp"

TEST(vadd, test) {
  std::random_device seed_gen;
  std::mt19937 engine(seed_gen());
  std::normal_distribution<float> dist(1.0, 0.5);

  const int size = 100;
  std::vector<float> a(size), b(size), c(size);

  for (int i=0; i<size; i++) {
    a[i] = dist(engine);
    b[i] = dist(engine);
  }

  vadd(a.data(), b.data(), c.data(), size);

  for (int i=0; i<size; i++) {
    EXPECT_TRUE(a[i] + b[i] == c[i]);
  }
}

