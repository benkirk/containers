FROM ubuntu:latest


########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "apt update & setup" \
    && chmod a+rx /usr/bin/docker-clean \
    && apt update \
    && adduser plainuser && mkdir /opt/local && chown plainuser: /opt/local

RUN echo "apt extras" \
    && apt-get install -y \
               build-essential gfortran automake autoconf libtool \
               less openmpi-bin openmpi-doc

RUN echo "apt VLC" \
    && apt-get install -y \
               vlc

RUN echo "apt mplayer" \
    && apt-get install -y \
               mplayer mplayer-gui

RUN mkdir -p /glade/scratch /glade/cheyenne/scratch /glade/derecho/scratch /glade/u /glade/campaign

# https://unix.stackexchange.com/questions/125546/how-to-run-vlc-player-in-root
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

#USER plainuser
#SHELL ["/bin/bash", "-lc"]

# Local Variables:
# mode: sh
# End:
