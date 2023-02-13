FROM docker.io/rockylinux/rockylinux:9
MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y install dnf-plugins-core \
    && dnf -y update \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
           bzip2 autoconf automake libtool \
           gcc gcc-c++ gcc-gfortran emacs make procps-ng mpich-devel \
    && docker-clean \
    && adduser plainuser && mkdir /opt/local && chown plainuser: /opt/local

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && export MPI_BUILD=mpich-x86_64 \
    && module load mpi/${MPI_BUILD} \
    && cd /tmp && curl -SL https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.0.1.tar.gz | tar zx && cd osu-micro-benchmarks-7.0.1 \
    && ./configure --prefix=/opt/local/osu-micro-benchmarks-7.0.1 \
                   CXX=`which mpicxx` CC=`which mpicc` FC=`which mpif90` F77=`which mpif77` \
    && make -j V=0 && make install \
    && cd && rm -rf /tmp/osu-micro-benchmarks-7.0.1 \
    && cd /opt/local && mpicxx -o hello_world_mpi ~/hello_world_mpi.C -fopenmp \
    && docker-clean

RUN whoami && module avail \
    && export MPI_BUILD=mpich-x86_64 \
    && module load mpi/${MPI_BUILD} \
    && cd /opt/local && git clone https://github.com/intel/mpi-benchmarks.git imb-2021.3 \
    && cd /opt/local/imb-2021.3 && git checkout 8ba5d968272b6e7b384f91b6597d1c4590faf3db \
    && CXX=`which mpicxx` CC=`which mpicc` make \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean \
    && make -C src_cpp -f Makefile TARGET=NBC clean\
    && make -C src_cpp -f Makefile TARGET=RMA clean \
    && make -C src_cpp -f Makefile TARGET=EXT clean \
    && make -C src_cpp -f Makefile TARGET=IO clean \
    && make -C src_cpp -f Makefile TARGET=MT clean \
    && make -C src_c/P2P -f Makefile TARGET=P2P clean \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean GPU_ENABLE=1 \
    && docker-clean

# docker build --progress=plain --tag benjaminkirk/rocky9-libmesh-prereqs:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/rocky9-libmesh-prereqs:0.0.1 /bin/bash

# Local Variables:
# mode: sh
# End:
