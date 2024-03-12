# docker build --progress=plain --tag benjaminkirk/opensuse15-base:0.0.1 .
# docker run --user root --rm --volume $(pwd)/data:/sw -it benjaminkirk/opensuse15-base:0.0.1 /bin/bash -l

FROM docker.io/opensuse/leap
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

# Basic development environment setup
RUN echo "basic zypper setup" \
    && set -x \
    && useradd plainuser \
    && mkdir -p /home/plainuser && chown plainuser: /home/plainuser \
    && mkdir /pv && chown plainuser: /pv \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && zypper --non-interactive install \
              emacs-nox \
              curl which \
              gcc gcc-c++ gcc-fortran gmake git \
    && echo "Additional development environment setup - required to use spack" \
    && zypper --non-interactive install \
              patch gzip unzip xz bzip2 tar perl openssl python3 ncurses-devel \
              diffutils findutils \
    && docker-clean

RUN echo "additional user-owned dirs" \
    && mkdir -p /tmp-spack \
    && chown plainuser: /tmp-spack \
    && mkdir -p /cache-spack \
    && chown plainuser: /cache-spack

USER plainuser
SHELL ["/bin/bash", "-lc"]

# Local Variables:
# mode: sh
# End:
