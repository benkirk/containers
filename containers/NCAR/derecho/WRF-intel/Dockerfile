FROM benjaminkirk/ncar-derecho-wrf-intel-build-environment:latest

ENV WRF_VERSION 4.5.2
ENV WPS_VERSION 4.5

ENV JASPERINC /usr/include
ENV JASPERLIB /usr/lib64
ENV HDF5 /container/hdf5
ENV NETCDF /container/netcdf

ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/byacc -d"
ENV LIB_LOCAL "-lnetcdf -lnetcdff -Wl,-rpath,/container/netcdf/lib/ -Wl,-rpath,/container/hdf5/lib/ -Wl,-rpath,/container/intel/compiler/2022.2.1/linux/lib -Wl,rpath,/container/intel/compiler/2022.2.1/linux/lib/x64 -Wl,-rpath,/container/intel/compiler/2022.2.1/linux/compiler/lib/intel64_lin"

# Robust but hackish approach: modify OS to match source code expectations...
# this last one is quite silly, but works.  WRF-Chem expects a static libfl.a,
# we only have a shared, but that's entirely adequate
RUN echo "Hacking OS layout to comply with WRF/WPS expectations..." \
    && cd /usr/include/  && ln -s libpng16/*.h . \
    && cd /usr/lib64/    && ln -s libpng{16,}.so \
    && cd /usr/lib64/    && ln -s libfl.{so,a}

# clone WRF & WPS, check out desired versions
RUN echo "cloning WRF-v${WRF_VERSION} & WPS-v${WPS_VERSION}" \
    && cd /container && git clone https://github.com/wrf-model/WRF.git && cd WRF \
    && git fetch --all --tags \
    && git checkout v${WRF_VERSION} -b local/v${WRF_VERSION} \
    && cd /container && git clone https://github.com/wrf-model/WPS.git && cd WPS \
    && git fetch --all --tags \
    && git checkout v${WPS_VERSION} -b local/v${WPS_VERSION}

ADD extras/build_wrf.sh      /container/WRF/build_wrf.sh
ADD extras/build_wrf_chem.sh /container/WRF/build_wrf_chem.sh
ADD extras/build_wps.sh      /container/WPS/build_wps.sh

RUN cd /container/WRF \
    && chmod +x build_wrf*.sh \
    && git add build_wrf*.sh \
    && cd /container/WPS \
    && chmod +x build_wps*.sh \
    && git add build_wps*.sh

RUN echo "building WRF" \
    && /container/WRF/build_wrf.sh \
    && cd /container/WRF && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

RUN echo "building WRF-Chem & WPS" \
    && /container/WRF/build_wrf_chem.sh \
    && /container/WPS/build_wps.sh \
    && cd /container/WRF && git clean -xdf . >/dev/null 2>&1 \
    && cd /container/WPS && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
