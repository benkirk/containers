#FROM ubuntu:20.04
FROM ubuntu:precise

ADD extras/docker-clean /usr/bin/docker-clean

# https://futurestud.io/tutorials/how-to-fix-ubuntu-debian-apt-get-404-not-found-repository-errors
RUN echo "apt update & setup" \
    && chmod a+rx /usr/bin/docker-clean \
    && sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y \
               curl wget \
    && cat /etc/os-release


RUN cd /tmp \
    && apt-get install -y \
               gdebi

# https://download.sourcegear.com/DiffMerge/4.2.0/diffmerge_4.2.0.697.stable_amd64.deb
RUN cd /tmp \
    && wget https://download.sourcegear.com/DiffMerge/4.2.0/diffmerge_4.2.0.697.stable_amd64.deb \
    && gdebi --non-interactive diffmerge_4.2.0.697.stable_amd64.deb \
    && which diffmerge

# diffuse - graphical tool for merging and comparing text files
# fldiff - A graphical diff program
# meld - graphical tool to diff and merge files
# xxdiff - graphical file/directory comparison and merge tool
RUN  apt-get install -y \
     diffuse \
     fldiff \
     meld \
     xxdiff

# Local Variables:
# mode: sh
# End:
