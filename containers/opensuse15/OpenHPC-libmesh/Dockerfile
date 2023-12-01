# docker build --progress=plain --tag benjaminkirk/opensuse15-openhpc2-openmpi4-libmesh:0.0.1 .
# docker run --rm --user plainuser -it benjaminkirk/opensuse15-openhpc2-openmpi4-libmesh:0.0.1 /bin/bash -l

FROM benjaminkirk/opensuse15-openhpc:latest
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

USER plainuser
SHELL ["/bin/bash", "-lc"]

ARG MPI_FAMILY=mpich
ARG MPI_BUILD=mpich-x86_64
ARG LIBMESH_VERSION=1.8.0-pre

RUN whoami && echo ${LIBMESH_VERSION}-${MPI_BUILD} && module avail \
    && module load petsc boost \
    && mkdir -p ~/codes && cd ~/codes \
    && git clone \
           --recurse-submodules \
           --depth 1 \
           https://github.com/libMesh/libmesh.git \
    && cd libmesh && ./bootstrap \
    && ./configure --prefix=/opt/local/libmesh/${LIBMESH_VERSION}-${MPI_BUILD} \
            --with-cxx="$(which mpicxx) -Wl,-rpath,${PETSC_LIB} -Wl,-rpath,${SCALAPACK_LIB} -Wl,-rpath,${OPENBLAS_LIB}" \
            --with-cc=$(which mpicc) \
            --with-fc=$(which mpif90) \
            --with-f77=$(which mpif77) \
            --disable-dependency-tracking \
            --with-methods=opt \
            --enable-optional --disable-strict-lgpl \
            --enable-hdf5 --enable-hdf5-required \
    && nice make --no-print-directory -j 3 all \
    && nice make --no-print-directory install \
    && rm -rf /home/plainuser/codes/libmesh/

RUN whoami && echo ${LIBMESH_VERSION}-${MPI_BUILD} && module avail \
    && export LIBMESH_DIR=/opt/local/libmesh/${LIBMESH_VERSION}-${MPI_BUILD} && export METHOD=opt \
    && cd ${LIBMESH_DIR}/examples && find . -name run.sh | xargs chmod +x \
    && cd ${LIBMESH_DIR}/examples/adaptivity/ex2 && make --no-print-directory all && ldd ./example-opt && ./run.sh && ls \
    && make --no-print-directory clobber && ls \
    && cd ${LIBMESH_DIR}/examples/introduction/ex4  && make --no-print-directory all && ldd ./example-opt && ./run.sh  && ls \
    && mpiexec -n 4 ./example-opt -d 3 -n 25 \
    && make --no-print-directory clean && ls


# Local Variables:
# mode: sh
# End:
