ARG ARCH=amd64
ARG BUILD=gcc
FROM --platform=linux/${ARCH} benjaminkirk/ncar-derecho-wrf-dbg-${BUILD}-build-environment:latest

# clone WRF & WPS, check out only desired version
ENV WRF4_VERSION 4.5.2
ENV WPS4_VERSION 4.5
RUN echo "cloning WRF-v${WRF4_VERSION} & WPS3-v${WPS4_VERSION}" \
    && cd /container && rm -rf WRF WPS \
    && cd /container && git clone --depth 1 --branch v${WRF4_VERSION} https://github.com/wrf-model/WRF.git WRF && cd WRF \
    && cd /container && git clone --depth 1 --branch v${WPS4_VERSION} https://github.com/wrf-model/WPS.git WPS && cd WPS \
    && docker-clean

ADD extras/build_wrf_dbg.sh  /container/WRF/build_wrf_dbg.sh
ADD extras/build_wrf_chem.sh /container/WRF/build_wrf_chem.sh
ADD extras/build_wps.sh      /container/WPS/build_wps.sh

RUN cd /container/WRF \
    && chmod +x build_wrf*.sh \
    && git add build_wrf*.sh \
    && cd /container/WPS \
    && chmod +x build_wps*.sh \
    && git add build_wps*.sh

RUN echo "building WRF & WPS" \
    && export WRF_VERSION=${WRF4_VERSION} \
    && export WPS_VERSION=${WPS4_VERSION} \
    && cd /container/WRF && ./build_wrf_dbg.sh \
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
