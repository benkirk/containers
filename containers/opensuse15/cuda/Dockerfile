FROM docker.io/opensuse/leap:15.4
#FROM benjaminkirk/ncar-casper-gui_tools

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

# Basic development environment setup
RUN echo "basic zypper" \
    && set -x \
    && zypper --non-interactive addrepo https://developer.download.nvidia.com/compute/cuda/repos/opensuse15/x86_64/cuda-opensuse15.repo \
    && zypper --non-interactive --gpg-auto-import-keys refresh \
    && docker-clean

ARG CUDA_DRIVER_VERSION="560.35.03"
ARG CUDA_TOOLKIT_VERSION="12-8"
ARG MESA_VERSION="21.2.4"

RUN echo "zypper install of additional GUI tools / editors / CUDA" \
    && set -x \
    && zypper --non-interactive update \
    && zypper --non-interactive install \
              gimp iso-codes \
              vlc vlc-qt vlc-vdpau \
              smplayer \
              ffmpeg \
              gv eog evince evince-plugin-pdfdocument geeqie qpdfview \
              dia inkscape xfig \
              ImageMagick ImageMagick-extra \
              emacs emacs-x11 xemacs \
              vim gvim neovim \
              nedit gedit \
              meld \
              tkdiff \
              Mesa-libglapi0-${MESA_VERSION} \
              Mesa-KHR-devel-${MESA_VERSION} \
              Mesa-libGL-devel-${MESA_VERSION} \
              Mesa-gallium-${MESA_VERSION} \
              Mesa-libGL1-${MESA_VERSION} \
              Mesa-dri-${MESA_VERSION} \
              Mesa-${MESA_VERSION} \
              Mesa-libEGL1-${MESA_VERSION} \
              Mesa-demo-x \
              cuda-toolkit-${CUDA_TOOLKIT_VERSION} \
              nvidia-compute-utils-G06-${CUDA_DRIVER_VERSION} \
              nvidia-open-${CUDA_DRIVER_VERSION} \
              nvidia-container-toolkit \
    && docker-clean

RUN echo "additional deps" \
    && zypper --non-interactive install \
              libxcb-cursor0 libxkbfile1 \
              glibc-locale \
    && docker-clean

# ref: https://e4t.github.io/nvidia/cuda/drivers/'nvidia/open/driver'/2024/10/02/leap-CUDA.html
# RUN echo "cuda container toolkit" \
#     && zypper --non-interactive install \
#     && docker-clean

ENV PATH=/usr/local/cuda/bin:${PATH}

SHELL ["/bin/bash", "-lc"]

RUN whoami

# Local Variables:
# mode: sh
# End:
