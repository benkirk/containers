FROM docker.io/almalinux:8-minimal

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf config" \
    && set -x \
    && chmod a+rx /usr/bin/docker-clean && docker-clean

# Local Variables:
# mode: sh
# End:
