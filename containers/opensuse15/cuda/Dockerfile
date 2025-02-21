FROM docker.io/opensuse/leap

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

# Basic development environment setup
RUN echo "basic zypper" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && docker-clean

RUN echo "cuda" \
    && zypper --non-interactive addrepo https://developer.download.nvidia.com/compute/cuda/repos/sles15/x86_64/cuda-sles15.repo \
    && zypper --non-interactive --no-gpg-checks install cuda-toolkit-12-8 \
    && docker-clean

RUN echo "driver & additional deps" \
    && zypper --non-interactive --no-gpg-checks install nvidia-open libxcb-cursor0 \
    && docker-clean

SHELL ["/bin/bash", "-lc"]

RUN whoami

# Local Variables:
# mode: sh
# End:
