FROM docker.io/opensuse/tumbleweed

ADD extras/docker-clean /usr/bin/docker-clean

# ref:
# https://en.opensuse.org/SDB:Installing_codecs_from_Packman_repositories
# https://en.opensuse.org/Additional_package_repositories#Packman
RUN echo "zypper install of additional GUI tools" \
    && set -x \
    && zypper --non-interactive ar -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman \
    && zypper --non-interactive --gpg-auto-import-keys refresh \
    && zypper --non-interactive dist-upgrade --from packman --allow-vendor-change \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && zypper -n install \
              gimp iso-codes \
              ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec vlc-codecs \
              vlc vlc-qt vlc-vdpau \
              smplayer \
              ffmpeg \
              haruna \
              gv eog evince evince-plugin-pdfdocument geeqie qpdfview \
              dia inkscape xfig \
              ImageMagick ImageMagick-extra \
    && echo "zypper install of additional editors" \
    && zypper -n install \
              emacs emacs-x11 xemacs \
              vim gvim neovim neovim-gtk \
              nedit gedit \
    && echo "zypper install of visual diff tools" \
    && zypper -n install \
              meld \
    && echo "zypper install of dbus-daemon" \
    && zypper -n install \
              dbus-1-daemon \
    && chmod +x /usr/bin/docker-clean \
    && docker-clean

# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
