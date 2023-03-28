# docker build --progress=plain --tag benjaminkirk/opensuse15-openhpc2-openmpi4:0.0.1 --build-arg MPI_FAMILY=openmpi4 --build-arg MPI_FAMILY_VARIANT=openmpi4 .
# docker run --rm -it benjaminkirk/opensuse15-openhpc2-openmpi4:0.0.1 /bin/bash -l

FROM docker.io/opensuse/leap

#MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

ADD extras/docker-clean /usr/bin/docker-clean

ARG MPI_FAMILY=mpich
ARG MPI_FAMILY_VARIANT=mpich-ofi
ARG COMPILER_VERSION=gnu12

# Basic OpenHPC development environment setup, derived from Install_guide-Leap_15-Warewulf-SLURM-2.4-x86_64.pdf
RUN echo "basic zypper setup" \
    && set -x \
    && docker-clean \
    && useradd plainuser  \
    && zypper -n install curl xz git tar \
    && cd /tmp/ && curl -O http://repos.openhpc.community/OpenHPC/2/Leap_15/x86_64/ohpc-release-2-1.leap15.x86_64.rpm && zypper -n --no-gpg-checks install ./ohpc-release-2-1.leap15.x86_64.rpm && rm -f ./ohpc-release-2-1.leap15.x86_64.rpm \
    && zypper -n --no-gpg-checks update \
    && zypper -n --no-gpg-checks install ohpc-base \
    && zypper -n --no-gpg-checks install lmod-ohpc nhc-ohpc ohpc-autotools \
    && zypper -n --no-gpg-checks install ${COMPILER_VERSION}-compilers-ohpc \
    && zypper -n --no-gpg-checks install hwloc-ohpc valgrind-ohpc \
    && zypper -n --no-gpg-checks install ${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc \
    && zypper -n --no-gpg-checks install lmod-defaults-${COMPILER_VERSION}-${MPI_FAMILY_VARIANT}-ohpc \
    && docker-clean

RUN echo "Cuda" \
    && zypper -n --no-gpg-checks addrepo https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/cuda-opensuse15.repo \
    && zypper -n --no-gpg-checks refresh \
    && zypper -n --no-gpg-checks install -y cuda \
    && docker-clean

# # Addons Ben wants to play with
# RUN echo "Extra packages" \
#     && set -x \
#     && zypper -n --no-gpg-checks install \
#               boost-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
#               fftw-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
#               gsl-${COMPILER_VERSION}-ohpc \
#               hdf5-${COMPILER_VERSION}-ohpc phdf5-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
#               netcdf-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
#               openblas-${COMPILER_VERSION}-ohpc \
#     && docker-clean
#
# # Addons Ben wants to play with
# RUN echo "More extra packages" \
#     && set -x \
#     && zypper -n --no-gpg-checks install \
#               petsc-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
#     && docker-clean


# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/ohpc/pub/mpi/${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc/3.4.3/bin/mpicxx

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/
COPY extras/install_benchmarks.sh /home/plainuser/

RUN mkdir -p /opt/local \
    && chown -R plainuser: /home/plainuser/ /opt/local

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && module load ${MPI_FAMILY} \
    && sh /home/plainuser/install_benchmarks.sh

RUN whoami && module avail \
    && module load libfabric hwloc gnu12 \
    && cd /tmp && curl -sSL https://www.mpich.org/static/downloads/4.1.1/mpich-4.1.1.tar.gz | tar xz \
    && cd mpich-4.1.1 \
    && ./configure --prefix=/opt/local/mpich-4.1.1-cuda \
                   CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) PYTHON=$(which python3) \
                   --enable-fortran \
                   --disable-cxx \
                   --with-libfabric=${LIBFABRIC_DIR} \
                   --with-hwloc=${HWLOC_DIR} \
                   --with-cuda=/usr/local/cuda-12.1 \
    && make -j 8 && make install \
    && docker-clean




# Local Variables:
# mode: sh
# End:
