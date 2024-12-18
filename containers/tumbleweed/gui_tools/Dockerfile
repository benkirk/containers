FROM docker.io/opensuse/tumbleweed

ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "zypper install of additional GUI tools" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && zypper -n install \
              gimp iso-codes \
              vlc vlc-qt vlc-vdpau \
              smplayer \
              ffmpeg \
              haruna \
              gv eog evince evince-plugin-pdfdocument geeqie qpdfview \
              dia inkscape xfig \
              ImageMagick ImageMagick-extra \
    && chmod +x /usr/bin/docker-clean \
    && docker-clean

RUN echo "zypper install of additional editors" \
    && set -x \
    && zypper -n install \
              emacs emacs-x11 xemacs \
              vim gvim neovim neovim-gtk \
              nedit gedit \
    && docker-clean

RUN echo "zypper install of visual diff tools" \
    && set -x \
    && zypper -n install \
              meld \
    && docker-clean

RUN echo "zypper install of dbus-daemon" \
    && set -x \
    && zypper -n install \
              dbus-1-daemon \
    && docker-clean

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
