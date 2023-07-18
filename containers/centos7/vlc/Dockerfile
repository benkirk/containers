FROM centos:7

########################################
# Add docker-clean
########################################
ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "yum/dnf tweaks" \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && mkdir /opt/local \
    && yum update -y \
    && yum groupinstall -y "Development Tools" \
    && yum install -y wget which \
    && docker-clean \
    && adduser plainuser && mkdir -p /opt/local && chown plainuser: /opt/local

RUN echo "yum / VLC" \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm \
    && yum install -y vlc vlc-core \
    && docker-clean


RUN echo "yum / VLC - as root fix" \
    &&  sed -i 's/geteuid/getppid/g' /usr/bin/vlc

# Local Variables:
# mode: sh
# End:
