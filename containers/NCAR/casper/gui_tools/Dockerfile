FROM benjaminkirk/ncar-casper-site_customizations:latest

RUN echo "zypper install of additional GUI tools" \
    && set -x \
    && zypper -n install \
              gimp \
              vlc vlc-qt vlc-vdpau \
              smplayer \
              gv eog evince geeqie \
              dia inkscape xfig \
    && docker-clean

RUN echo "zypper install of additional editors" \
    && set -x \
    && zypper -n install \
              emacs emacs-x11 xemacs \
              vim gvim neovim neovim-gtk \
    && docker-clean

# Local Variables:
# mode: sh
# End:
