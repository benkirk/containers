ARG DOCKERHUB_ROOT=foobar # dummy, make sure we get this from a --build-arg
FROM ${DOCKERHUB_ROOT}/rocky9-libmesh-prereqs

# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

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

RUN export MPI_BUILD=mpich-x86_64 \
    && export LIBMESH_DIR=/opt/local/libmesh/1.8.0-pre-${MPI_BUILD} && export METHOD=opt \
    && module load mpi/${MPI_BUILD} \
    && cd ${LIBMESH_DIR}/examples && find . -name run.sh | xargs chmod +x \
    && cd ${LIBMESH_DIR}/examples/adaptivity/ex2 && make --no-print-directory all && ldd ./example-opt && ./run.sh && ls \
    && make --no-print-directory clobber && ls \
    && cd ${LIBMESH_DIR}/examples/introduction/ex4  && make --no-print-directory all && ldd ./example-opt && ./run.sh  && ls \
    && mpiexec -n 4 ./example-opt -d 3 -n 25 \
    && make --no-print-directory clean && ls

# docker build --progress=plain --tag benjaminkirk/rocky9-libmesh:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/rocky9-libmesh:0.0.1 /bin/bash

# Local Variables:
# mode: sh
# End:
