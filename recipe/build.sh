#!/bin/bash
set -x
set -e

export CONFIGURE_ARGS=""

if [[ -n "$dagmc" && "$dagmc" != "nodagmc" ]]; then
  export CONFIGURE_ARGS="-Ddagmc=ON ${CONFIGURE_ARGS}"
fi

if [[ "$mpi" != "nompi" ]]; then
  export CONFIGURE_ARGS="-DHDF5_PREFER_PARALLEL=ON ${CONFIGURE_ARGS}"
  export CONFIGURE_ARGS="-DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_C_COMPILER=mpicc ${CONFIGURE_ARGS}"
fi

# Build and install executable
mkdir -p build
cd build
cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_BUILD_TYPE=Release \
      -DHDF5_ROOT="${PREFIX}" \
      ${CONFIGURE_ARGS} \
      ..
make -j "${CPU_COUNT}"
make install
cd ..

# Install Python API
$PYTHON -m pip install . --no-deps -vv
