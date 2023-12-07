FROM docker.io/rockylinux/rockylinux:9

ADD extras/docker-clean /usr/bin/docker-clean

ARG COMPILER_VERSION=gnu12
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
    && yum -y install --allowerasing which git tar curl xz bzip2 patch \
    && yum -y install http://repos.openhpc.community/OpenHPC/3/EL_9/x86_64/ohpc-release-3-1.el9.x86_64.rpm \
    && yum -y install dnf-plugins-core \
    && yum -y config-manager --set-enabled crb \
    && yum -y install ohpc-base \
    && yum -y install lmod-ohpc ohpc-autotools valgrind-ohpc \
    && yum -y install ${COMPILER_VERSION}-compilers-ohpc \
    && yum -y install ${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc \
    && yum -y install lmod-defaults-${COMPILER_VERSION}-${MPI_FAMILY_VARIANT}-ohpc \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/ohpc/pub/mpi/${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc/${MPICH_VERSION}/bin/mpicxx

RUN mkdir -p /opt/local \
    && chown -R plainuser: /home/plainuser/ /opt/local

COPY extras/hello_world_mpi.C /home/plainuser/

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN echo "Installing MPI benchmark applications" \
    && whoami && module avail && module list \
    && echo "OSU:" \
    && cd /tmp && curl -Sl https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OSU_VERSION}.tar.gz | tar xz \
    && cd osu-micro-benchmarks-${OSU_VERSION} \
    && ./configure --help \
    && ./configure --prefix=/opt/local/osu-micro-benchmarks-${OSU_VERSION} \
                   CXX=$(which mpicxx) CC=$(which mpicc) FC=$(which mpif90) F77=$(which mpif77) \
    && make -j 8 V=0 && rm -rf /opt/local/osu-micro-benchmarks-${OSU_VERSION} && make install \
    && cd && rm -rf /tmp/osu-micro-benchmarks-${OSU_VERSION} \
    && cd /opt/local && mpicxx -o hello_world_mpi /home/plainuser/hello_world_mpi.C -fopenmp \
    && echo "IMB:" \
    && cd /opt/local && rm -rf imb-2021.3 && git clone https://github.com/intel/mpi-benchmarks.git imb-2021.3 \
    && cd /opt/local/imb-2021.3 && git checkout 8ba5d968272b6e7b384f91b6597d1c4590faf3db \
    && CXX=$(which mpicxx) CC=$(which mpicc) make \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean \
    && make -C src_cpp -f Makefile TARGET=NBC clean\
    && make -C src_cpp -f Makefile TARGET=RMA clean \
    && make -C src_cpp -f Makefile TARGET=EXT clean \
    && make -C src_cpp -f Makefile TARGET=IO clean \
    && make -C src_cpp -f Makefile TARGET=MT clean \
    && make -C src_c/P2P -f Makefile TARGET=P2P clean \
    && docker-clean

# Local Variables:
# mode: sh
# End:
