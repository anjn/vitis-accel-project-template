#pragma once
#include <random>

#include "ocl_common.hpp"

struct vadd
{
  cl::Device device;
  cl::Context context;
  cl::CommandQueue q;
  cl::Program program;

  cl::Kernel vadd_kernel;

  void init(const std::string &xclbin)
  {
    device = find_device();
    context = cl::Context(device);
    program = create_program(device, context, xclbin);
    q = cl::CommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE);
    vadd_kernel = cl::Kernel(program, "vadd_kernel");
  }

  void run()
  {
    std::random_device seed_gen;
    std::mt19937 engine(seed_gen());
    std::normal_distribution<float> dist(1.0, 0.5);

    const int size = 100;

    host_buffer<float> host_a(size);
    host_buffer<float> host_b(size);
    host_buffer<float> host_c(size);

    for (int i=0; i<size; i++) {
      host_a[i] = dist(engine);
      host_b[i] = dist(engine);
    }

    cl::Memory device_a = make_device_buffer(context, CL_MEM_READ_ONLY, host_a);
    cl::Memory device_b = make_device_buffer(context, CL_MEM_READ_ONLY, host_b);
    cl::Memory device_c = make_device_buffer(context, CL_MEM_WRITE_ONLY, host_c);

    vadd_kernel.setArg(0, device_a);
    vadd_kernel.setArg(1, device_b);
    vadd_kernel.setArg(2, device_c);
    vadd_kernel.setArg(3, size);

    q.enqueueMigrateMemObjects({device_a, device_b}, 0);
    q.enqueueTask(vadd_kernel);
    q.enqueueMigrateMemObjects({device_c}, CL_MIGRATE_MEM_OBJECT_HOST);
    q.finish();

    bool pass = true;
    for (int i=0; i<size; i++) {
      if (host_a[i] + host_b[i] != host_c[i]) pass =false;
    }
    printf("Test: %s\n", pass?"Pass":"Fail!");
  }
};

