FROM benjaminkirk/rocky8-openhpc-mpich:latest

ARG COMPILER_VERSION=gnu9
ARG MPI_FAMILY=mpich
ARG MPI_FAMILY_VARIANT=mpich-ofi
ARG MPICH_VERSION=3.4.3
ARG OSU_VERSION=7.2

USER root

# https://developer.nvidia.com/cuda-11-7-1-download-archive
RUN echo "Cuda" \
    && curl -O https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm \
    && rpm -i cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm && rm -f cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm \
    && dnf -y install cuda && rm /var/cuda-repo-rhel8-11-7-local/*.rpm && dnf config-manager --disable cuda-rhel8-11-7-local \
    && echo "RDMA prereqs" \
    && dnf -y install libibverbs-devel libpsm2-devel \
    && docker-clean

RUN mkdir /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda
COPY extras/cuda-11.7 /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda/11.7
COPY extras/mpich-${MPICH_VERSION}-ofi-cuda /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/mpich/${MPICH_VERSION}-ofi-cuda
COPY extras/hello_world.cu /home/plainuser

RUN mkdir -p /opt/local \
    && chown -R plainuser: /home/plainuser/ /opt/local

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && module load -mpich +hwloc +libfabric +cuda && module list \
    && cd /opt/local && nvcc -o hello_cuda /home/plainuser/hello_world.cu --cudart shared \
    && cd /tmp && curl -sSL https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar xz \
    && cd mpich-${MPICH_VERSION} \
    && ./configure --help \
    && ./configure --prefix=/opt/local/mpich-${MPICH_VERSION}-cuda \
                   CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) \
                   --enable-fortran \
                   --with-libfabric=${LIBFABRIC_DIR} \
                   --with-hwloc-prefix=${HWLOC_DIR} \
                   --with-cuda=${CUDA_HOME} \
    && make -j 8 && make install \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/local/mpich-${MPICH_VERSION}-cuda/bin/mpicxx

RUN echo "Installing MPI benchmark applications" \
    && whoami && module avail \
    && module load mpich/${MPICH_VERSION}-ofi-cuda && module list \
    && echo "OSU:" \
    && cd /tmp && curl -Sl https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_VERSION}.tar.gz | tar xz \
    && cd osu-micro-benchmarks-${OSU_VERSION} \
    && ./configure --help \
    && ./configure --prefix=/opt/local/osu-micro-benchmarks-${OSU_VERSION} \
                   CXX=$(which mpicxx) CC=$(which mpicc) FC=$(which mpif90) F77=$(which mpif77) LIBS="-L${CUDA_HOME}/targets/x86_64-linux/lib -lcudart" \
                   --enable-cuda --with-cuda=${CUDA_HOME} \
    && make -j 8 V=0 && rm -rf /opt/local/osu-micro-benchmarks-${OSU_VERSION} && make install \
    && cd && rm -rf /tmp/osu-micro-benchmarks-${OSU_VERSION} \
    && cd /opt/local && mpicxx -o hello_world_mpi /home/plainuser/hello_world_mpi.C -fopenmp \
    && docker-clean

# Local Variables:
# mode: sh
# End:
