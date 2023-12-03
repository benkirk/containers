FROM docker.io/rockylinux/rockylinux:8
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

ARG COMPILER_VERSION=gnu9
ARG MPI_FAMILY=mpich
ARG MPI_FAMILY_VARIANT=mpich-ofi
ARG MPICH_VERSION=3.4.3
ARG OSU_VERSION=7.2

# Basic OpenHPC development environment setup, derived from Install_guide-Rocky8-Warewulf-SLURM-2.4
RUN echo "yum/dnf config" \
    && set -x \
    && adduser plainuser \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y update \
    && yum -y install which git tar curl xz bzip2 patch \
    && yum -y install http://repos.openhpc.community/OpenHPC/2/EL_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm \
    && yum -y install dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && yum -y install ohpc-base \
    && yum -y install lmod-ohpc nhc-ohpc ohpc-autotools \
    && yum -y install ${COMPILER_VERSION}-compilers-ohpc \
    && yum -y install hwloc-ohpc valgrind-ohpc \
    && yum -y install ${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc \
    && yum -y install lmod-defaults-${COMPILER_VERSION}-${MPI_FAMILY_VARIANT}-ohpc \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/ohpc/pub/mpi/${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc/3.4.2/bin/mpicxx

#---------------------------------------------------------
# we now have a fully functional OpenHPC+MPI image,
# however it does not support CUDA.  let's add to it
# and install a similarly-versioned MPI that is cuda-aware
#---------------------------------------------------------

# https://developer.nvidia.com/cuda-11-7-1-download-archive
RUN echo "Cuda" \
    && curl -O https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm \
    && rpm -i cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm && rm -f cuda-repo-rhel8-11-7-local-11.7.1_515.65.01-1.x86_64.rpm \
    && dnf -y install cuda \
    && echo "RDMA prereqs" \
    && yum -y install libibverbs-devel libpsm2-devel \
    && echo "Minimal Python3 & tools to bootstrap MPICH" \
    && yum -y install python3 \
    && docker-clean

RUN mkdir /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda
COPY extras/cuda-11.7 /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda/11.7
COPY extras/mpich-${MPICH_VERSION}-ofi-cuda /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/mpich/${MPICH_VERSION}-ofi-cuda

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

RUN mkdir -p /opt/local \
    && chown -R plainuser: /home/plainuser/ /opt/local

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && module load -mpich +hwloc +libfabric +cuda && module list \
    && cd /tmp && curl -sSL https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar xz \
    && cd mpich-${MPICH_VERSION} \
    && ./configure --prefix=/opt/local/mpich-${MPICH_VERSION}-cuda \
                   CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) PYTHON=$(which python3) \
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
    && cd /tmp && curl -Sl  https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_VERSION}.tar.gz | tar xz \
    && cd osu-micro-benchmarks-${OSU_VERSION} \
    && ./configure --prefix=/opt/local/osu-micro-benchmarks-${OSU_VERSION} \
                   CXX=$(which mpicxx) CC=$(which mpicc) FC=$(which mpif90) F77=$(which mpif77) LIBS="-L${CUDA_HOME}/targets/x86_64-linux/lib -lcudart" \
                   --enable-cuda --with-cuda=${CUDA_HOME} \
    && make -j 8 V=0 && make install \
    && cd && rm -rf /tmp/osu-micro-benchmarks-${OSU_VERSION} \
    && cd /opt/local && mpicxx -o hello_world_mpi /home/plainuser/hello_world_mpi.C -fopenmp \
    && echo "IMB:" \
    && cd /opt/local && git clone https://github.com/intel/mpi-benchmarks.git imb-2021.3 \
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


# Local Variables:
# mode: sh
# End:
