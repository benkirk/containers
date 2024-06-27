#!/bin/bash

set -ex

OSU_VERSION=7.2

cd /tmp && curl -Sl  https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_VERSION}.tar.gz | tar xz \
    && cd osu-micro-benchmarks-${OSU_VERSION} \
    && ./configure --prefix=/opt/local/osu-micro-benchmarks-${OSU_VERSION} \
                   CXX=$(which mpicxx) CC=$(which mpicc) FC=$(which mpif90) F77=$(which mpif77) LIBS="-L${CUDA_HOME}/targets/x86_64-linux/lib -lcudart" \
                   --enable-cuda --with-cuda=${CUDA_HOME} \
    && make -j 8 V=0 && make install \
    && cd && rm -rf /tmp/osu-micro-benchmarks-${OSU_VERSION} \
    && cd /opt/local && mpicxx -o hello_world_mpi /home/plainuser/hello_world_mpi.C -fopenmp

cd /opt/local && git clone https://github.com/intel/mpi-benchmarks.git imb-2021.3 \
    && cd /opt/local/imb-2021.3 && git checkout 8ba5d968272b6e7b384f91b6597d1c4590faf3db \
    && CXX=$(which mpicxx) CC=$(which mpicc) make \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean \
    && make -C src_cpp -f Makefile TARGET=NBC clean\
    && make -C src_cpp -f Makefile TARGET=RMA clean \
    && make -C src_cpp -f Makefile TARGET=EXT clean \
    && make -C src_cpp -f Makefile TARGET=IO clean \
    && make -C src_cpp -f Makefile TARGET=MT clean \
    && make -C src_c/P2P -f Makefile TARGET=P2P clean \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean GPU_ENABLE=1
