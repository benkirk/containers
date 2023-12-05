FROM benjaminkirk/rocky8-openhpc-cuda:latest

ARG MPICH_VERSION=3.4.3

USER root

RUN echo "netcdf: serial netcdf from the base OS" \
    && yum -y install \
           netcdf-devel \
    && echo "removing unnecessary NVIDIA components to shrink container image" \
    && rm -rf /opt/local/nvidia /usr/local/cuda-11.7/targets/x86_64-linux/lib/*_static.a \
    && docker-clean

USER plainuser
RUN echo "FastEddy - source" \
    && whoami && module avail && module load mpich/${MPICH_VERSION}-ofi-cuda && module list \
    && cd /opt/local && git clone https://github.com/NCAR/FastEddy-model.git && git clone https://github.com/NCAR/FastEddy-tutorials.git \
    && cd FastEddy-model/SRC/FEMAIN \
    && sed -i 's/TEST_LIBS = -lm -lmpi -lstdc++ -lcurand/TEST_LIBS = -lm -lmpi -lstdc++ $(LIBS)/g' Makefile \
    && sed -i 's/TEST_CU_LIBS = -lm -lmpi -lcurand/TEST_LIBS = -lm -lmpi $(LIBS)/g' Makefile \
    && docker-clean

RUN echo "FastEddy - build" \
    && whoami && module avail && module load mpich/${MPICH_VERSION}-ofi-cuda && module list \
    && cd /opt/local/FastEddy-model/SRC && fe_inc= && for d in */ */*/ ; do fe_inc="-I$(pwd)/${d} ${fe_inc}" ; done \
    && cd FEMAIN && make \
                        INCLUDES="${fe_inc} -I${MPI_DIR}/include/ -I${CUDA_HOME}/targets/x86_64-linux/include/" \
                        LIBS="-L${CUDA_HOME}/targets/x86_64-linux/lib -lcurand -lcudart -lcuda -L/usr/lib64 -lnetcdf" \
    && ldd ./FastEddy \
    && docker-clean

# Local Variables:
# mode: sh
# End:
