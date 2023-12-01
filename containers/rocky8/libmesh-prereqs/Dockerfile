FROM docker.io/rockylinux/rockylinux:8
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y install dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && dnf -y update \
    && dnf -y install epel-release \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
           bzip2 autoconf automake libtool \
           gcc gcc-c++ gcc-gfortran emacs make procps-ng mpich-devel \
           python3 cmake \
           openblas-devel hdf5-devel \
    && docker-clean \
    && adduser plainuser && mkdir /opt/local && chown plainuser: /opt/local

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && export MPI_BUILD=mpich-x86_64 \
    && module load mpi/${MPI_BUILD} \
    && cd /tmp && curl -SL https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-3.16.6.tar.gz | tar zx && cd petsc-3.16.6 \
    && export PETSC_ARCH=${MPI_BUILD} \
    && ./configure --prefix=/opt/local/petsc/3.16.6-${MPI_BUILD} \
                   --with-cxx=`which mpicxx` --with-cc=`which mpicc` --with-fc=`which mpif90` \
                   --with-shared-libraries --with-debugging=0 \
		   --with-parmetis=1     --download-parmetis=yes \
		   --with-metis=1        --download-metis=yes \
		   --with-spooles=1      --download-spooles=yes \
		   --with-hypre=1        --download-hypre=yes \
		   --with-suitesparse=1  --download-suitesparse=yes \
		   --with-scalapack=1    --download-scalapack=yes \
		   --with-blacs=1        --download-blacs=yes \
    && make --no-print-directory -j $(nprocs) PETSC_DIR=/tmp/petsc-3.16.6 PETSC_ARCH=${MPI_BUILD} all \
    && make --no-print-directory -j $(nprocs) PETSC_DIR=/tmp/petsc-3.16.6 PETSC_ARCH=${MPI_BUILD} install \
    && make --no-print-directory PETSC_DIR=/opt/local/petsc/3.16.6-${MPI_BUILD} PETSC_ARCH="" check \
    && cd && rm -rf /tmp/petsc-3.16.6/ \
    && docker-clean

# docker build --progress=plain --tag benjaminkirk/rocky8-libmesh-prereqs:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/rocky8-libmesh-prereqs:0.0.1 /bin/bash

# Local Variables:
# mode: sh
# End:
