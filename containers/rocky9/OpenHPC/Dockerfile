FROM docker.io/rockylinux/rockylinux:9

ADD extras/docker-clean /usr/bin/docker-clean

ARG COMPILER_VERSION=gnu12

# Basic OpenHPC development environment setup, derived from Install_guide-Rocky8-Warewulf-SLURM-2.4
RUN echo "yum/dnf config" \
    && set -x \
    && adduser plainuser \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y update \
    && yum -y install --allowerasing which git tar curl xz bzip2 patch \
    && yum -y install http://repos.openhpc.community/OpenHPC/3/EL_9/x86_64/ohpc-release-3-1.el9.x86_64.rpm \
    && yum -y install dnf-plugins-core \
    && yum -y config-manager --set-enabled crb \
    && yum -y install ohpc-base \
    && yum -y install lmod-ohpc ohpc-autotools \
    && yum -y install ${COMPILER_VERSION}-compilers-ohpc \
    && docker-clean

RUN mkdir -p /opt/local \
    && chown -R plainuser: /home/plainuser/ /opt/local

USER plainuser
SHELL ["/bin/bash", "-lc"]

# Local Variables:
# mode: sh
# End:
