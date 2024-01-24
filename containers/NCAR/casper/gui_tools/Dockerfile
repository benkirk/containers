FROM benjaminkirk/ncar-casper-site_customizations:latest

RUN echo "zypper install of additional GUI tools" \
    && set -x \
    && zypper -n install \
              gimp iso-codes \
              vlc vlc-qt vlc-vdpau \
              smplayer \
              gv eog evince evince-plugin-pdfdocument geeqie qpdfview \
              dia inkscape xfig \
              ImageMagick ImageMagick-extra \
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
              tkdiff \
    && docker-clean

# Local Variables:
# mode: sh
# End:
