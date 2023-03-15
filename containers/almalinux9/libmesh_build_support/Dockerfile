FROM docker.io/almalinux:9

ARG BUILD_STAGE_PATH="/pv/path_for/bundle"

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

RUN echo "yum addons" \
    && yum install -y \
           emacs-nox \
    && docker-clean

RUN echo "persistent volume & permissions" \
    && mkdir -p ${BUILD_STAGE_PATH}  && chown plainuser: ${BUILD_STAGE_PATH}

USER plainuser
ADD extras/hello_world_mpi.C /opt/local/hello_world_mpi.C
RUN echo "shell customization" \
    && echo "# Matlab-style history" >> ~/.bashrc \
    && echo "bind '\"\\e[A\"':history-search-backward" >> ~/.bashrc \
    && echo "bind '\"\\e[B\"':history-search-forward" >> ~/.bashrc \
    && echo "LS_COLORS=\"no=00:fi=00:di=01;31:ln=01;34:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;35:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:\"" >> ~/.bashrc

SHELL ["/bin/bash", "-lc"]

RUN echo "git upstream" \
    && cd ${BUILD_STAGE_PATH} \
    && git clone https://github.com/benkirk/libmesh_build_support.git \
    && cd libmesh_build_support && ./autogen.sh \
    && docker-clean

RUN echo "setup build env: devel" \
    && cd ${BUILD_STAGE_PATH} \
    && source ${BUILD_STAGE_PATH}/libmesh_build_support/utils/versions/devel.sh \
    && mkdir -p almalinux9/devel && cd almalinux9/devel \
    && ${BUILD_STAGE_PATH}/libmesh_build_support/configure --prefix=$(pwd) \
    && docker-clean

# RUN echo "setup build env: stable" \
#     && cd ${BUILD_STAGE_PATH} \
#     && source ${BUILD_STAGE_PATH}/libmesh_build_support/utils/versions/stable.sh \
#     && mkdir -p almalinux9/stable && cd almalinux9/stable \
#     && ${BUILD_STAGE_PATH}/libmesh_build_support/configure --prefix=$(pwd) \
#     && docker-clean

RUN echo "setup build env: bleeding" \
    && cd ${BUILD_STAGE_PATH} \
    && source ${BUILD_STAGE_PATH}/libmesh_build_support/utils/versions/bleeding.sh \
    && mkdir -p almalinux9/bleeding && cd almalinux9/bleeding \
    && ${BUILD_STAGE_PATH}/libmesh_build_support/configure --prefix=$(pwd) \
    && docker-clean

RUN echo "setup build env: default" \
    && cd ${BUILD_STAGE_PATH} \
    && source ${BUILD_STAGE_PATH}/libmesh_build_support/utils/versions/default.sh \
    && mkdir -p almalinux9/default && cd almalinux9/default \
    && ${BUILD_STAGE_PATH}/libmesh_build_support/configure --prefix=$(pwd) \
    && docker-clean

ENV BUILD_STAGE_PATH=${BUILD_STAGE_PATH}


# Local Variables:
# mode: sh
# End:
