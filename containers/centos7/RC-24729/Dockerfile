FROM centos:7

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && mkdir /container \
    && yum update -y \
    && yum groupinstall -y "Development Tools" \
    && yum install -y epel-release \
    && yum install -y \
           gcc gcc-c++ gcc-gfortran wget git chrpath which \
           libtool automake autoconf \
           cmake3 emacs-nox man \
           fftw{,-devel} \
           netcdf{,-devel} \
           netcdf-fortran{,-devel} \
           netcdf-cxx{,-devel} \
           hdf5{,-devel} \
           bzip2{,-libs,-devel} \
    && ln -s /usr/bin/cmake{3,} && which cmake \
    && docker-clean \
    && adduser plainuser && mkdir -p /container && chown plainuser: /container

# $ python -m http.server 8000 will start a localhost web server to make the below work...
RUN echo "installing pgi-20.4" \
    && cd /tmp \
    && curl -sSL http://host.docker.internal:8000/codes/benkirk-containers/containers/centos7/RC-24729/installers/pgi/pgi-20.4.tar.gz | tar xz \
    && cd /tmp/pgi-20.4/install_components \
    && echo && \
        PGI_SILENT=true \
        PGI_ACCEPT_EULA=accept PGI_INSTALL_DIR=/container/pgi \
        PGI_INSTALL_NVIDIA=true PGI_INSTALL_JAVA=false PGI_INSTALL_MPI=false PGI_MPI_GPU_SUPPORT=false \
        ./install \
    && cd && rm -rf /tmp/pgi* \
    && rm -rf /container/pgi/linux86-64-nollvm/ \
    && echo "PATH=/container/pgi/linux86-64/20.4/bin:\${PATH}" >> /container/config_env.sh \
    && echo "MANPATH=/container/pgi/linux86-64/20.4/man:\${PATH}" >> /container/config_env.sh \
    && echo "export LM_LICENSE_FILE=\"28518@stargate11.nwsc.ucar.edu\"" >> /container/config_env.sh \
    && mv /container/pgi/license.dat{,.old} \
    && ln -s /container/config_env.sh /etc/profile.d/container_env.sh \
    && docker-clean


RUN echo "compilation environment" \
    && echo "export CC=/container/pgi/linux86-64/20.4/bin/pgcc" >> /container/config_env.sh \
    && echo "export CXX=/container/pgi/linux86-64/20.4/bin/pgc++" >> /container/config_env.sh \
    && echo "export F77=/container/pgi/linux86-64/20.4/bin/pgfortran" >> /container/config_env.sh \
    && echo "export F90=/container/pgi/linux86-64/20.4/bin/pgf90" >> /container/config_env.sh \
    && echo "export FC=/container/pgi/linux86-64/20.4/bin/pgf90" >> /container/config_env.sh \
    && echo "export SAMURAI_ROOT=/container/samurai" >> /container/config_env.sh

ADD extras/hello_world.c /container/hello_world.c
ADD extras/hello_world.cu /container/hello_world_cuda.c

# LROSE option (1) - fully from RPMs
#  https://github.com/NCAR/lrose-core/blob/master/docs/download/download_package_and_install.redhat.md
RUN echo "lrose (rpms)" \
    && yum install -y \
           https://github.com/NCAR/lrose-core/releases/download/lrose-core-20230814/lrose-core-20230814-centos_7.x86_64.rpm \
    && echo "/usr/local/lrose/lib" > /etc/ld.so.conf.d/lrose.conf \
    && echo "export LROSE_INSTALL_DIR=/usr/local/lrose" >> /container/config_env.sh \
    && ldconfig --verbose \
    && docker-clean

# LROSE option (2): install dependencies here, then
# compile lrose later with PGI
 RUN echo "lrose (bootstrap)" \
     && cd /tmp \
     && git clone https://github.com/ncar/lrose-bootstrap.git \
     && cd lrose-bootstrap/scripts \
     && ./run_install_linux_packages \
     && cd && rm -rf /tmp/lrose-bootstrap \
     && docker-clean

# ADD extras/build_samurai.sh /container/build_samurai.sh
# RUN echo "Jians code" \
#     && source /container/config_env.sh \
#     && /container/build_samurai.sh \
#     && docker-clean

# Ok, all done - let's indicate the environment
RUN echo -e "\nPS1=\"PGI-20.4-dev> \"" >> /container/config_env.sh

# Local Variables:
# mode: sh
# End:
