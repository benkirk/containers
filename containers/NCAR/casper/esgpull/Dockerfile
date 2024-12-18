FROM benjaminkirk/ncar-casper-site_customizations:latest

# reference: https://esgf.github.io/esgf-download/installation/

ARG ESGPULL_CONDA_ENV=/container/esgpull-env
ARG ESGPULL_INST_PATH=/container/esgpull-inst

# RUN echo "zypper install of additional GUI tools" \
#     && set -x \
#     && zypper -n install \
#               gimp \
#               vlc vlc-qt vlc-vdpau \
#               smplayer \
#               gv eog evince evince-plugin-pdfdocument geeqie qpdfview \
#               dia inkscape xfig \
#               ImageMagick ImageMagick-extra \
#     && docker-clean

RUN mkdir -p /container/miniconda3 \
    && cd /tmp && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash ./Miniconda3-latest-Linux-x86_64.sh -b -u -p /container/miniconda3 \
    && ln -sf /container/miniconda3/etc/profile.d/conda.sh /container/init-conda.sh \
    && docker-clean

RUN echo "zypper install of additional editors" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && zypper -n install \
              emacs-nox vim \
    && docker-clean

RUN echo "installing esgpull (1 of 2)" \
    && set -x \
    && source /container/init-conda.sh \
    && conda create \
             --yes \
             --prefix ${ESGPULL_CONDA_ENV} \
             --channel ipsl --channel conda-forge \
             "esgpull=0.7.*" \
    && conda activate ${ESGPULL_CONDA_ENV} \
    && esgpull --version \
    && ln -s ${ESGPULL_CONDA_ENV}/bin/esgpull /usr/bin/esgpull \
    && docker-clean

RUN echo "installing esgpull (2 of 2)" \
    && set -x \
    && esgpull --version \
    && esgpull self install -n default ${ESGPULL_INST_PATH} \
    && esgpull config api.index_node esgf-node.llnl.gov \
    && esgpull config api.page_limit 1000 \
    && esgpull config download.max_concurrent 12 \
    && esgpull config paths.data /glade/collections/cmpipfoo/ \
    && esgpull config paths.tmp /glade/collections/cmpipfoo/.tmp/ \
    && esgpull config api.default_options.distrib "true" \
    && esgpull config api.default_options.replica "true" \
    && echo 'y' | esgpull config --generate \
    && esgpull search project:CMIP6 variable_id:tas experiment_id:'ssp*' member_id:r1i1p1f1 frequency:mon --detail 0 \
    && esgpull config \
    && mkdir -p ${ESGPULL_INST_PATH}/etc \
    && cd ${ESGPULL_INST_PATH}

#COPY extras/esgf_credentials ${ESGPULL_INST_PATH}/etc/

ENV ESGPULL_CONDA_ENV="${ESGPULL_CONDA_ENV}"
ENV ESGPULL_INST_PATH="${ESGPULL_INST_PATH}"
ENV CONDA_INIT="/container/init-conda.sh"

COPY extras/esgpull_self_install.sh /usr/bin/esgpull_self_install.sh

# Local Variables:
# mode: sh
# End:
