ARG ARCH=amd64
FROM --platform=linux/${ARCH} benjaminkirk/ncar-derecho-wrf-dbg-base:latest

ENV MPICH_VERSION=3.4.3
ENV NETCDF_C_VERSION=4.9.2
ENV NETCDF_FORTRAN_VERSION=4.6.1

# install desired NETCDF libraries.  we put these into the library search path via
# ldconfig so that they can be found within the final contaner image irrespective of LD_LIBRARY_PATH
RUN mkdir -p /container/netcdf/BUILD_DIR \
    && source /container/config_env.sh \
    && cd /container/netcdf/BUILD_DIR \
    && curl -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd netcdf-c-${NETCDF_C_VERSION} \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
           --prefix=/container/netcdf \
           --disable-libxml2 \
           --disable-dap \
           --disable-byterange \
           --disable-dependency-tracking \
    && make -j 4 && make install \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh && echo "PATH=/container/netcdf/bin:\${PATH}" >> /container/config_env.sh \
    && echo "/container/netcdf/lib" >> /etc/ld.so.conf.d/netcdf.conf \
    && ldconfig --verbose \
    && cd /container/netcdf/BUILD_DIR \
    && cd netcdf-fortran-${NETCDF_FORTRAN_VERSION}/ \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
           CPPFLAGS="-I/container/netcdf/include" \
           LDFLAGS="-L/container/netcdf/lib" \
           --prefix=/container/netcdf \
           --disable-dap \
           --disable-dependency-tracking \
    && make -j 4 && make install \
    && ldconfig --verbose \
    && rm -rf /container/netcdf/BUILD_DIR \
    && docker-clean

# install desired MPI library. we DO NOT put this into the library search path,
# because later we will override this MPI at runtime via host MPI injection and
# associated LD_LIBRARY_PATH manipulations
RUN mkdir -p /container/mpich/BUILD_DIR \
    && cd /container/mpich/BUILD_DIR \
    && source /container/config_env.sh \
    && curl -sSL http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar zx \
    && cd mpich-${MPICH_VERSION} \
    && ./configure --help \
    && ./configure CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
                   CXXFLAGS="-g" CFLAGS="-g" FCFLAGS="-g" F77FLAGS="-g" \
                   --enable-g=dbg \
                   --prefix=/container/mpich \
                   --with-wrapper-dl-type=none \
                   --with-device=ch4:ofi \
                   --disable-dependency-tracking \
                   --enable-fortran |& tee /container/mpich/configure-out.log \
    && make -j 8 install \
    && echo -e "\n# MPICH v${MPICH_VERSION} paths" >> /container/config_env.sh \
    && echo "export PATH=/container/mpich/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=/container/mpich/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && rm -rf /container/mpich/BUILD_DIR/ \
    && docker-clean

# We can't get mpicxx without -lmpicxx for mpich-v3.x, yet the -lmpicxx bindings are worthless
# and do not exist on our Cray-EX cray-mpich.  So at minimum, prefent them from being linked,
# since we would not then be able to override them. (sigh...)
RUN sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /container/mpich/bin/mpicxx

# environment variables useful for WRF build
ENV NETCDF=/container/netcdf

# Ok, all done - let's indicate the environment
RUN echo -e "\nPS1=\"WRF-gcc-dev> \"" >> /container/config_env.sh

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
