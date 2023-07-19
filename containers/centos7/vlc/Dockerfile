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

RUN echo "GLADE mountpoints" \
    && mkdir -p /glade/{scratch,campaign,p,collections,u,work,derecho/scratch,cheyenne/scratch} \
    && find /glade -type d | sort

RUN echo "yum - cleanups" \
    && yum groupremove -y "Development Tools" \
    && docker-clean

# Local Variables:
# mode: sh
# End:
