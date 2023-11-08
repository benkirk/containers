FROM benjaminkirk/ncar-casper-site_customizations:latest

RUN echo "zypper install of additional GUI tools" \
    && set -x \
    && zypper -n install \
              gimp \
              vlc vlc-qt vlc-vdpau \
              smplayer \
              gv eog evince geeqie \
              dia inkscape xfig\
    && docker-clean

# Local Variables:
# mode: sh
# End:
