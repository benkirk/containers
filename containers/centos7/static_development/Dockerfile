FROM centos:7

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && mkdir /opt/local \
    && yum update -y \
    && yum groupinstall -y "Development Tools" \
    && yum install -y \
           gcc gcc-c++ wget curl git which \
           libselinux-static glibc-static \
           zlib-devel zlib-static \
           openssl-devel openssl-static \
           blas-devel blas-static \
           lapack-devel lapack-static \
    && docker-clean \
    && adduser plainuser && mkdir -p /opt/local && chown plainuser: /opt/local


USER plainuser
ADD extras/hello_world_mpi.C /opt/local/hello_world_mpi.C
RUN echo "shell customization}" \
    && echo "# Matlab-style history" >> ~/.bashrc \
    && echo "bind '\"\\e[A\"':history-search-backward" >> ~/.bashrc \
    && echo "bind '\"\\e[B\"':history-search-forward" >> ~/.bashrc

SHELL ["/bin/bash", "-lc"]



# Local Variables:
# mode: sh
# End:
