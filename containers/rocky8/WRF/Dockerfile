FROM benjaminkirk/rocky8-wrf-build-environment:latest

ENV WRF_VERSION 4.4.2
ENV WPS_VERSION 4.3.1

ENV JASPERINC /usr/include
ENV JASPERLIB /usr/lib64
ENV HDF5 /usr
ENV NETCDF /container/netcdf

ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/yacc -d"
ENV LIB_LOCAL "-lnetcdf -lnetcdff -Wl,-rpath,/container/netcdf/lib/"


RUN cd /container \
    && git clone https://github.com/wrf-model/WRF.git \
    && cd WRF \
    && git fetch --all --tags \
    && git checkout v${WRF_VERSION} -b local/v${WRF_VERSION} \
    && cd /container \
    && git clone https://github.com/wrf-model/WPS.git \
    && cd WPS \
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

# Local Variables:
# mode: sh
# End:
