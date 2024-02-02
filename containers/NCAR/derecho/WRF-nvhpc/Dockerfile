FROM benjaminkirk/ncar-derecho-wrf-nvhpc-build-environment:latest

ENV WRF_VERSION 4.5.2
ENV WPS_VERSION 4.5

ENV JASPERINC /usr/include
ENV JASPERLIB /usr/lib64
ENV HDF5 /container/hdf5
ENV NETCDF /container/netcdf

ENV FLEX_LIB_DIR "/usr/lib64"
ENV YACC "/usr/bin/byacc -d"
ENV LIB_LOCAL "-lnetcdf -lnetcdff -Wl,-rpath,/container/netcdf/lib/ -Wl,-rpath,/container/hdf5/lib/"

# # Set up base OS environment
# RUN echo "base OS environment with additional WRF dependencies" \
#     && zypper -n install \
#            file flex \
#            libtirpc-devel \
#            libpng16-devel \
#     && docker-clean

#     && ln -s /usr/lib64/libflex.{so,a} \

# https://blog.jasonmeridth.com/posts/use-git-grep-to-replace-strings-in-files-in-your-git-repository/
RUN cd /container \
    && git clone https://github.com/wrf-model/WRF.git \
    && cd WRF \
    && git fetch --all --tags \
    && git checkout v${WRF_VERSION} -b local/v${WRF_VERSION} \
    && git grep -l 'libfl.a' | xargs sed -i 's/libfl.a/libfl.so/g' \
    && git diff \
    && cd /container \
    && git clone https://github.com/wrf-model/WPS.git \
    && cd WPS \
    && git fetch --all --tags \
    && git checkout v${WPS_VERSION} -b local/v${WPS_VERSION} \
    && git grep -l '\-lpng' | xargs sed -i 's/-lpng /-lpng16 /g' \
    && git grep -l '$(COMPRESSION_INC)' | xargs sed -i 's/$(COMPRESSION_INC)/$(COMPRESSION_INC) -I\/usr\/include\/libpng16/g' \
    && git diff

#     && find . -name Makefile | xargs sed -i 's/CFLAGS="$(CFLAGS)/CFLAGS="$(CFLAGS) $(EXTRA_WPS_CFLAGS)/g' \
#     && find . -name Makefile | xargs sed -i 's/FFLAGS="$(FFLAGS)/FFLAGS="$(FFLAGS) $(EXTRA_WPS_FFLAGS)/g' \
#     && find . -name Makefile | xargs sed -i 's/CPPFLAGS="$(CPPFLAGS)/CPPFLAGS="$(CPPFLAGS) $(EXTRA_WPS_CPPFLAGS)/g' \
#     && find . -name Makefile | xargs sed -i 's/LDFLAGS="$(LDFLAGS)/LDFLAGS="$(LDFLAGS) $(EXTRA_WPS_LDFLAGS)/g' \

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
