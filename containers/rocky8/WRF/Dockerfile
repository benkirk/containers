FROM benjaminkirk/rocky8-wrf-build-environment:latest

ENV WRF_VERSION 4.4.2
ENV WPS_VERSION 4.3.1

ENV JASPERINC /usr/include
ENV JASPERLIB /usr/lib64
ENV HDF5 /usr
ENV NETCDF /opt/local/netcdf

ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/yacc -d"
ENV LIB_LOCAL "-lnetcdf -lnetcdff -Wl,-rpath,/opt/local/netcdf/lib/"


RUN cd /opt/local \
    && git clone https://github.com/wrf-model/WRF.git \
    && cd WRF \
    && git fetch --all --tags \
    && git checkout v${WRF_VERSION} -b local/v${WRF_VERSION} \
    && cd /opt/local \
    && git clone https://github.com/wrf-model/WPS.git \
    && cd WPS \
    && git fetch --all --tags \
    && git checkout v${WPS_VERSION} -b local/v${WPS_VERSION}

ADD extras/build_wrf.sh      /opt/local/WRF/build_wrf.sh
ADD extras/build_wrf_chem.sh /opt/local/WRF/build_wrf_chem.sh
ADD extras/build_wps.sh      /opt/local/WPS/build_wps.sh

RUN cd /opt/local/WRF \
    && chmod +x build_wrf*.sh \
    && git add build_wrf*.sh \
    && cd /opt/local/WPS \
    && chmod +x build_wps*.sh \
    && git add build_wps*.sh

RUN echo "building WRF" \
    && /opt/local/WRF/build_wrf.sh \
    && cd /opt/local/WRF && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

RUN echo "building WRF-Chem & WPS" \
    && /opt/local/WRF/build_wrf_chem.sh \
    && /opt/local/WPS/build_wps.sh \
    && cd /opt/local/WRF && git clean -xdf . >/dev/null 2>&1 \
    && cd /opt/local/WPS && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

# Local Variables:
# mode: sh
# End:
