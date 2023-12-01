FROM docker.io/rockylinux/rockylinux:8
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

ARG MPI_FAMILY=mpich
ARG MPI_FAMILY_VARIANT=mpich-ofi
ARG COMPILER_VERSION=gnu12

# Basic OpenHPC development environment setup, derived from Install_guide-Rocky8-Warewulf-SLURM-2.4
RUN echo "yum/dnf config" \
    && set -x \
    && adduser plainuser \
    # for  sudo access
    # && usermod -aG wheel plainuser \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y update \
    && yum -y install which \
    && yum -y install http://repos.openhpc.community/OpenHPC/2/EL_8/x86_64/ohpc-release-2-1.el8.x86_64.rpm \
    && yum -y install dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && yum -y install ohpc-base \
    && yum -y install lmod-ohpc nhc-ohpc ohpc-autotools \
    && yum -y install ${COMPILER_VERSION}-compilers-ohpc \
    && yum -y install hwloc-ohpc valgrind-ohpc \
    && yum -y install ${MPI_FAMILY_VARIANT}-${COMPILER_VERSION}-ohpc \
    && yum -y install lmod-defaults-${COMPILER_VERSION}-${MPI_FAMILY_VARIANT}-ohpc \
    # && yum -y install ohpc-${COMPILER_VERSION}-perf-tools
    && yum search petsc-${COMPILER_VERSION} trilinos-${COMPILER_VERSION} ohpc \
    && docker-clean

# Addons Ben wants to play with
RUN echo "Extra packages" \
    && set -x \
    && yum -y install \
           boost-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
           fftw-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
           gsl-${COMPILER_VERSION}-ohpc \
           hdf5-${COMPILER_VERSION}-ohpc phdf5-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
           netcdf-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
           openblas-${COMPILER_VERSION}-ohpc \
    && docker-clean

# Addons Ben wants to play with
RUN echo "More extra packages" \
    && set -x \
    && yum -y install \
           petsc-${COMPILER_VERSION}-${MPI_FAMILY}-ohpc \
    && docker-clean


COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail

# docker build --progress=plain --tag benjaminkirk/rocky8-openhpc2:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/rocky8-openhpc2:0.0.1 /bin/bash

# Local Variables:
# mode: sh
# End:
