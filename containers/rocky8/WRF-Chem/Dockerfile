 FROM benjaminkirk/rocky8-wrf-build-environment:latest

ENV WRF_VERSION 4.4.2
#ENV WPS_VERSION 4.0.2
#ENV NML_VERSION 4.0.2

#ENV JASPERINC /usr/include
#ENV JASPERLIB /usr/lib64
ENV HDF5 /usr
ENV NETCDF /usr
#ENV NETCDF_classic 1

ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/yacc -d"
ENV LIB_LOCAL "-lnetcdf -lnetcdff"


RUN module list \
    && cd /opt/local \
    && git clone https://github.com/wrf-model/WRF.git \
    && cd WRF \
    && git fetch --all --tags \
    && git checkout v${WRF_VERSION} -b local/v${WRF_VERSION}

ADD extras/build_wrf_chem.sh /opt/local/WRF/build_wrf_chem.sh

RUN cd /opt/local/WRF \
    && chmod +x build_wrf_chem.sh \
    && git add build_wrf_chem.sh

# Local Variables:
# mode: sh
# End:
