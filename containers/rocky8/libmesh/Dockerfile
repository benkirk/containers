FROM benjaminkirk/rocky8-libmesh-prereqs:0.0.1
MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

USER plainuser
SHELL ["/bin/bash", "-lc"]

RUN whoami && module avail \
    && export MPI_BUILD=mpich-x86_64 \
    && module load mpi/${MPI_BUILD} \
    && export PETSC_DIR=/opt/local/petsc/3.16.6-${MPI_BUILD} \
    && mkdir -p ~/codes && cd ~/codes \
    && git clone \
           --recurse-submodules \
           --depth 1 \
           https://github.com/libMesh/libmesh.git \
    && cd libmesh && ./bootstrap \
    && ./configure --prefix=/opt/local/libmesh/1.8.0-pre-${MPI_BUILD} \
            --disable-dependency-tracking \
            --with-methods=opt \
            --enable-optional --disable-strict-lgpl \
            --enable-hdf5 --enable-hdf5-required \
    && make --no-print-directory all \
    && make --no-print-directory install \
    && rm -rf /home/plainuser/codes/libmesh/

# docker build --progress=plain --tag benjaminkirk/rocky8-libmesh:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/rocky8-libmesh:0.0.1 /bin/bash

# Local Variables:
# mode: sh
# End:
