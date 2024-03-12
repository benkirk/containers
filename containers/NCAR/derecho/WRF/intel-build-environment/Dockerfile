ARG ARCH=amd64
FROM --platform=linux/${ARCH} benjaminkirk/ncar-derecho-wrf-base:latest

# Download URLs for installers inferred from spack:
# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/intel-oneapi-compilers/package.py
RUN mkdir -p /tmp/intel_installers && cd /tmp/intel_installers \
    && wget -q https://registrationcenter-download.intel.com/akdlm/irc_nas/19049/l_dpcpp-cpp-compiler_p_2022.2.1.16991_offline.sh \
    && wget -q https://registrationcenter-download.intel.com/akdlm/irc_nas/18998/l_fortran-compiler_p_2022.2.1.16992_offline.sh \
    && chmod +x l_*compiler*.sh \
    && ./l_dpcpp-cpp-compiler_p_2022.2.1.16991_offline.sh -a -s --eula accept --install-dir /container/intel --ignore-errors \
    && ./l_fortran-compiler_p_2022.2.1.16992_offline.sh -a -s --eula accept --install-dir /container/intel --ignore-errors \
    && cd /container/intel \
    && rm_paths="mpi debugger tbb conda_channel compiler/2022.2.1/linux/lib/oclfpga" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} /tmp/intel_installers /var/intel \
    && echo -e "\n# Intel compilers libraries" >> /container/config_env.sh \
    && echo "source /container/intel/setvars.sh >/dev/null 2>&1" >> /container/config_env.sh \
    && docker-clean

# Intel compilers do not -rpath their own libraries, relying instead on LD_LIBRARY_PATH
# We'd rather not need that, so add to the system search path
RUN echo "/container/intel/compiler/2022.2.1/linux/lib"     >> /etc/ld.so.conf.d/intel.conf \
    && echo "/container/intel/compiler/2022.2.1/linux/lib/x64" >> /etc/ld.so.conf.d/intel.conf \
    && echo "/container/intel/compiler/2022.2.1/linux/compiler/lib/intel64_lin" >> /etc/ld.so.conf.d/intel.conf \
    && ldconfig --verbose \
    && echo "silence classic compilers" \
    && echo "-diag-disable=10441" >> /container/intel/compiler/2022.2.1/linux/bin/intel64/icc.cfg \
    && echo "-diag-disable=10441" >> /container/intel/compiler/2022.2.1/linux/bin/intel64/icpc.cfg \
    && echo "-diag-disable=10441" >> /container/intel/compiler/2022.2.1/linux/bin/intel64/ifort.cfg

ENV MPICH_VERSION=3.4.3
#ENV HDF5_VERSION=1.10.11
ENV NETCDF_C_VERSION=4.9.2
ENV NETCDF_FORTRAN_VERSION=4.6.1

# install desired HDF5 & NETCDF libraries.  we put these into the library search path via
# ldconfig so that they can be found within the final contaner image irrespective of LD_LIBRARY_PATH
# RUN mkdir -p /container/hdf5/BUILD_DIR \
#     && source /container/config_env.sh \
#     && cd /container/hdf5/BUILD_DIR \
#     && curl -sSL https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz | tar zx \
#     && cd hdf5-${HDF5_VERSION} \
#     && ./configure \
#            CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
#            --prefix=/container/hdf5 \
#            --enable-hl \
#            --disable-cxx \
#            --enable-fortran \
#            --disable-parallel \
#            --with-szlib=no \
#            --disable-dependency-tracking \
#     && make -j 4 && make install \
#     && echo -e "\n# HDF5 libraries" >> /container/config_env.sh \
#     && echo "PATH=/container/hdf5/bin:\${PATH}" >> /container/config_env.sh \
#     && echo "/container/hdf5/lib" >> /etc/ld.so.conf.d/hdf5.conf \
#     && ldconfig --verbose \
#     && rm -rf /container/hdf5/BUILD_DIR \
#     && docker-clean

# install desired MPI library. we DO NOT put this into the library search path,
# because later we will override this MPI at runtime via host MPI injection and
# associated LD_LIBRARY_PATH manipulations
RUN mkdir -p /container/netcdf/BUILD_DIR \
    && source /container/config_env.sh \
    && cd /container/netcdf/BUILD_DIR \
    && curl -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd netcdf-c-${NETCDF_C_VERSION} \
    && ./configure \
           CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
           --prefix=/container/netcdf \
           --disable-libxml2 \
           --disable-dap \
           --disable-byterange \
           --disable-dependency-tracking \
    && make -j 4 && make install \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh && echo "PATH=/container/netcdf/bin:\${PATH}" >> /container/config_env.sh \
    && echo "LD_LIBRARY_PATH=/container/netcdf/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "/container/netcdf/lib" >> /etc/ld.so.conf.d/netcdf.conf \
    && ldconfig --verbose \
    && cd /container/netcdf/BUILD_DIR \
    && cd netcdf-fortran-${NETCDF_FORTRAN_VERSION}/ \
    && ./configure \
           CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
           CPPFLAGS="-I/container/netcdf/include" \
           LDFLAGS="-L/container/netcdf/lib" \
           --prefix=/container/netcdf \
           --disable-dap \
           --disable-dependency-tracking \
    && make -j 4 && make install \
    && ldconfig --verbose \
    && rm -rf /container/netcdf/BUILD_DIR \
    && docker-clean

RUN mkdir -p /container/mpich/BUILD_DIR \
    && cd /container/mpich/BUILD_DIR \
    && source /container/config_env.sh \
    && curl -sSL http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar zx \
    && cd mpich-${MPICH_VERSION} \
    && ./configure CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
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
#ENV HDF5 /container/hdf5
ENV NETCDF /container/netcdf

# Ok, all done - let's indicate the environment
RUN echo -e "\nPS1=\"WRF-intel-dev> \"" >> /container/config_env.sh

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
