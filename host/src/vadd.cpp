#include "vadd.hpp"

int main(int argc, char** argv)
{
  if (argc < 2) {
    fprintf(stderr, "usage: %s <xclbin>\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  vadd inst;
  inst.init(argv[1]);
  inst.run();
}
