FROM benjaminkirk/ncar-derecho-wrf-intel-build-environment:latest

# set versions of embedded build, but not as environment variables
# as the resulting container could be used to support many versions
ARG WRF_VERSION=4.5.2
ARG WPS_VERSION=4.5

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
    && cd /container/WRF && ./build_wrf.sh \
    && cd /container/WRF && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

RUN echo "building WRF-Chem & WPS" \
    && cd /container/WRF && ./build_wrf_chem.sh \
    && cd /container/WPS && ./build_wps.sh \
    && cd /container/WRF && git clean -xdf . >/dev/null 2>&1 \
    && cd /container/WPS && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

#----------------------------------------
# older WRF/WPS v3 follows
ARG WRF_VERSION=3.9.1.1
ARG WPS_VERSION=3.9.1

# clone WRF & WPS, check out desired versions
RUN echo "cloning WRF3-v${WRF_VERSION} & WPS3-v${WPS_VERSION}" \
    && cd /container && git clone https://github.com/NCAR/WRFV3.git WRFv3 && cd WRFv3 \
    && git fetch --all --tags \
    && git checkout V${WRF_VERSION} -b local/v${WRF_VERSION} \
    && cd /container && git clone https://github.com/wrf-model/WPS.git WPSv3 && cd WPSv3 \
    && git fetch --all --tags \
    && git checkout v${WPS_VERSION} -b local/v${WPS_VERSION}

ADD extras/build_wrf.sh      /container/WRFv3/build_wrf.sh
ADD extras/build_wrf_chem.sh /container/WRFv3/build_wrf_chem.sh
ADD extras/build_wps.sh      /container/WPSv3/build_wps.sh

RUN cd /container/WRFv3 \
    && chmod +x build_wrf*.sh \
    && git add build_wrf*.sh \
    && cd /container/WPSv3 \
    && chmod +x build_wps*.sh \
    && git add build_wps*.sh

RUN echo "building WRFv3" \
    && cd /container/WRFv3 && ./build_wrf.sh \
    && cd /container/WRFv3 && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

RUN echo "building WRFv3-Chem & WPSv3" \
    && echo "OS jasper too old for WPSv3, so..." \
    && cd /tmp && curl -sSL https://github.com/jasper-software/jasper/archive/refs/tags/version-1.900.31.tar.gz | tar xz \
    && cd jasper-1.900.31 \
    && ./configure \
           --prefix=/container/jasper/1.900.31 \
           CC=$(which gcc) CXX=$(which gxx) \
    && make all install \
    && export JASPERINC=/container/jasper/1.900.31/include \
    && export JASPERLIB=/container/jasper/1.900.31/lib \
    && cd /container/WRFv3 && ./build_wrf_chem.sh \
    && cd /container/WPSv3 && ./build_wps.sh \
    && cd /container/WRFv3 && git clean -xdf . >/dev/null 2>&1 \
    && cd /container/WPSv3 && git clean -xdf . >/dev/null 2>&1 \
    && docker-clean

# Ok, all done - let's indicate the environment
RUN echo -e "\nPS1=\"WRF-intel-env> \"" >> /container/config_env.sh

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
