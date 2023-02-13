FROM centos:7

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && mkdir /myapp \
    && yum update -y \
    && yum groupinstall -y "Development Tools" \
    && yum install -y gcc gcc-c++ wget \
    && docker-clean

ADD extras/mpi-pi.c /myapp/pi.c
ADD extras/hello_world_mpi.C /myapp/hello_world_mpi.C

RUN cd /myapp \
    && wget -q http://www.mpich.org/static/downloads/3.2.1/mpich-3.2.1.tar.gz \
    && mkdir mpich-3.2.1 && cd mpich-3.2.1 && tar xf ../mpich-3.2.1.tar.gz  && rm -f ../mpich-3.2.1.tar.gz \
    && mv mpich-3.2.1 /myapp/mpich-3.2.1/src/ && cd /myapp/mpich-3.2.1/src/ \
    && ./configure --prefix=/myapp/mpich-3.2.1/install --disable-wrapper-rpath \
    && make -j 8 install && cd /myapp/ && rm -rf /myapp/mpich-3.2.1/src/ \
    && echo "export PATH=$PATH:/myapp/mpich-3.2.1/install/bin" > config_env.sh \
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/myapp/mpich-3.2.1/install/lib" >> config_env.sh \
    && docker-clean

RUN cd /myapp \
    && . ./config_env.sh \
    && mpicc -o pi -fPIC pi.c -lm \
    && mpiexec -n 6 ./pi \
    && mpicxx -o hello_world_mpi -fPIC hello_world_mpi.C -fopenmp \
    && OMP_NUM_THREADS=4 mpiexec -n 6 ./hello_world_mpi  \
    && docker-clean

CMD /myapp/pi

# Local Variables:
# mode: sh
# End:
