FROM benjaminkirk/ncar-derecho-base:latest

# Additional development environment setup - required to use spack
RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive install \
              curl wget which \
              gcc gcc-c++ gcc-fortran gmake git \
              patch gzip unzip xz bzip2 tar perl openssl python3 ncurses-devel \
    && docker-clean

#  zypper --non-interactive install --recommends -t pattern devel_basis devel_C_C++ devel_tcl devel_perl devel_python3

# NCAR /glade mountpoints
RUN mkdir -p /local_scratch \
    && mkdir -p /glade/{u,work,scratch,p,campaign,collections,cheyenne/scratch,derecho/scratch} \
    && find /glade -type d

# Local Variables:
# mode: sh
# End:
