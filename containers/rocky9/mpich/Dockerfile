FROM docker.io/rockylinux/rockylinux:9
MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y install dnf-plugins-core \
    && dnf -y update \
    && dnf config-manager --set-enabled crb \
    && dnf -y install epel-release \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
           chrpath \
           bzip2 autoconf automake libtool \
           gcc gcc-c++ gcc-gfortran emacs make procps-ng mpich-devel \
    && docker-clean \
    && adduser plainuser && mkdir /opt/local && chown plainuser: /opt/local

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/
COPY extras/install_benchmarks.sh /home/plainuser/

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /usr/lib64/mpich/bin/mpicxx

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && export MPI_BUILD=mpich-x86_64 \
    && module load mpi/${MPI_BUILD} \
    && sh /home/plainuser/install_benchmarks.sh \
    && docker-clean

# Local Variables:
# mode: sh
# End:
