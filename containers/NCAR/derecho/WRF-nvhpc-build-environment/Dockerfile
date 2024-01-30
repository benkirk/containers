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
    && zypper -n install \
              man \
              libtool automake autoconf \
    && docker-clean

RUN mkdir -p /container && cd /container \
    && echo "# sourceme to get custom build environment" > config_env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && docker-clean

ENV MPICH_VERSION=3.4.3
ENV HDF5_VERSION=1.10.11
ENV NETCDF_C_VERSION=4.9.2
ENV NETCDF_FORTRAN_VERSION=4.6.1

# ENV NVHPC_VERSION=20.11
# RUN echo "Installing NVHPC v${NVHPC_VERSION}" \
#     && zypper addrepo https://developer.download.nvidia.com/hpc-sdk/sles/nvhpc.repo \
#     && zypper --gpg-auto-import-keys install -y nvhpc-${NVHPC_VERSION} \
#     && cd /container \
#     && echo -e "\n# NVHPC version ${NVHPC_VERSION}" >> config_env.sh \
#     && echo "export NVARCH=`uname -s`_`uname -m`" >> config_env.sh \
#     && echo "export NVCOMPILERS=/opt/nvidia/hpc_sdk" >> config_env.sh \
#     && echo "export MANPATH=\$MANPATH:\$NVCOMPILERS/\$NVARCH/${NVHPC_VERSION}/compilers/man" >> config_env.sh \
#     && echo "export PATH=\$NVCOMPILERS/\$NVARCH/${NVHPC_VERSION}/compilers/bin:\$PATH" >> config_env.sh \
#     && docker-clean

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
    && rm -rf ${rm_paths} \
    && docker-clean

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
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
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
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
           CPPFLAGS="-I/container/netcdf/include -I/container/hdf5/include" \
           LDFLAGS="-L/container/netcdf/lib -Wl,-rpath,/container/netcdf/lib -L/container/hdf5/lib -Wl,-rpath,/container/hdf5/lib" \
           --prefix=/container/netcdf \
           --disable-dap \
    && make -j 4 && make install \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh && echo "PATH=/container/netcdf/bin:\${PATH}" >> /container/config_env.sh \
    && echo "LD_LIBRARY_PATH=/container/netcdf/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && rm -rf /container/netcdf/BUILD_DIR \
    && docker-clean

# # autotools; required to bootstrap mpich
# RUN echo "zypper install of additional WRF build dependencies" \
#     && set -x \
#     && zypper -n install \
#               man \
#               libtool automake autoconf \
#     && docker-clean

# mpich-3.4.3 and nvfortran misunderstand each other regarding real*16, avoid false positive.
# so we take the rather drastic step of modyfying configure.ac to prevent building the f08 interface,
# no matter what configure *thinks* it finds...
RUN mkdir -p /container/mpich-${MPICH_VERSION} \
    && cd /container/mpich-${MPICH_VERSION} \
    && source /container/config_env.sh \
    && curl -sSL http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar zx \
    && mv mpich-${MPICH_VERSION} BUILD_DIR && cd BUILD_DIR \
    && sed -i 's/f08_works=yes/f08_works=no/g' configure.ac \
    && ./autogen.sh \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which nvfortran) F77=$(which nvfortran) \
           CXXFLAGS="-fPIC" CFLAGS="-fPIC" FFLAGS="-fPIC" FCFLAGS="-fPIC" \
           --prefix=/container/mpich-${MPICH_VERSION}/install \
           --with-wrapper-dl-type=none \
           --with-device=ch4:ofi \
           --enable-fortran --disable-cxx

RUN cd /container/mpich-${MPICH_VERSION}/BUILD_DIR/ \
    && make -j 8 install \
    && cd /container/ && rm -rf /container/mpich-${MPICH_VERSION}/BUILD_DIR/ \
    && echo -e "\n# MPICH v${MPICH_VERSION} paths" >> config_env.sh \
    && echo "export PATH=/container/mpich-${MPICH_VERSION}/install/bin:\${PATH}" >> config_env.sh \
    && echo "export LD_LIBRARY_PATH=/container/mpich-${MPICH_VERSION}/install/lib:\${LD_LIBRARY_PATH}" >> config_env.sh \
    && rm -rf /container/mpich-${MPICH_VERSION}/BUILD_DIR/ \
    && docker-clean

# # # restore if we enable-cxx in MPICH
# # RUN whoami \
# #     && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /container/mpich-${MPICH_VERSION}/install/bin/mpicxx

RUN cd /etc/profile.d/ \
    && ln -s /container/config_env.sh ./z00-build-env.sh \
    && docker-clean

# Local Variables:
# mode: sh
# End:
