# docker build --progress=plain --tag benjaminkirk/opensuse15-base:0.0.1 .
# docker run --user root --rm --volume $(pwd)/data:/sw -it benjaminkirk/opensuse15-base:0.0.1 /bin/bash -l

FROM docker.io/opensuse/leap
MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

#ARG MPI_FAMILY=mpich
#ARG MPI_FAMILY_VARIANT=mpich-ucx

# Basic development environment setup
RUN echo "basic zypper setup" \
    && set -x \
    && useradd plainuser  \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && zypper --non-interactive install \
              curl which \
              gcc gcc-c++ gcc-fortran gmake git \
    && docker-clean

# Additional development environment setup - required to use spack
RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive install \
              patch gzip unzip xz bzip2 tar perl openssl python3 ncurses-devel \
    && docker-clean

#  zypper --non-interactive install --recommends -t pattern devel_basis devel_C_C++ devel_tcl devel_perl devel_python3

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

RUN ln -s /sw/dot_spack /home/plainuser/.spack
RUN chown -R plainuser: /home/plainuser/
USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami

# Local Variables:
# mode: sh
# End:
