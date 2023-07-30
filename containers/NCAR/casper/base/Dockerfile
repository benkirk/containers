# docker build --progress=plain --tag benjaminkirk/opensuse15-base:0.0.1 .
# docker run --user root --rm --volume $(pwd)/data:/sw -it benjaminkirk/opensuse15-base:0.0.1 /bin/bash -l

FROM docker.io/opensuse/leap
MAINTAINER Ben Kirk <benkirk@ucar.edu>

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

CMD which gcc && gcc --version && ls /usr && find /usr

# RUN chown -R plainuser: /home/plainuser/
# USER plainuser
# SHELL ["/bin/bash", "-lc"]
#
# RUN whoami

# Local Variables:
# mode: sh
# End:
