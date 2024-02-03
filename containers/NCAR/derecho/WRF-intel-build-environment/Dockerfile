FROM benjaminkirk/ncar-derecho-site_customizations:latest

RUN echo "zypper install of additional WRF build dependencies" \
    && set -x \
    && zypper -n install \
              emacs-nox \
              tcsh time file hostname perl \
              flex byacc \
              zlib zlib-devel \
              jasper libjasper-devel \
              file flex \
              libtirpc-devel \
              libpng16-devel \
              rsync \
    && docker-clean

RUN mkdir -p /container && cd /container \
    && touch config_env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && docker-clean

# RUN zypper -n addrepo https://yum.repos.intel.com/oneapi oneAPI \
#     && zypper search -s intel-basekit \
#     && zypper install intel-oneapi-compiler-fortran-2021.4.0 \
#     && docker-clean

# Download URLs for installers inferred from spack:
# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/intel-oneapi-compilers/package.py
RUN mkdir -p /tmp/intel_installers && cd /tmp/intel_installers \
    && wget -q https://registrationcenter-download.intel.com/akdlm/irc_nas/19049/l_dpcpp-cpp-compiler_p_2022.2.1.16991_offline.sh \
    && wget -q https://registrationcenter-download.intel.com/akdlm/irc_nas/18998/l_fortran-compiler_p_2022.2.1.16992_offline.sh \
    && chmod +x l_*compiler*.sh \
    && ./l_dpcpp-cpp-compiler_p_2022.2.1.16991_offline.sh -a -s --eula accept --install-dir /container/intel --ignore-errors \
    && ./l_fortran-compiler_p_2022.2.1.16992_offline.sh -a -s --eula accept --install-dir /container/intel --ignore-errors \
    && cd /container/intel \
    && rm_paths="mpi debugger tbb conda_channel" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} /tmp/intel_installers /var/intel \
    && echo -e "\n# Intel compilers libraries" >> /container/config_env.sh \
    && echo "source /container/intel/setvars.sh >/dev/null 2>&1" >> /container/config_env.sh \
    && docker-clean

RUN echo "silence classic compilers" \
    && echo "-diag-disable=10441" >> /container/intel/compiler/2022.2.1/linux/bin/intel64/icc.cfg \
    && echo "-diag-disable=10441" >> /container/intel/compiler/2022.2.1/linux/bin/intel64/icpc.cfg \
    && echo "-diag-disable=10441" >> /container/intel/compiler/2022.2.1/linux/bin/intel64/ifort.cfg

ENV MPICH_VERSION=3.4.3
ENV HDF5_VERSION=1.10.11
ENV NETCDF_C_VERSION=4.9.2
ENV NETCDF_FORTRAN_VERSION=4.6.1

RUN mkdir -p /container/hdf5/BUILD_DIR \
    && source /container/config_env.sh \
    && cd /container/hdf5/BUILD_DIR \
    && curl -sSL https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz | tar zx \
    && cd hdf5-${HDF5_VERSION} \
    && ./configure \
           CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
           --prefix=/container/hdf5 \
           --enable-hl \
           --disable-cxx \
           --enable-fortran \
           --disable-parallel \
           --with-szlib=no \
    && make -j 4 && make install \
    && echo -e "\n# HDF5 libraries" >> /container/config_env.sh \
    && echo "PATH=/container/hdf5/bin:\${PATH}" >> /container/config_env.sh \
    && echo "LD_LIBRARY_PATH=/container/hdf5/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && rm -rf /container/hdf5/BUILD_DIR \
    && docker-clean

RUN mkdir -p /container/netcdf/BUILD_DIR \
    && source /container/config_env.sh \
    && cd /container/netcdf/BUILD_DIR \
    && curl -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd netcdf-c-${NETCDF_C_VERSION} \
    && ./configure \
           CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
           CPPFLAGS="-I/container/hdf5/include" \
           LDFLAGS="-L/container/hdf5/lib -Wl,-rpath,/container/hdf5/lib" \
           --prefix=/container/netcdf \
           --disable-libxml2 \
           --disable-dap \
           --disable-byterange \
    && make -j 4 && make install \
    && cd /container/netcdf/BUILD_DIR \
    && cd netcdf-fortran-${NETCDF_FORTRAN_VERSION}/ \
    && export LD_LIBRARY_PATH=/container/netcdf/lib:${LD_LIBRARY_PATH} \
    && ./configure \
           CXX=$(which icpc) CC=$(which icc) FC=$(which ifort) F77=$(which ifort) \
           CPPFLAGS="-I/container/netcdf/include -I/container/hdf5/include" \
           LDFLAGS="-L/container/netcdf/lib -Wl,-rpath,/container/netcdf/lib -L/container/hdf5/lib -Wl,-rpath,/container/hdf5/lib" \
           --prefix=/container/netcdf \
           --disable-dap \
    && make -j 4 && make install \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh && echo "PATH=/container/netcdf/bin:\${PATH}" >> /container/config_env.sh \
    && echo "LD_LIBRARY_PATH=/container/netcdf/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
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
                   --enable-fortran --disable-cxx | tee /container/mpich/configure-out.log \
    && make -j 8 install \
    && echo -e "\n# MPICH v${MPICH_VERSION} paths" >> /container/config_env.sh \
    && echo "export PATH=/container/mpich/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=/container/mpich/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && rm -rf /container/mpich/BUILD_DIR/ \
    && docker-clean

# # restore if we enable-cxx in MPICH
# RUN whoami \
#     && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /container/mpich/bin/mpicxx

RUN cd /etc/profile.d/ \
    && ln -s /container/config_env.sh ./z00-build-env.sh \
    && docker-clean

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
