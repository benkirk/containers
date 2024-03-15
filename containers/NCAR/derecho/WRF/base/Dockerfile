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
              man \
    && docker-clean

RUN  echo "zypper install of additional WRF build dependencies" \
    && zypper -n install \
              emacs-nox vim-small \
              tcsh time file hostname perl \
              flex byacc \
              zlib zlib-devel \
              hdf5 hdf5-devel \
              file flex \
              libtirpc-devel \
              libpng16-devel \
              rsync \
    && docker-clean

# set up /container/config_env.sh - will append to later
RUN mkdir -p /container && cd /container \
    && touch config_env.sh \
    && cd /etc/profile.d/ \
    && ln -s /container/config_env.sh ./z00-build-env.sh \
    && for comp in gcc g++ gfortran; do ${comp} --version ; done \
    && docker-clean

# Modify OS to match old WRF source code expectations...
# this last one is quite silly, but works.  WRF expects a static libflex.a,
# we only have a shared, but that's entirely adequate
RUN echo "Hacking OS layout to comply with WRF/WPS expectations..." \
    && cd /usr/include/  && ln -s libpng16/*.h . \
    && cd /usr/lib64/    && ln -s libpng{16,}.so \
    && cd /usr/lib64/    && ln -s libfl.{so,a}

RUN echo "OS/zypper jasper too new for WPSV3, so..." \
    && cd /tmp && wget -q https://sourceforge.net/projects/jpeg/files/jasper/jasper-1.900.1/jasper-1.900.1.zip/download \
    && unzip download && cd jasper-1.900.1 \
    && ./configure \
           --prefix=/container/jasper/1.900.1 \
           CC=$(which gcc) CXX=$(which g++) FC=$(which gfortran) F77=$(which gfortran) \
    && make all install \
    && docker-clean

# environment variables useful for WRF build
ENV JASPERINC /container/jasper/1.900.1/include
ENV JASPERLIB /container/jasper/1.900.1/lib
ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/byacc -d"

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
