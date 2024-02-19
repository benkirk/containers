FROM docker.io/rockylinux/rockylinux:8
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && dnf -y update \
    && dnf -y install \
           gcc emacs-nox make procps-ng \
           which \
           python3 \
           git curl wget rsync \
    && docker-clean \
    && adduser plainuser && mkdir /pv && chown plainuser: /pv

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN mkdir -p /pv/repos && cd /pv/repos/ \
    && git clone --branch v0.20.2-BSK -c feature.manyFiles=true https://github.com/benkirk/spack.git \
    && git clone --branch rebase-spack-v0.20.x https://github.com/benkirk/spack-deployment.git \
    && docker-clean

VOLUME /home
VOLUME /pv

# Local Variables:
# mode: sh
# End:
