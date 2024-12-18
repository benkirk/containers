FROM benjaminkirk/opensuse15-openhpc-openmpi:latest

ARG MPI_FAMILY=openmpi4
ARG MPI_FAMILY_VARIANT=openmpi4
ARG COMPILER_VERSION=gnu12

USER root

# https://developer.nvidia.com/cuda-12-2-2-download-archive?target_os=Linux&target_arch=x86_64&Distribution=OpenSUSE&target_version=15&target_type=rpm_local
RUN echo "Cuda" \
    && cd /tmp \
    && curl -O https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda-repo-opensuse15-12-2-local-12.2.2_535.104.05-1.x86_64.rpm \
    && rpm -i cuda-repo-opensuse15-12-2-local-12.2.2_535.104.05-1.x86_64.rpm \
    && zypper -n --no-gpg-checks refresh \
    && zypper -n --no-gpg-checks install -y cuda \
    && echo "removing unnecessary NVIDIA components to shrink container image" \
    && rm -rf \
          /var/cuda-repo-opensuse15-*-*-local/{tmp,*.rpm} \
          /opt/nvidia \
          /usr/local/cuda-*.*/nsightee_plugins/ \
          /usr/local/cuda-*.*/compute-sanitizer/ \
    && find /usr/local/cuda-*.*/ -name "*_static.a"  | xargs rm -f \
    && docker-clean

RUN mkdir /opt/ohpc/pub/modulefiles/cuda
COPY extras/cuda-12.2 /opt/ohpc/pub/modulefiles/cuda/12.2

RUN echo "RDMA prereqs" \
    && set -x \
    && zypper -n --no-gpg-checks install libibverbs-devel libpsm2-devel \
    && docker-clean


ARG OPENMPI_VERSION=4.1.6

RUN whoami && module avail \
    && module load -openmpi +hwloc +libfabric +cuda && module list \
    && cd /tmp && curl -sSL https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-${OPENMPI_VERSION}.tar.gz | tar xz \
    && cd openmpi-${OPENMPI_VERSION} \
    && ./configure --prefix=/opt/ohpc/pub/mpi/${MPI_FAMILY}-${COMPILER_VERSION}-cuda/${OPENMPI_VERSION} \
                   CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) PYTHON=$(which python3) \
                   --disable-static --enable-builtin-atomics \
                   --with-sge --enable-mpi-cxx \
                   --with-hwloc=${HWLOC_DIR} \
                   --with-libfabric=${LIBFABRIC_DIR} \
                   --with-ucx=${UCX_DIR} \
                   --without-verbs \
                   --with-cuda=${CUDA_HOME} \
    && make -j 8 && make install \
    && docker-clean

COPY extras/${MPI_FAMILY}-${OPENMPI_VERSION}-cuda /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/${MPI_FAMILY}/${OPENMPI_VERSION}-cuda

## COPY extras/hello_world_mpi.C /home/plainuser/
## COPY extras/bootstrap_libmesh.sh /home/plainuser/
## COPY extras/install_benchmarks.sh /home/plainuser/
##
## RUN mkdir -p /container \
##     && chown -R plainuser: /home/plainuser/ /container

USER plainuser
SHELL ["/bin/bash", "-lc"]


### # Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
### RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /container/mpich-3.4.3-cuda/bin/mpicxx
###
### RUN whoami && module avail \
###     && module load mpich/3.4.3-ofi-cuda cuda && module list \
###     && sh /home/plainuser/install_benchmarks.sh

# Local Variables:
# mode: sh
# End:
