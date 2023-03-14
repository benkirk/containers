FROM centos:7

ARG BUILD_STAGE_PATH="/pv/path_for/bundle"

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum update" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && mkdir /opt/local \
    && yum update -y \
    && docker-clean \
    && adduser plainuser && mkdir -p /opt/local && chown plainuser: /opt/local

RUN echo "yum addons" \
    && yum install -y \
           gcc gcc-c++ make autoconf automake \
           wget git which tar bzip2 \
           openssl-devel \
           glibc-static \
           zlib-static \
           blas-static \
           lapack-static \
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
    && mkdir -p centos7/devel && cd centos7/devel \
    && ${BUILD_STAGE_PATH}/libmesh_build_support/configure -C --prefix=$(pwd) \
    && docker-clean

RUN echo "setup build env: stable" \
    && cd ${BUILD_STAGE_PATH} \
    && source ${BUILD_STAGE_PATH}/libmesh_build_support/utils/versions/stable.sh \
    && mkdir -p centos7/stable && cd centos7/stable \
    && ${BUILD_STAGE_PATH}/libmesh_build_support/configure -C --prefix=$(pwd) \
    && docker-clean

RUN echo "setup build env: default" \
    && cd ${BUILD_STAGE_PATH} \
    && source ${BUILD_STAGE_PATH}/libmesh_build_support/utils/versions/default.sh \
    && mkdir -p centos7/default && cd centos7/default \
    && ${BUILD_STAGE_PATH}/libmesh_build_support/configure -C --prefix=$(pwd) \
    && docker-clean


# Local Variables:
# mode: sh
# End:
