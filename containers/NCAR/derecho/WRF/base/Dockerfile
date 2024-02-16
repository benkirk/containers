#FROM benjaminkirk/ncar-derecho-site_customizations:latest
ARG ARCH=amd64
FROM --platform=linux/${ARCH} docker.io/opensuse/leap

ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "basic zypper setup" \
    && set -x \
    && zypper -n refresh \
    && zypper -n update \
    && mkdir -p /container \
    && zypper -n install \
              curl wget which \
              gcc gcc-c++ gcc-fortran gmake git \
              patch gzip unzip xz bzip2 tar perl openssl python3 ncurses-devel \
              libtool automake autoconf \
    && docker-clean

RUN  echo "zypper install of additional WRF build dependencies" \
    && zypper -n install \
              emacs-nox \
              tcsh time file hostname perl \
              flex byacc \
              zlib zlib-devel \
              jasper libjasper-devel \
              file flex \
              libtirpc-devel \
              libpng16-devel \
              rsync \
    && docker-clean

RUN mkdir -p /container && cd /container \
    && touch config_env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && docker-clean

# Modify OS to match old WRF source code expectations...
# this last one is quite silly, but works.  WRF expects a static libflex.a,
# we only have a shared, but that's entirely adequate
RUN echo "Hacking OS layout to comply with WRF/WPS expectations..." \
    && cd /usr/include/  && ln -s libpng16/*.h . \
    && cd /usr/lib64/    && ln -s libpng{16,}.so \
    && cd /usr/lib64/    && ln -s libfl.{so,a}

RUN echo "OS jasper too old for WPSV3, so..." \
    && cd /tmp && wget -q https://sourceforge.net/projects/jpeg/files/jasper/jasper-1.900.1/jasper-1.900.1.zip/download \
    && unzip download && cd jasper-1.900.1 \
    && ./configure \
           --prefix=/container/jasper/1.900.1 \
           CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) \
    && make all install \
    && docker-clean

# environment variables useful for WRF build
ENV JASPERINC /usr/include
ENV JASPERLIB /usr/lib64
ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/byacc -d"

# check out WRF/WPS versions 3 & 4
ENV WRF_VERSION 4.5.2
ENV WPS_VERSION 4.5
ENV WRF3_VERSION 3.9.1.1
ENV WPS3_VERSION 3.9.1

# clone WRF & WPS, check out desired versions
RUN echo "cloning WRF-v${WRF_VERSION} & WPS-v${WPS_VERSION}" \
    && cd /container && git clone https://github.com/wrf-model/WRF.git && cd WRF \
    && git fetch --all --tags \
    && git checkout v${WRF_VERSION} -b local/v${WRF_VERSION} \
    && cd /container && git clone https://github.com/wrf-model/WPS.git && cd WPS \
    && git fetch --all --tags \
    && git checkout v${WPS_VERSION} -b local/v${WPS_VERSION} \
    && echo && echo \
    && echo "cloning WRF3-v${WRF3_VERSION} & WPS3-v${WPS3_VERSION}" \
    && cd /container && git clone https://github.com/NCAR/WRFV3.git WRFV3 && cd WRFV3 \
    && git fetch --all --tags \
    && git checkout V${WRF3_VERSION} -b local/v${WRF3_VERSION} \
    && cd /container && git clone https://github.com/wrf-model/WPS.git WPSV3 && cd WPSV3 \
    && git fetch --all --tags \
    && git checkout v${WPS3_VERSION} -b local/v${WPS3_VERSION} \
    && docker-clean

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
