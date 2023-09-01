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
    && zypper --non-interactive install \
              flatpak \
    && docker-clean

RUN echo "flatpak setup" \
    && set -x \
    && flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo \
    && docker-clean

# https://flathub.org/apps/io.github.mightycreak.Diffuse
RUN echo "diffuse / flatpak installation" \
    && set -x \
    && flatpak install -y flathub io.github.mightycreak.Diffuse \
    && echo "#!/bin/bash" > /usr/bin/diffuse \
    && echo "flatpak run io.github.mightycreak.Diffuse" >> /usr/bin/diffuse \
    && chmod +x /usr/bin/diffuse \
    && docker-clean

SHELL ["/bin/bash", "-lc"]

RUN whoami

# Local Variables:
# mode: sh
# End:
