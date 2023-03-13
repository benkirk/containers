FROM centos:7

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
           glibc-static \
           zlib-devel zlib-static \
           openssl-devel \
    && docker-clean


USER plainuser
ADD extras/hello_world_mpi.C /opt/local/hello_world_mpi.C
RUN echo "shell customization}" \
    && echo "# Matlab-style history" >> ~/.bashrc \
    && echo "bind '\"\\e[A\"':history-search-backward" >> ~/.bashrc \
    && echo "bind '\"\\e[B\"':history-search-forward" >> ~/.bashrc

SHELL ["/bin/bash", "-lc"]

########################################
## NOTES:
##   bash-4.2# rpm -qa | grep mpich
##   mpich-3.2-3.2-2.el7.x86_64
##   mpich-3.2-devel-3.2-2.el7.x86_64
########################################


# Local Variables:
# mode: sh
# End:
