FROM docker.io/almalinux:9

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

RUN echo "yum: addons" \
    && dnf -y install \
           gcc gcc-c++ make autoconf automake \
           wget git which tar bzip2 \
           diffutils openssl-devel \
    && docker-clean

RUN echo "persistent volume & permissions" \
    && mkdir -p /pv && chown plainuser: /pv/

USER plainuser
ADD extras/hello_world_mpi.C /opt/local/hello_world_mpi.C
RUN echo "shell customization}" \
    && echo "# Matlab-style history" >> ~/.bashrc \
    && echo "bind '\"\\e[A\"':history-search-backward" >> ~/.bashrc \
    && echo "bind '\"\\e[B\"':history-search-forward" >> ~/.bashrc

SHELL ["/bin/bash", "-lc"]

RUN echo "git upstream" \
    && cd /opt/local \
    && git clone https://github.com/benkirk/libmesh_build_support.git \
    && cd libmesh_build_support && ./autogen.sh \
    && docker-clean

RUN echo "setup build env" \
    && mkdir -p /pv/libMeshStack && cd /pv/libMeshStack \
    && source /opt/local/libmesh_build_support/utils/versions/devel.sh \
    && mkdir -p almalinux9/devel && cd almalinux9/devel \
    && /opt/local/libmesh_build_support/configure -C --prefix=$(pwd) \
    && docker-clean

# Local Variables:
# mode: sh
# End:
