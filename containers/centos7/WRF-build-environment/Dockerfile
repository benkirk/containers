FROM centos:7

ADD extras/docker-clean /usr/bin/docker-clean

# Set up base OS environment
RUN echo "base OS environment" \
    && yum -y update \
    && yum -y install bzip2 autoconf automake libtool git emacs gcc gcc-c++ gcc-gfortran emacs make procps-ng \
           jasper-devel hostname m4 make perl tar bash tcsh time wget which zlib-devel byacc flex-devel ncl-devel curl-devel epel-release \
    && docker-clean

# # Newer version of GNU compiler, required for WRF 2003 and 2008 Fortran constructs
# ENV DEVTOOLSET devtoolset-8
# RUN echo "Update gcc" \
#     && yum -y install centos-release-scl \
#     && yum -y install ${DEVTOOLSET} \
#     && yum -y install ${DEVTOOLSET}-gcc ${DEVTOOLSET}-gcc-gfortran ${DEVTOOLSET}-gcc-c++ \
#     && scl enable ${DEVTOOLSET} bash \
#     && scl enable ${DEVTOOLSET} tcsh \
#     && docker-clean

ENV DEVTOOLSET devtoolset-6
RUN echo "Update gcc" \
    && yum -y install centos-release-scl \
    && sed -i 's/7/7.6.1810/g; s/^#.*baseurl/baseurl/; /mirrorlist/d' /etc/yum.repos.d/CentOS-SCLo-*.repo \
    && sed -i 's/mirror.centos/vault.centos/g; s/^#.*baseurl/baseurl/; /mirrorlist/d' /etc/yum.repos.d/CentOS-SCLo-*.repo \
    && yum -y install ${DEVTOOLSET} \
    && yum -y install ${DEVTOOLSET}-gcc ${DEVTOOLSET}-gcc-gfortran ${DEVTOOLSET}-gcc-c++ \
    && scl enable ${DEVTOOLSET} bash \
    && scl enable ${DEVTOOLSET} tcsh \
    && docker-clean

RUN mkdir -p /container && cd /container && echo "source /opt/rh/${DEVTOOLSET}/enable" > config_env.sh && docker-clean

ENV MPICH_VERSION=3.4.3
ENV HDF5_VERSION=1.10.11
ENV NETCDF_C_VERSION=4.9.2
ENV NETCDF_FORTRAN_VERSION=4.6.1


RUN mkdir -p /container/hdf5/BUILD_DIR \
    && source /container/config_env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && cd /container/hdf5/BUILD_DIR \
    && curl -sSL https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${HDF5_VERSION%.*}/hdf5-${HDF5_VERSION}/src/hdf5-${HDF5_VERSION}.tar.gz | tar zx \
    && cd hdf5-${HDF5_VERSION} \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
           --prefix=/container/hdf5 \
           --enable-hl \
           --enable-cxx \
           --enable-fortran \
           --disable-parallel \
           --with-szlib=no \
    && make -j 4 && make install \
    && echo -e "\n# HDF5 libraries" >> /container/config_env.sh \
    && echo "PATH=/container/hdf5/bin:\${PATH}" >> /container/config_env.sh \
    && echo "LD_LIBRARY_PATH=/container/hdf5/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "NOT" rm -rf /container/hdf5/BUILD \
    && docker-clean

RUN mkdir -p /container/netcdf/BUILD_DIR \
    && source /container/config_env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && cd /container/netcdf/BUILD_DIR \
    && curl -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd netcdf-c-${NETCDF_C_VERSION} \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
           CPPFLAGS="-I/container/hdf5/include" LDFLAGS="-L/container/hdf5/lib -Wl,-rpath,/container/hdf5/lib" \
           --prefix=/container/netcdf \
           --disable-libxml2 \
    && make -j 4 && make install \
    && cd /container/netcdf/BUILD_DIR \
    && cd netcdf-fortran-${NETCDF_FORTRAN_VERSION}/ \
    && export LD_LIBRARY_PATH=/container/netcdf/lib:${LD_LIBRARY_PATH} \
    && ./configure \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
           CPPFLAGS="-I/container/netcdf/include -I/container/hdf5/include" LDFLAGS="-L/container/netcdf/lib -Wl,-rpath,/container/netcdf/lib -L/container/hdf5/lib -Wl,-rpath,/container/hdf5/lib" \
           --prefix=/container/netcdf \
    && make -j 4 && make install \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh && echo "PATH=/container/netcdf/bin:\${PATH}" >> /container/config_env.sh \
    && echo "LD_LIBRARY_PATH=/container/netcdf/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "NOT" rm -rf /container/netcdf/BUILD_DIR \
    && docker-clean

RUN mkdir -p /container/mpich-${MPICH_VERSION} \
    && cd /container/mpich-${MPICH_VERSION} \
    && source /container/config_env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && curl -sSL http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar zx \
    && mv mpich-${MPICH_VERSION} BUILD_DIR && cd BUILD_DIR \
    && ./configure CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
                   --prefix=/container/mpich-${MPICH_VERSION}/install \
                   --with-wrapper-dl-type=none \
                   --with-device=ch4:ofi --enable-fortran \
    && make -j 8 install \
    && cd /container/ && rm -rf /container/mpich-${MPICH_VERSION}/BUILD_DIR/ \
    && echo -e "\n# MPICH v${MPICH_VERSION} paths" >> config_env.sh \
    && echo "export PATH=/container/mpich-${MPICH_VERSION}/install/bin:\${PATH}" >> config_env.sh \
    && echo "export LD_LIBRARY_PATH=/container/mpich-${MPICH_VERSION}/install/lib:\${LD_LIBRARY_PATH}" >> config_env.sh \
    && echo "NOT" rm -rf /container/mpich-${MPICH_VERSION}/BUILD_DIR/ \
    && docker-clean

RUN whoami \
    && cd /container \
    && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /container/mpich-${MPICH_VERSION}/install/bin/mpicxx

RUN mkdir -p cd /etc/profile.d/ && ln /container/config_env.sh ./z00-build-env.sh && docker-clean
