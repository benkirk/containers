FROM centos:7

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && mkdir /opt/local \
    && yum update -y \
    && yum groupinstall -y "Development Tools" \
    && yum install -y \
           gcc gcc-c++ gcc-gfortran wget git chrpath which \
           libtool automake autoconf \
    && docker-clean \
    && adduser plainuser && mkdir -p /opt/local && chown plainuser: /opt/local


ADD extras/mpi-pi.c /opt/local/pi.c
ADD extras/hello_world_mpi.C /opt/local/hello_world_mpi.C

RUN whoami && cd /opt/local \
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
    && echo "export PATH=$PATH:/opt/local/mpich-3.4.3/install/bin" > config_env.sh \
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/local/mpich-3.4.3/install/lib" >> config_env.sh \
    && docker-clean

# Prevent mpicxx from linking -lmpicxx, which we do not need, and cannot use on our Cray-EX
RUN whoami && cd /opt/local \
    && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' /opt/local/mpich-3.4.3/install/bin/mpicxx


RUN whoami && cd /opt/local \
    && . /opt/local/config_env.sh \
    && mpicc -o pi -fPIC pi.c -lm \
    && mpiexec -n 6 ./pi \
    && mpicxx -o hello_world_mpi -fPIC hello_world_mpi.C -fopenmp \
    && ldd ./hello_world_mpi \
    && OMP_NUM_THREADS=4 mpiexec -n 6 ./hello_world_mpi  \
    && docker-clean

RUN whoami \
    && . /opt/local/config_env.sh \
    && cd /tmp && curl -SL https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.0.1.tar.gz | tar zx && cd osu-micro-benchmarks-7.0.1 \
    && ./configure --prefix=/opt/local/osu-micro-benchmarks-7.0.1 \
                   CXX=`which mpicxx` CC=`which mpicc` FC=`which mpif90` F77=`which mpif77` \
    && make -j V=0 && make install \
    && cd && rm -rf /tmp/osu-micro-benchmarks-7.0.1 \
    && cd /opt/local && mpicxx -o hello_world_mpi /opt/local/hello_world_mpi.C -fopenmp \
    && ldd hello_world_mpi \
    && cp hello_world_mpi hw && chrpath --delete hw \
    && docker-clean

RUN whoami && cd /opt/local \
    && . /opt/local/config_env.sh \
    && mpicxx -o hello_world_mpi -fPIC hello_world_mpi.C -fopenmp \
    && OMP_NUM_THREADS=4 mpiexec -n 6 ./hello_world_mpi \
    && cd /opt/local && git clone https://github.com/intel/mpi-benchmarks.git imb-2021.3 \
    && cd /opt/local/imb-2021.3 && git checkout 8ba5d968272b6e7b384f91b6597d1c4590faf3db \
    && CXX=`which mpicxx` CC=`which mpicc` make \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean \
    && make -C src_cpp -f Makefile TARGET=NBC clean\
    && make -C src_cpp -f Makefile TARGET=RMA clean \
    && make -C src_cpp -f Makefile TARGET=EXT clean \
    && make -C src_cpp -f Makefile TARGET=IO clean \
    && make -C src_cpp -f Makefile TARGET=MT clean \
    && make -C src_c/P2P -f Makefile TARGET=P2P clean \
    && make -C src_cpp -f Makefile TARGET=MPI1 clean GPU_ENABLE=1 \
    && ldd IMB-MPI1 \
    && docker-clean

CMD /opt/local/pi

# Local Variables:
# mode: sh
# End:
