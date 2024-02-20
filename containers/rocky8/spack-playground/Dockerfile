FROM docker.io/rockylinux/rockylinux:8
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "setup, yum/dnf updates " \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && adduser plainuser && mkdir /pv && chown plainuser: /pv \
    && yum -y install dnf-plugins-core \
    && dnf -y update \
    && dnf -y install \
           epel-release \
           gcc gcc-c++ gcc-gfortran libstdc++-devel \
           emacs-nox make procps-ng \
           tar xz bzip2 gzip unzip \
           which patch file time \
           python3 \
           git curl rsync \
           findutils diffutils \
    && docker-clean


# Notes on above:
# spack itself requires python3, curl, patch, tar, various decompressors
# podman@4 requires diffutils but doesn't specify it?


# RUN echo "yum/dnf additional" \
#     && dnf -y install \
#            lua luarocks \
#             \
#     && docker-clean


# # libxpm, libmypaint: gettext
# # libcap: doff
# RUN echo "yum/dnf OS packages needed to complete spack specs that dont fully specify dependencies... argh!" \
#     && dnf -y install \
#            gettext gettext-libs gettext-devel \
#             \
#     && docker-clean

RUN echo "additional user-owned dirs" \
    && mkdir -p /tmp-spack \
    && chown plainuser: /tmp-spack \
    && mkdir -p /cache-spack \
    && chown plainuser: /cache-spack

USER plainuser
SHELL ["/bin/bash", "-lc"]

# RUN mkdir -p /pv/repos && cd /pv/repos/ \
#     && git clone --branch v0.20.2-BSK -c feature.manyFiles=true https://github.com/benkirk/spack.git \
#     && git clone --branch rebase-spack-v0.20.x https://github.com/benkirk/spack-deployment.git \
#     && docker-clean

# VOLUME /home
# VOLUME /pv

# Local Variables:
# mode: sh
# End:
