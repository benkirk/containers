ARG ARCH=amd64
FROM --platform=linux/${ARCH} benjaminkirk/ncar-derecho-wrf-base:latest

ENV NVHPC_VERSION=23.9
RUN cd /tmp \
    && echo "Downloading NVHPC v${NVHPC_VERSION}" \
    && curl -sSL https://developer.download.nvidia.com/hpc-sdk/23.9/nvhpc_2023_239_Linux_x86_64_cuda_12.2.tar.gz | tar zx \
    && echo "Installing NVHPC v${NVHPC_VERSION}" \
    && NVHPC_SILENT="true" \
       NVHPC_INSTALL_DIR="/container/nvidia/hpc_sdk" \
       NVHPC_INSTALL_TYPE="single" \
       ./nvhpc_2023_239_Linux_x86_64_cuda_12.2/install \
    && cd /container \
    && echo -e "\n# NVHPC version ${NVHPC_VERSION}" >> config_env.sh \
    && echo "export NVARCH=`uname -s`_`uname -m`" >> config_env.sh \
    && echo "export NVCOMPILERS=/container/nvidia/hpc_sdk" >> config_env.sh \
    && echo "export MANPATH=\$MANPATH:\$NVCOMPILERS/\$NVARCH/${NVHPC_VERSION}/compilers/man" >> config_env.sh \
    && echo "export PATH=\$NVCOMPILERS/\$NVARCH/${NVHPC_VERSION}/compilers/bin:\$PATH" >> config_env.sh \
    && cd /container/nvidia/hpc_sdk/Linux_x86_64/${NVHPC_VERSION} \
    && rm_paths="comm_libs cuda math_libs profilers" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && echo "/container/nvidia/hpc_sdk/Linux_x86_64/${NVHPC_VERSION}/compilers/lib" >> /etc/ld.so.conf.d/nvhpc.conf \
    && ldconfig --verbose \
    && rm -rf ${rm_paths} \
    && docker-clean

ENV MPICH_VERSION=3.4.3
ENV HDF5_VERSION=1.10.11
ENV NETCDF_C_VERSION=4.9.2
ENV NETCDF_FORTRAN_VERSION=4.6.1

# install desired HDF5 & NETCDF libraries.  we put these into the library search path via
# ldconfig so that they can be found within the final contaner image irrespective of LD_LIBRARY_PATH
RUN mkdir -p /container/hdf5/BUILD_DIR \
    && source /container/config_env.sh \
    && cd /container/hdf5/BUILD_DIR \
    && curl -sSL https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz | tar zx \
    && cd hdf5-${HDF5_VERSION} \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
           --prefix=/container/hdf5 \
           --enable-hl \
           --disable-cxx \
           --enable-fortran \
           --disable-parallel \
           --with-szlib=no \
           --disable-dependency-tracking \
    && make -j 4 && make install \
    && echo -e "\n# HDF5 libraries" >> /container/config_env.sh \
    && echo "PATH=/container/hdf5/bin:\${PATH}" >> /container/config_env.sh \
    && echo "/container/hdf5/lib" >> /etc/ld.so.conf.d/hdf5.conf \
    && ldconfig --verbose \
    && rm -rf /container/hdf5/BUILD_DIR \
    && docker-clean

RUN mkdir -p /container/netcdf/BUILD_DIR \
    && source /container/config_env.sh \
    && cd /container/netcdf/BUILD_DIR \
    && curl -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd netcdf-c-${NETCDF_C_VERSION} \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
           CPPFLAGS="-I/container/hdf5/include" \
           LDFLAGS="-L/container/hdf5/lib" \
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
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
           CPPFLAGS="-I/container/netcdf/include -I/container/hdf5/include" \
           LDFLAGS="-L/container/netcdf/lib -L/container/hdf5/lib" \
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
#
# mpich-3.4.3 and nvfortran misunderstand each other regarding real*16, avoid false positive.
# so we take the rather drastic step of modyfying configure.ac to prevent building the f08 interface,
# no matter what configure *thinks* it finds...
RUN mkdir -p /container/mpich/BUILD_DIR \
    && cd /container/mpich/BUILD_DIR \
    && source /container/config_env.sh \
    && curl -sSL http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar zx \
    && cd mpich-${MPICH_VERSION} \
    && sed -i 's/f08_works=yes/f08_works=no/g' configure.ac \
    && ./autogen.sh \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
           --prefix=/container/mpich \
           --with-wrapper-dl-type=none \
           --with-device=ch4:ofi \
           --disable-dependency-tracking \
           --enable-fortran | tee /container/mpich/configure-out.log \
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
ENV HDF5 /container/hdf5
ENV NETCDF /container/netcdf

# Ok, all done - let's indicate the environment
RUN echo -e "\nPS1=\"WRF-nvhpc-dev> \"" >> /container/config_env.sh

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
