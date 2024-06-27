FROM docker.io/opensuse/leap

ADD extras/docker-clean /usr/bin/docker-clean

ARG MPI_FAMILY=mpich
ARG MPI_FAMILY_VARIANT=mpich-ofi
ARG COMPILER_VERSION=gnu9

# Basic OpenHPC development environment setup, derived from Install_guide-Leap_15-Warewulf-SLURM-2.4-x86_64.pdf
RUN echo "basic zypper setup" \
    && set -x \
    && docker-clean \
    && useradd plainuser  \
    && zypper -n install curl xz git tar \
    && cd /tmp/ && curl -O http://repos.openhpc.community/OpenHPC/2/Leap_15/x86_64/ohpc-release-2-1.leap15.x86_64.rpm && zypper -n --no-gpg-checks install ./ohpc-release-2-1.leap15.x86_64.rpm && rm -f ./ohpc-release-2-1.leap15.x86_64.rpm \
    && zypper -n --no-gpg-checks update \
    && zypper -n --no-gpg-checks install ohpc-base \
    && zypper -n --no-gpg-checks install lmod-ohpc nhc-ohpc ohpc-autotools hwloc-ohpc valgrind-ohpc \
    && zypper -n --no-gpg-checks install ${COMPILER_VERSION}-compilers-ohpc \
    && zypper -n --no-gpg-checks install ${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc \
    && zypper -n --no-gpg-checks install lmod-defaults-${COMPILER_VERSION}-${MPI_FAMILY_VARIANT}-ohpc \
    && docker-clean

# https://developer.nvidia.com/cuda-11-7-1-download-archive
RUN echo "Cuda" \
    && curl -O https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-opensuse15-11-7-local-11.7.1_515.65.01-1.x86_64.rpm \
    && rpm -i cuda-repo-opensuse15-11-7-local-11.7.1_515.65.01-1.x86_64.rpm && rm -f cuda-repo-opensuse15-11-7-local-11.7.1_515.65.01-1.x86_64.rpm \
    && zypper -n --no-gpg-checks refresh \
    && zypper -n --no-gpg-checks install -y cuda \
    && docker-clean

RUN echo "RDMA prereqs" \
    && set -x \
    && zypper -n --no-gpg-checks install libibverbs-devel libpsm2-devel \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/ohpc/pub/mpi/${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc/3.4.2/bin/mpicxx

RUN mkdir /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda
COPY extras/cuda-11.7 /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda/11.7
COPY extras/3.4.3-ofi-cuda /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/mpich/
COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/
COPY extras/install_benchmarks.sh /home/plainuser/

RUN mkdir -p /opt/local \
    && chown -R plainuser: /home/plainuser/ /opt/local

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && module load -mpich +hwloc +libfabric +cuda && module list \
    && cd /tmp && curl -sSL https://www.mpich.org/static/downloads/3.4.3/mpich-3.4.3.tar.gz | tar xz \
    && cd mpich-3.4.3 \
    && ./configure --prefix=/opt/local/mpich-3.4.3-cuda \
                   CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) PYTHON=$(which python3) \
                   --enable-fortran \
                   --with-libfabric=${LIBFABRIC_DIR} \
                   --with-hwloc-prefix=${HWLOC_DIR} \
                   --with-cuda=${CUDA_HOME} \
    && make -j 8 && make install \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/local/mpich-3.4.3-cuda/bin/mpicxx

RUN whoami && module avail \
    && module load mpich/3.4.3-ofi-cuda cuda && module list \
    && sh /home/plainuser/install_benchmarks.sh

# Local Variables:
# mode: sh
# End:
