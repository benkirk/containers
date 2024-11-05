FROM ubuntu:latest


########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "apt update & setup" \
    && chmod a+rx /usr/bin/docker-clean \
    && apt-get update -y \
    && apt-get install -y adduser \
    && adduser plainuser && mkdir /opt/local && chown plainuser: /opt/local

RUN echo "apt extras" \
    && apt-get install -y \
               build-essential gfortran automake autoconf libtool \
               less openmpi-bin openmpi-doc

USER plainuser
SHELL ["/bin/bash", "-lc"]

# Local Variables:
# mode: sh
# End:
