FROM docker.io/almalinux:8

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum: initial update " \
    && set -x \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && adduser plainuser && mkdir -p /opt/local && chown plainuser: /opt/local \
    && yum -y update \
    && docker-clean

RUN echo "dnf: config" \
    && set -x \
    && dnf -y install yum-utils && dnf config-manager --set-enabled powertools && dnf repolist \
    && docker-clean

RUN echo "yum: addons" \
    && dnf -y install \
           gcc gcc-c++ make autoconf automake \
           wget git which tar bzip2 \
           diffutils openssl-devel \
    && docker-clean

RUN echo "yum: addons" \
    && dnf -y install \
           python2 python3 \
    && docker-clean

USER plainuser
ADD extras/hello_world_mpi.C /opt/local/hello_world_mpi.C
RUN echo "shell customization}" \
    && echo "# Matlab-style history" >> ~/.bashrc \
    && echo "bind '\"\\e[A\"':history-search-backward" >> ~/.bashrc \
    && echo "bind '\"\\e[B\"':history-search-forward" >> ~/.bashrc

SHELL ["/bin/bash", "-lc"]

RUN echo "git upstream" \
    && docker-clean

# Local Variables:
# mode: sh
# End:
