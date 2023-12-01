#ARG MPI_FAMILY=openmpi4
ARG MPI_FAMILY=mpich

FROM benjaminkirk/rocky8-openhpc2-${MPI_FAMILY}:0.0.1
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

USER plainuser
SHELL ["/bin/bash", "-lc"]

ARG LIBMESH_VERSION=1.6.2
RUN whoami && echo ${LIBMESH_VERSION}-${MPI_FAMILY} && module avail \
    && module load petsc boost \
    && mkdir -p ~/codes && cd ~/codes \
    && git clone \
           --recurse-submodules \
           --branch v${LIBMESH_VERSION} --depth 1 \
           https://github.com/libMesh/libmesh.git \
    && cd libmesh && ./bootstrap \
    && ./configure --prefix=${HOME}/install/libmesh/${LIBMESH_VERSION}-${MPI_FAMILY} \
            --with-cxx=$(which mpicxx) \
            --with-cc=$(which mpicc) \
            --with-fc=$(which mpif90) \
            --with-f77=$(which mpif77) \
            --disable-dependency-tracking \
            --with-methods=opt \
            --enable-optional --disable-strict-lgpl \
            --enable-hdf5 --enable-hdf5-required \
    && nice make --no-print-directory all \
    && nice make --no-print-directory install \
    && rm -rf /home/plainuser/codes/libmesh/

# docker build --progress=plain --tag benjaminkirk/rocky8-openhpc2-libmesh:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/rocky8-openhpc2-libmesh:0.0.1 /bin/bash

# Local Variables:
# mode: sh
# End:
