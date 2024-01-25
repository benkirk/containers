FROM centos:7
#MAINTAINER Dave Gill <gill@ucar.edu>

# derived from https://github.com/NCAR/WRF_DOCKER

ENV WRF_VERSION 4.0.3
ENV WPS_VERSION 4.0.2
ENV NML_VERSION 4.0.2

ADD extras/docker-clean /usr/bin/docker-clean

# Set up base OS environment
RUN echo "base OS environment" \
    && yum -y update \
    && yum -y install file gcc gcc-gfortran gcc-c++ glibc.i686 libgcc.i686 libpng-devel jasper \
           jasper-devel hostname m4 make perl tar bash tcsh time wget which zlib zlib-devel \
           openssh-clients openssh-server net-tools fontconfig libgfortran libXext libXrender ImageMagick sudo epel-release \
    && yum -y install netcdf netcdf-devel netcdf-fortran netcdf-fortran-devel \
           hdf5 hdf5-devel \
           grib_api grib_api-devel \
           wgrib wgrib2 \
    && docker-clean


# Newer version of GNU compiler, required for WRF 2003 and 2008 Fortran constructs
ENV DEVTOOLSET devtoolset-8
RUN echo "Update gcc" \
    && yum -y install centos-release-scl \
    && yum -y install ${DEVTOOLSET} \
    && yum -y install ${DEVTOOLSET}-gcc ${DEVTOOLSET}-gcc-gfortran ${DEVTOOLSET}-gcc-c++ \
    && scl enable ${DEVTOOLSET} bash \
    && scl enable ${DEVTOOLSET} tcsh \
    && docker-clean

# RUN groupadd wrf -g 9999
# RUN useradd -u 9999 -g wrf -G wheel -M -d /wrf wrfuser
# RUN mkdir /wrf \
#  &&  chown -R wrfuser:wrf /wrf \
#  &&  chmod 6755 /wrf

# Build the libraries with a parallel Make
ENV J 4

# create config_env.sh stub, then add to it later
RUN mkdir -p /opt/local \
    && cd /opt/local \
    && echo "source /opt/rh/${DEVTOOLSET}/enable" > config_env.sh \
    && docker-clean

# Build MPICH-v3.x
RUN mkdir -p /opt/local \
    && cd /opt/local \
    && source /opt/local/config_env.sh \
    && wget -q http://www.mpich.org/static/downloads/3.4.3/mpich-3.4.3.tar.gz \
    && mkdir mpich-3.4.3 && cd mpich-3.4.3 && tar xf ../mpich-3.4.3.tar.gz  && rm -f ../mpich-3.4.3.tar.gz \
    && mv mpich-3.4.3 /opt/local/mpich-3.4.3/src/ && cd /opt/local/mpich-3.4.3/src/ \
    && ./configure \
           --prefix=/opt/local/mpich-3.4.3/install \
           --with-wrapper-dl-type=none \
           --with-device=ch4:ofi \
           --enable-fortran \
           CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
    && make -j 8 install && cd /opt/local/ && rm -rf /opt/local/mpich-3.4.3/src/ \
    && echo "export PATH=$PATH:/opt/local/mpich-3.4.3/install/bin" >> config_env.sh \
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/local/mpich-3.4.3/install/lib" >> config_env.sh \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN whoami && cd /opt/local \
    && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/local/mpich-3.4.3/install/bin/mpicxx

# Download NCL
ENV NCARG_ROOT /usr/local
RUN curl -SL https://www.earthsystemgrid.org/api/v1/dataset/ncl.630.1/file/ncl_ncarg-6.3.0.Linux_CentOS7.0_x86_64_nodap_gcc482.tar.gz | tar zxC ${NCARG_ROOT}


# # Build HDF5 libraries
# RUN mkdir -p /wrf/libs/hdf5/BUILD_DIR \
#     && source /opt/local/config_env.sh \
#     && cd /wrf/libs/hdf5/BUILD_DIR \
#     && git clone https://github.com/HDFGroup/hdf5.git \
#     && cd hdf5 \
#     && git checkout hdf5_1_10_11 \
#     && ./configure --enable-fortran --enable-cxx --prefix=/usr/local/ \
#         CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
#     && make install \
#     && rm -rf /wrf/libs/hdf5/BUILD_DIR \
#     && docker-clean

# ENV LD_LIBRARY_PATH /usr/local/lib

# # Build netCDF C and Fortran libraries
# RUN yum -y install libcurl-devel zlib-devel \
#     && docker-clean

# ENV NETCDF /wrf/libs/netcdf

# RUN mkdir -p ${NETCDF}/BUILD_DIR \
#     && source /opt/local/config_env.sh \
#     && cd ${NETCDF}/BUILD_DIR \
#     && curl -L -O https://github.com/Unidata/netcdf-c/archive/v4.6.2.tar.gz \
#     && curl -L -O https://github.com/Unidata/netcdf-fortran/archive/v4.4.5.tar.gz \
#     && tar -xf v4.6.2.tar.gz \
#     && cd netcdf-c-4.6.2 \
#     && ./configure \
#            --prefix="${NETCDF}" \
#            CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
#     && make install \
#     && env | sort | uniq \
#     && cd ${NETCDF}/BUILD_DIR \
#     && tar -xf v4.4.5.tar.gz \
#     && cd netcdf-fortran-4.4.5/ \
#     && export LD_LIBRARY_PATH=${NETCDF}/lib:${LD_LIBRARY_PATH} \
#     && echo "LD_LIBRARY_PATH=${NETCDF}/lib:${LD_LIBRARY_PATH}" >> /opt/local/config_env.sh \
#     && CPPFLAGS="-I${NETCDF}/include" LDFLAGS="-L${NETCDF}/lib" \
#                ./configure \
#                --prefix="${NETCDF}" \
#                CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
#     && make install \
#     && rm -rf ${NETCDF}/BUILD_DIR


# RUN mkdir -p /var/run/sshd \
#     && ssh-keygen -A \
#     && sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config \
#     && sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config \
#     && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

# RUN mkdir -p  /wrf/WPS_GEOG /wrf/wrfinput /wrf/wrfoutput \
#  &&  chown -R wrfuser:wrf /wrf /wrf/WPS_GEOG /wrf/wrfinput /wrf/wrfoutput /usr/local \
#  &&  chmod 6755 /wrf /wrf/WPS_GEOG /wrf/wrfinput /wrf/wrfoutput /usr/local


# # Set environment for interactive container shells
# RUN echo export LDFLAGS="-lm" >> /etc/bashrc \
#  && echo export NETCDF=${NETCDF} >> /etc/bashrc \
#  && echo export JASPERINC=/usr/include/jasper/ >> /etc/bashrc \
#  && echo export JASPERLIB=/usr/lib64/ >> /etc/bashrc \
#  && echo export LD_LIBRARY_PATH="/opt/rh/${DEVTOOLSET}/root/usr/lib/gcc/x86_64-redhat-linux/8:/usr/lib64/openmpi/lib:${NETCDF}/lib:${LD_LIBRARY_PATH}" >> /etc/bashrc  \
#  && echo export PATH=".:/opt/rh/${DEVTOOLSET}/root/usr/bin:/usr/lib64/openmpi/bin:${NETCDF}/bin:$PATH" >> /etc/bashrc

# RUN echo setenv LDFLAGS "-lm" >> /etc/csh.cshrc \
#  && echo setenv NETCDF "${NETCDF}" >> /etc/csh.cshrc \
#  && echo setenv JASPERINC "/usr/include/jasper/" >> /etc/csh.cshrc \
#  && echo setenv JASPERLIB "/usr/lib64/" >> /etc/csh.cshrc \
#  && echo setenv LD_LIBRARY_PATH "/opt/rh/${DEVTOOLSET}/root/usr/lib/gcc/x86_64-redhat-linux/8:/usr/lib64/openmpi/lib:${NETCDF}/lib:${LD_LIBRARY_PATH}" >> /etc/csh.cshrc \
#  && echo setenv PATH ".:/opt/rh/${DEVTOOLSET}/root/usr/bin:/usr/lib64/openmpi/bin:${NETCDF}/bin:$PATH" >> /etc/csh.cshrc

# RUN mkdir /wrf/.ssh ; echo "StrictHostKeyChecking no" > /wrf/.ssh/config
# COPY default-mca-params.conf /wrf/.openmpi/mca-params.conf
# RUN mkdir -p /wrf/.openmpi
# RUN chown -R wrfuser:wrf /wrf/

# # all root steps completed above, now below as regular userID wrfuser
# USER wrfuser
# WORKDIR /wrf

# # Download data
# ARG argname=tutorial
# RUN echo DAVE $argname
# RUN if [ "$argname" = "tutorial" ] ; then curl -SL http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz | tar -xzC /wrf/WPS_GEOG ; fi
# RUN if [ "$argname" = "tutorial" ] ; then curl -SL http://www2.mmm.ucar.edu/wrf/TUTORIAL_DATA/colorado_march16.tar.gz | tar -xzC /wrf/wrfinput ; fi
# RUN if [ "$argname" = "tutorial" ] ; then curl -SL http://www2.mmm.ucar.edu/wrf/src/namelists_v$NML_VERSION.tar.gz  | tar -xzC /wrf/wrfinput ; fi
# RUN if [ "$argname" = "tutorial" ] ; then curl -SL http://www2.mmm.ucar.edu/wrf/TUTORIAL_DATA/WRF_NCL_scripts.tar.gz | tar -xzC /wrf ; fi
# RUN if [ "$argname" = "regtest" ]  ; then curl -SL http://www2.mmm.ucar.edu/wrf/dave/DATA/Data_small/data_SMALL.tar.gz | tar -xzC /wrf ; fi
# RUN if [ "$argname" = "regtest" ]  ; then curl -SL http://www2.mmm.ucar.edu/wrf/dave/nml.tar.gz | tar -xzC /wrf ; fi
# RUN if [ "$argname" = "regtest" ]  ; then curl -SL http://www2.mmm.ucar.edu/wrf/dave/script.tar | tar -xC /wrf ; fi

# # Download wps source
# RUN if [ "$argname" = "tutorial" ] ; then git clone https://github.com/wrf-model/WPS.git WPS ; fi

# RUN echo _HERE1_
# RUN git clone https://github.com/davegill/WRF.git davegill/WRF \
#   && cd davegill/WRF \
#   && git fetch origin +refs/pull/4/merge: \
#   && git checkout -qf FETCH_HEAD \
#   && cd .. \
#   && mv WRF /wrf/WRF
# RUN echo _HERE2_

# ENV JASPERINC /usr/include/jasper
# ENV JASPERLIB /usr/lib64
# ENV NETCDF_classic 1
# ENV LD_LIBRARY_PATH /opt/rh/${DEVTOOLSET}/root/usr/lib/gcc/x86_64-redhat-linux/8:/usr/lib64/openmpi/lib:${NETCDF}/lib:${LD_LIBRARY_PATH}
# ENV PATH  .:/opt/rh/${DEVTOOLSET}/root/usr/bin:/usr/lib64/openmpi/bin:${NETCDF}/bin:$PATH

# RUN ssh-keygen -f /wrf/.ssh/id_rsa -t rsa -N '' \
#     && chmod 600 /wrf/.ssh/config \
#     && chmod 700 /wrf/.ssh \
#     && cp /wrf/.ssh/id_rsa.pub /wrf/.ssh/authorized_keys

# VOLUME /wrf
# CMD ["/bin/tcsh"]
#
