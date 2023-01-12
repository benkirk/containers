FROM rockylinux:8.5

#-----------------------------------
# 1. base layer
#-----------------------------------
# Let's do all the base stuff, but with a newer version of MPICH due to odd issue with mpi.mod file in old one:
RUN yum -y update && \
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum -y install vim emacs-nox git subversion which sudo csh make m4 cmake wget file byacc curl-devel zlib-devel && \
    yum -y install perl-XML-LibXML gcc-gfortran gcc-c++ dnf-plugins-core python3 perl-core && \
    yum -y install ftp xmlstarlet diffutils  && \
    yum -y install libjpeg-devel python36-devel && \
    yum -y install git-lfs latexmk texlive-amscls texlive-anyfontsize texlive-cmap texlive-fancyhdr texlive-fncychap \
                   texlive-dvisvgm texlive-metafont texlive-ec texlive-titlesec texlive-babel-english texlive-tabulary \
                   texlive-framed texlive-wrapfig texlive-parskip texlive-upquote texlive-capt-of texlive-needspace \
                   texlive-times texlive-makeindex texlive-helvetic texlive-courier texlive-gsftopk texlive-dvips texlive-mfware texlive-dvisvgm && \
    pip3 install rst2pdf sphinx sphinxcontrib-programoutput && \
    pip3 install git+https://github.com/esmci/sphinx_rtd_theme.git@version-dropdown-with-fixes && \
    dnf --enablerepo=powertools install -y blas-devel lapack-devel && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf && \
    ldconfig && \
    yum clean all

#-----------------------------------
# 2. Install MPI (mpich)
#-----------------------------------

# Second, let's install MPI - we're doing this by hand because the default packages install into non-standard locations, and
# we want our image as simple as possible.  We're also going to use MPICH, though any of the MPICH ABI-compatible libraries
# will work.  This is for future compatibility with offloading to cloud.

# Brian: unsure if ch4:ucx and ch3 are compatible.. need to look.

RUN yum -y install numactl-devel && \
    mkdir /tmp/sources && \
    cd /tmp/sources && \
    wget -q http://www.mpich.org/static/downloads/3.4.1/mpich-3.4.1.tar.gz && \
    tar zxf mpich-3.4.1.tar.gz && \
    cd mpich-3.4.1 && \
    ./configure --prefix=/usr/local --with-device=ch4:ucx && \
    make -j 2 install && \
    rm -rf /tmp/sources && \
    yum clean all

# Local Variables:
# mode: sh
# End:
