# docker build --progress=plain --tag benjaminkirk/opensuse15-openhpc2-openmpi4:0.0.1 --build-arg MPI_FAMILY=openmpi4 --build-arg MPI_FAMILY_VARIANT=openmpi4 .
# docker run --rm -it benjaminkirk/opensuse15-openhpc2-openmpi4:0.0.1 /bin/bash -l

FROM docker.io/opensuse/leap
MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

ARG MPI_FAMILY=mpich
ARG MPI_FAMILY_VARIANT=mpich-ucx

# Basic OpenHPC development environment setup, derived from Install_guide-Leap_15-Warewulf-SLURM-2.4-x86_64.pdf
RUN echo "basic zypper setup" \
    && set -x \
    && docker-clean \
    && useradd plainuser  \
    && zypper -n install curl xz \
    && cd /tmp/ && curl -O http://repos.openhpc.community/OpenHPC/2/Leap_15/x86_64/ohpc-release-2-1.leap15.x86_64.rpm && zypper -n --no-gpg-checks install ./ohpc-release-2-1.leap15.x86_64.rpm && rm -f ./ohpc-release-2-1.leap15.x86_64.rpm \
    && zypper -n --no-gpg-checks update \
    && zypper -n --no-gpg-checks install ohpc-base \
    && zypper -n --no-gpg-checks install lmod-ohpc nhc-ohpc ohpc-autotools \
    && zypper -n --no-gpg-checks install gnu9-compilers-ohpc \
    && zypper -n --no-gpg-checks install hwloc-ohpc spack-ohpc valgrind-ohpc \
    && zypper -n --no-gpg-checks install ${MPI_FAMILY_VARIANT}-gnu9-ohpc \
    && zypper -n --no-gpg-checks install lmod-defaults-gnu9-${MPI_FAMILY_VARIANT}-ohpc \
    # && zypper -n install ohpc-gnu9-perf-tools
    && zypper search petsc-gnu9 trilinos-gnu9 \
    && docker-clean

# Addons Ben wants to play with
RUN echo "Extra packages" \
    && set -x \
    && zypper -n --no-gpg-checks install \
              boost-gnu9-${MPI_FAMILY}-ohpc \
              fftw-gnu9-${MPI_FAMILY}-ohpc \
              gsl-gnu9-ohpc \
              hdf5-gnu9-ohpc phdf5-gnu9-${MPI_FAMILY}-ohpc \
              netcdf-gnu9-${MPI_FAMILY}-ohpc \
              openblas-gnu9-ohpc \
    && docker-clean

# Addons Ben wants to play with
RUN echo "More extra packages" \
    && set -x \
    && zypper -n --no-gpg-checks install \
           petsc-gnu9-${MPI_FAMILY}-ohpc \
    && docker-clean


COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

RUN chown -R plainuser: /home/plainuser/
USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail

# Local Variables:
# mode: sh
# End:
