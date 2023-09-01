FROM docker.io/archlinux

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

# Basic development environment setup
RUN echo "basic zypper" \
    && set -x \
    && pacman -Syu --noconfirm gtk3 \
    && pacman -Syu --noconfirm diffuse \
    && docker-clean

SHELL ["/bin/bash", "-lc"]

RUN whoami

# Local Variables:
# mode: sh
# End:
