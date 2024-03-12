ARG ARCH=amd64
ARG BUILD=intel
FROM --platform=linux/${ARCH} benjaminkirk/ncar-derecho-wrf-${BUILD}-build-environment:latest

# clone WRF & WPS, check out only desired versions
ENV WRF3_VERSION 3.9.1.1
ENV WPS3_VERSION 3.9.1
RUN echo "cloning WRF3-v${WRF3_VERSION} & WPS3-v${WPS3_VERSION}" \
    && cd /container && rm -rf WRFV3 WPSV3 \
    && cd /container && git clone --depth 1 --branch V${WRF3_VERSION} https://github.com/NCAR/WRFV3.git    WRFV3 && cd WRFV3 \
    && cd /container && git clone --depth 1 --branch v${WPS3_VERSION} https://github.com/wrf-model/WPS.git WPSV3 && cd WPSV3 \
    && docker-clean

# clone WRF & WPS, check out only desired versions
ENV WRF4_VERSION 4.5.2
ENV WPS4_VERSION 4.5
RUN echo "cloning WRF-v${WRF4_VERSION} & WPS3-v${WPS4_VERSION}" \
    && cd /container && rm -rf WRF WPS \
    && cd /container && git clone --depth 1 --branch v${WRF4_VERSION} https://github.com/wrf-model/WRF.git WRF && cd WRF \
    && cd /container && git clone --depth 1 --branch v${WPS4_VERSION} https://github.com/wrf-model/WPS.git WPS && cd WPS \
    && docker-clean

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
RUN sed -i 's/WRF-${BUILD}-dev/WRF-${BUILD}-env/g' /container/config_env.sh \
    && find /container/w*-*/ -name "*.exe" | sort > /container/exe_list.txt \
    && cat /container/exe_list.txt \
    && echo "Total # *.exe: $(wc -l /container/exe_list.txt | awk '{print $1}')"

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
