ARG DOCKERHUB_ROOT=foobar # dummy, make sure we get this from a --build-arg
FROM ${DOCKERHUB_ROOT}/ctsmlab-deps:0.0.1

#-----------------------------------
# 5. Install ESMF!
#-----------------------------------

# First, let's install ESMF
ENV ESMF_SLUG="ESMF_8_2_0_beta_snapshot_15"
ENV ESMFMKFILE=/usr/local/lib/esmf.mk
RUN mkdir -p /tmp/sources && \
    cd /tmp/sources && \
    #wget -q https://github.com/esmf-org/esmf/archive/${ESMF_SLUG}.tar.gz && \
    wget -q https://github.com/esmf-org/esmf/archive/refs/tags/${ESMF_SLUG}.tar.gz && \
#https://github.com/esmf-org/esmf/archive/refs/tags/ESMF_8_2_0_beta_snapshot_15.tar.gz
    tar zxf ${ESMF_SLUG}.tar.gz && \
    cd esmf-${ESMF_SLUG} && \
    export ESMF_DIR=/tmp/sources/esmf-${ESMF_SLUG} && \
    export ESMF_COMM=mpich3 && \
    export ESMF_BOPT="g" && \
    export ESMF_NETCDF="nc-config" && \
    export ESMF_INSTALL_PREFIX=/usr/local && \
    export ESMF_INSTALL_BINDIR=${ESMF_INSTALL_PREFIX}/bin && \
    export ESMF_INSTALL_DOCDIR=${ESMF_INSTALL_PREFIX}/doc && \
    export ESMF_INSTALL_HEADERDIR=${ESMF_INSTALL_PREFIX}/include && \
    export ESMF_INSTALL_LIBDIR=${ESMF_INSTALL_PREFIX}/lib && \
    export ESMF_INSTALL_MODDIR=${ESMF_INSTALL_PREFIX}/include && \
    export ESMF_TESTEXHAUSTIVE="OFF" && \
    make info && \
    make -j $(nproc) && \
    sudo -E PATH=${PATH}:/usr/local/bin make install && \
    sudo rm -rf /tmp/sources

# Local Variables:
# mode: sh
# End:
