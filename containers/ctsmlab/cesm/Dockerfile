ARG DOCKERHUB_ROOT=foobar # dummy, make sure we get this from a --build-arg
FROM ${DOCKERHUB_ROOT}/ctsmlab-esmf:0.0.1

#-----------------------------------
# 6. Install CESM (manually copy CMake for this version but this should be fixed in later versions of CESM and CDEPS)
#-----------------------------------

# Second, let's install CESM - but since we're using NUOPC, and CDEPS seems to need a newer CMake, we're going to remove the
# old version then install the newer one:
COPY extras/ea002e626aee6bc6643e8ab5f998e5e4 /root/.subversion/auth/svn.ssl.server/

RUN sudo yum -y remove cmake && \
    mkdir -p /tmp/sources && \
    wget -q https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-x86_64.sh && \
    sudo sh cmake-*.sh --prefix=/usr/local --skip-license  && \
    sudo mkdir -p /opt/ncar && \
    cd /opt/ncar && \
    sudo git clone -b branch_tags/neon.n05_ctsm5.1.dev053 https://github.com/ESCOMP/CTSM.git cesm2 && \
    cd cesm2 && \
    sudo ./manage_externals/checkout_externals && \
    sudo chown -R user:escomp /opt/ncar/cesm2 # Bugfix!

# Another bugfix (should be fixed in later versions. )
COPY extras/esmApp.F90 /opt/ncar/cesm2/cime/src/drivers/nuopc/drivers/cime/esmApp.F90

#-----------------------------------
# 7. Set up all users environments
#-----------------------------------
#
# Set up the environment - create the group and user, the shell variables, the input data directory and sudo access:
RUN sudo echo 'export CESMDATAROOT=${HOME}' | sudo tee /etc/profile.d/escomp.sh && \
    sudo echo 'export CIME_MACHINE=container' | sudo tee -a /etc/profile.d/escomp.sh && \
    sudo echo 'export USER=$(whoami)' | sudo tee -a /etc/profile.d/escomp.sh && \
    sudo echo 'export PS1="[\u@cesm2.3 \W]\$ "' | sudo tee -a /etc/profile.d/escomp.sh && \
    sudo echo 'ulimit -s unlimited' | sudo tee -a /etc/profile.d/escomp.sh && \
    sudo echo 'export PATH=${PATH}:/opt/ncar/cesm2/cime/scripts' | sudo tee -a /etc/profile.d/escomp.sh && \
    sudo echo 'export PATH=${PATH}:/opt/ncar/cesm2/tools/site_and_regional/' | sudo tee -a /etc/profile.d/escomp.sh


# Add the container versions of the config_machines & config_compilers settings - later, integrate these into CIME
#COPY extras/config_compilers.xml /opt/ncar/cesm2/cime/config/cesm/machines/
#COPY extras/config_machines.xml /opt/ncar/cesm2/cime/config/cesm/machines/
#COPY extras/config_inputdata.xml /opt/ncar/cesm2/cime/config/cesm/
COPY extras/case_setup.py /opt/ncar/cesm2/cime/scripts/lib/CIME/case/case_setup.py

ENV CESMROOT=/opt/ncar/cesm2

CMD ["/bin/bash", "-l"]

# Local Variables:
# mode: sh
# End:
