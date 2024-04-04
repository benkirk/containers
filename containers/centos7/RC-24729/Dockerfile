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
    && yum install -y \
           gcc gcc-c++ gcc-gfortran wget git chrpath which \
           libtool automake autoconf \
    && docker-clean \
    && adduser plainuser && mkdir -p /container && chown plainuser: /container

RUN echo "lrose" \
    && yum install -y epel-release \
    && yum install -y \
           https://github.com/NCAR/lrose-core/releases/download/lrose-core-20230814/lrose-core-20230814-centos_7.x86_64.rpm \
           cmake3 emacs-nox \
    && echo "/usr/local/lrose/lib" > /etc/ld.so.conf.d/lrose.conf \
    && ldconfig --verbose \
    && docker-clean

ADD extras/pgi-20.4.tar.gz /tmp/pgi

RUN echo "pgi" \
     && cd /tmp/pgi/pgi-20.4/install_components \
     && PGI_SILENT=true PGI_ACCEPT_EULA=accept PGI_INSTALL_DIR=/container/pgi PGI_INSTALL_NVIDIA=true PGI_INSTALL_JAVA=true PGI_INSTALL_MPI=false PGI_MPI_GPU_SUPPORT=true ./install \
     && cd && rm -rf /tmp/pgi \
     && echo "PATH=/container/pgi/linux86-64/20.4/bin:\${PATH}" > /etc/profile.d/pgi.sh \
     && echo "LM_LICENSE_FILE=\"28518@stargate11.nwsc.ucar.edu\"" >> /etc/profile.d/pgi.sh \
     && docker-clean

ENV LM_LICENSE_FILE="28518@stargate11.nwsc.ucar.edu" \
    CC=/container/pgi/linux86-64/20.4/bin/pgcc \
    CXX=/container/pgi/linux86-64/20.4/bin/pgc++ \
    F77=/container/pgi/linux86-64/20.4/bin/pgf77 \
    F90=/container/pgi/linux86-64/20.4/bin/pgf90 \
    FC=/container/pgi/linux86-64/20.4/bin/pgf90 \
    SAMURAI_ROOT=/container/samurai

RUN echo "Jians code" \
    && git clone https://github.com/mmbell/samurai ${SAMURAI_ROOT} \
    && cd ${SAMURAI_ROOT} \
    && docker-clean

# RUN echo "lrose" \
#     && mkdir -p /tmp/lrose \
#     && git clone https://github.com/ncar/lrose-bootstrap.git /tmp/lrose/bootstrap \
#     && cd /tmp/lrose/bootstrap/scripts \
#     && ls \
#     && ./run_install_linux_packages \
#     && ./lrose_checkout_and_build_cmake.py \
#            --verbose --package samurai \
#            --prefix=/container/lrose \
#     && docker-clean

# RUN echo "lrose" \
#     && mkdir -p /tmp/lrose \
#     && git clone https://github.com/ncar/lrose-bootstrap.git /tmp/lrose/bootstrap \
#     && cd /tmp/lrose/bootstrap/scripts \
#     && ls \
#     && ./do_build_all_cmake.py \
#            --verbose \
#            --prefix /containerlrose \
#            --buildDir /tmp/lrose-build \
#            --logDir /tmp/build-logs \
#            --cmake3 \
#            --samurai \
#     && docker-clean


# ADD extras/mpi-pi.c /container/pi.c
# ADD extras/hello_world_mpi.C /container/hello_world_mpi.C
#
# RUN whoami && cd /container \
#     && wget -q http://www.mpich.org/static/downloads/3.4.3/mpich-3.4.3.tar.gz \
#     && mkdir mpich-3.4.3 && cd mpich-3.4.3 && tar xf ../mpich-3.4.3.tar.gz  && rm -f ../mpich-3.4.3.tar.gz \
#     && mv mpich-3.4.3 /container/mpich-3.4.3/src/ && cd /container/mpich-3.4.3/src/ \
#     && ./configure \
#            --prefix=/container/mpich-3.4.3/install \
#            --with-wrapper-dl-type=none \
#            --with-device=ch4:ofi \
#            --enable-fortran \
#            CXX=$(which g++) CC=$(which gcc) FC=$(which gfortran) F77=$(which gfortran) \
#     && make -j 8 install && cd /container/ && rm -rf /container/mpich-3.4.3/src/ \
#     && echo "export PATH=$PATH:/container/mpich-3.4.3/install/bin" > config_env.sh \
#     && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/container/mpich-3.4.3/install/lib" >> config_env.sh \
#     && docker-clean
#
# # Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
# RUN whoami && cd /container \
#     && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /container/mpich-3.4.3/install/bin/mpicxx
#
#
# RUN whoami && cd /container \
#     && . /container/config_env.sh \
#     && mpicc -o pi -fPIC pi.c -lm \
#     && mpiexec -n 6 ./pi \
#     && mpicxx -o hello_world_mpi -fPIC hello_world_mpi.C -fopenmp \
#     && ldd ./hello_world_mpi \
#     && OMP_NUM_THREADS=4 mpiexec -n 6 ./hello_world_mpi  \
#     && docker-clean
#
# RUN whoami \
#     && . /container/config_env.sh \
#     && cd /tmp && curl -SL https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.0.1.tar.gz | tar zx && cd osu-micro-benchmarks-7.0.1 \
#     && ./configure --prefix=/container/osu-micro-benchmarks-7.0.1 \
#                    CXX=`which mpicxx` CC=`which mpicc` FC=`which mpif90` F77=`which mpif77` \
#     && make -j V=0 && make install \
#     && cd && rm -rf /tmp/osu-micro-benchmarks-7.0.1 \
#     && cd /container && mpicxx -o hello_world_mpi /container/hello_world_mpi.C -fopenmp \
#     && ldd hello_world_mpi \
#     && cp hello_world_mpi hw && chrpath --delete hw \
#     && docker-clean
#
# RUN whoami && cd /container \
#     && . /container/config_env.sh \
#     && mpicxx -o hello_world_mpi -fPIC hello_world_mpi.C -fopenmp \
#     && OMP_NUM_THREADS=4 mpiexec -n 6 ./hello_world_mpi \
#     && cd /container && git clone https://github.com/intel/mpi-benchmarks.git imb-2021.3 \
#     && cd /container/imb-2021.3 && git checkout 8ba5d968272b6e7b384f91b6597d1c4590faf3db \
#     && CXX=`which mpicxx` CC=`which mpicc` make \
#     && make -C src_cpp -f Makefile TARGET=MPI1 clean \
#     && make -C src_cpp -f Makefile TARGET=NBC clean\
#     && make -C src_cpp -f Makefile TARGET=RMA clean \
#     && make -C src_cpp -f Makefile TARGET=EXT clean \
#     && make -C src_cpp -f Makefile TARGET=IO clean \
#     && make -C src_cpp -f Makefile TARGET=MT clean \
#     && make -C src_c/P2P -f Makefile TARGET=P2P clean \
#     && make -C src_cpp -f Makefile TARGET=MPI1 clean GPU_ENABLE=1 \
#     && ldd IMB-MPI1 \
#     && docker-clean
#
# CMD /container/pi

# Local Variables:
# mode: sh
# End:
