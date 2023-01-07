# docker build --progress=plain --tag benjaminkirk/opensuse15-base:0.0.1 .
# docker run --user root --rm --volume $(pwd)/data:/sw -it benjaminkirk/opensuse15-base:0.0.1 /bin/bash -l

FROM docker.io/benjaminkirk/opensuse15-spack-prereqs:0.0.1
MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

USER root
# Additional development environment setup - required to use spack
RUN echo "docker build environment - zypper setup" \
    && whoami \
    && set -x \
    && zypper --non-interactive install \
              docker \
    && docker-clean

RUN whoami

# Local Variables:
# mode: sh
# End:
