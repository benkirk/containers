FROM benjaminkirk/ncar-casper-base:latest

# Additional development environment setup - required to use spack
RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive install \
              patch gzip unzip xz bzip2 tar perl openssl python3 ncurses-devel \
    && docker-clean

#  zypper --non-interactive install --recommends -t pattern devel_basis devel_C_C++ devel_tcl devel_perl devel_python3

# Additional development environment setup - required to use spack
RUN echo "zypper openmpi4" \
    && set -x \
    && zypper --non-interactive install \
              openmpi4 openmpi4-devel  openmpi4-gnu-hpc-devel \
    && docker-clean

COPY extras/hello_world_mpi.C /home/plainuser/
COPY extras/bootstrap_libmesh.sh /home/plainuser/

# NCAR /glade mountpoints
RUN mkdir -p /glade/{u,work,scratch,p,collections,cheyenne/scratch,derecho/scratch} \
    && find /glade -type d

# CMD which gcc && gcc --version && ls /usr && find /usr

#
# RUN ln -s /sw/dot_spack /home/plainuser/.spack
# RUN chown -R plainuser: /home/plainuser/
# USER plainuser
# SHELL ["/bin/bash", "-lc"]
#
# RUN whoami

# Local Variables:
# mode: sh
# End:
