ARG ARCH=amd64
FROM --platform=linux/${ARCH} benjaminkirk/ncar-derecho-wrf-intel-build-environment:latest

ADD extras/build_wrf.sh      /container/WRFV3/build_wrf.sh
ADD extras/build_wrf_chem.sh /container/WRFV3/build_wrf_chem.sh
ADD extras/build_wps.sh      /container/WPSV3/build_wps.sh

RUN cd /container/WRFV3 \
    && chmod +x build_wrf*.sh \
    && git add build_wrf*.sh \
    && cd /container/WPSV3 \
    && chmod +x build_wps*.sh \
    && git add build_wps*.sh

RUN echo "building WRFV3" \
    && export WRF_VERSION=${WRF3_VERSION} \
    && cd /container/WRFV3 && ./build_wrf.sh \
    && cd /container/WRFV3 && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

RUN echo "building WRFV3-Chem & WPSV3" \
    && export WRF_VERSION=${WRF3_VERSION} \
    && export WPS_VERSION=${WPS3_VERSION} \
    && export JASPERINC=/container/jasper/1.900.1/include \
    && export JASPERLIB=/container/jasper/1.900.1/lib \
    && cd /container/WRFV3 && ./build_wrf_chem.sh \
    && cd /container/WPSV3 && ./build_wps.sh \
    && cd /container/WRFV3 && git clean -xdf . >/dev/null 2>&1 \
    && cd /container/WPSV3 && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

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
    && export WRF_VERSION=${WRF4_VERSION} \
    && cd /container/WRF && ./build_wrf.sh \
    && cd /container/WRF && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

RUN echo "building WRF-Chem & WPS" \
    && export WRF_VERSION=${WRF4_VERSION} \
    && export WPS_VERSION=${WPS4_VERSION} \
    && cd /container/WRF && ./build_wrf_chem.sh \
    && cd /container/WPS && ./build_wps.sh \
    && cd /container/WRF && git clean -xdf . >/dev/null 2>&1 \
    && cd /container/WPS && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

# Ok, all done - let's indicate the environment
RUN sed -i 's/WRF-intel-dev/WRF-intel-env/g' /container/config_env.sh

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
