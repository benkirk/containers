FROM docker.io/rockylinux/rockylinux:8
# (deprecated): MAINTAINER Ben Kirk <benjamin.s.kirk@gmail.com>

ENV MPICH_VERSION 3.4.3


########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y install dnf-plugins-core \
    && yum config-manager --set-enabled powertools \
    && dnf -y update \
    && dnf -y install epel-release \
    && dnf -y groupinstall "Development Tools" \
    && dnf -y install \
           bzip2 autoconf automake libtool git \
           gcc gcc-c++ gcc-gfortran emacs make procps-ng \
           python3 cmake wget curl \
           openblas-devel \
           hdf5-devel \
           netcdf netcdf-devel netcdf-fortran netcdf-fortran-devel \
           byacc flex-devel jasper-devel \
    && docker-clean \
    && adduser plainuser && mkdir /opt/local && chown plainuser: /opt/local

# Build MPICH-v3.x
RUN mkdir -p /opt/local \
    && cd /opt/local \
    && wget -q http://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz \
    && mkdir mpich-${MPICH_VERSION} && cd mpich-${MPICH_VERSION} && tar xf ../mpich-${MPICH_VERSION}.tar.gz  && rm -f ../mpich-${MPICH_VERSION}.tar.gz \
    && mv mpich-${MPICH_VERSION} /opt/local/mpich-${MPICH_VERSION}/src/ && cd /opt/local/mpich-${MPICH_VERSION}/src/ \
    && ./configure \
           --prefix=/opt/local/mpich-${MPICH_VERSION}/install \
           --with-wrapper-dl-type=none \
           --with-device=ch4:ofi \
           --enable-fortran \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
    && make -j 8 install && cd /opt/local/ && rm -rf /opt/local/mpich-${MPICH_VERSION}/src/ \
    && echo "# MPICH v${MPICH_VERSION} paths" >> config_env.sh \
    && echo "export PATH=/opt/local/mpich-${MPICH_VERSION}/install/bin:${PATH}" >> config_env.sh \
    && echo "export LD_LIBRARY_PATH=/opt/local/mpich-${MPICH_VERSION}/install/lib:${LD_LIBRARY_PATH}" >> config_env.sh \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN whoami && cd /opt/local \
    && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/local/mpich-${MPICH_VERSION}/install/bin/mpicxx

# # Download NCL
# ENV NCARG_ROOT /opt/local/ncl/6.3.0
# RUN mkdir -p ${NCARG_ROOT} \
#     && curl -SL https://www.earthsystemgrid.org/api/v1/dataset/ncl.630.1/file/ncl_ncarg-6.3.0.Linux_CentOS7.0_x86_64_nodap_gcc482.tar.gz | tar zxC ${NCARG_ROOT}

# Hackery:
RUN cd /usr/lib64 && ln -s libjasper.so libjasper.a

# Local Variables:
# mode: sh
# End:
