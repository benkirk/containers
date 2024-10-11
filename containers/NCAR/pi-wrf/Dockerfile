# Use the official Ubuntu base image
FROM ubuntu:noble

ARG DEBIAN_FRONTEND=noninteractive
ARG TZ="America/New_York"
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# Install necessary dependencies
RUN apt-get update \
    && apt-get autoclean \
    && apt-get install -y \
               build-essential wget csh m4 gfortran file make curl g++ \
               imagemagick unzip libxml2-dev libbsd-dev cmake \
               python3 python3-dev \
               libnetcdff-dev libnetcdf-dev nco netcdf-bin \
               openmpi-bin libopenmpi-dev \
    && apt-get clean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Conda
RUN mkdir -p /pi-wrf/miniconda3 \
    && miniconda_ARCH="$(uname -m)" \
    && cd /tmp && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${miniconda_ARCH}.sh \
    && bash ./Miniconda3-latest-Linux-${miniconda_ARCH}.sh -b -u -p /pi-wrf/miniconda3 \
    && ln -sf /pi-wrf/miniconda3/etc/profile.d/conda.sh /pi-wrf/init-conda.sh \
    && rm -rf /tmp/* /var/tmp/*

# Setting environment variable
ENV DIR=/pi-wrf/WRF_System/lib/LIBRARIES
ENV WRF_DIR=/pi-wrf/WRF_System/WRFV4.5
ENV WRF_SYSTEM_CONDA_ENV=/pi-wrf/WRF_System/conda-env
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

# Whole Path
ENV PATH=${DIR}/bin:${PATH}

# Setting up directories
RUN mkdir -p \
      ${WRF_SYSTEM_CONDA_ENV} \
      /pi-wrf/WRF_System/lib/LIBRARIES \
      /pi-wrf/WRF_System/lib/DATA \
      /pi-wrf/WRF_System/Plotting_Scripts \
      /pi-wrf/pi_wrf/pi_wrf \
      /pi-wrf/pi_wrf/pi_wrf/Pages \
      /pi-wrf/Output/user_saved_files

# DOWNLOADING WRF, WPS, and input data
RUN cd /pi-wrf/WRF_System/ && curl -sSL https://github.com/wrf-model/WRF/releases/download/v4.6.0/v4.6.0.tar.gz | tar xz \
    && cd /pi-wrf/WRF_System/ && curl -sSL https://github.com/wrf-model/WPS/archive/refs/tags/v4.6.0.tar.gz | tar xz && mv WPS-4.6.0 WPS \
    && cd /pi-wrf/WRF_System/lib/ && curl -sSL http://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz | tar xz && mv WPS_GEOG_LOW_RES WPS_GEOG

# CONFIGURING  AND Compile WRF
SHELL ["/bin/bash", "-c"]
RUN cd /pi-wrf/WRF_System/WRFV4.6.0/ \
    && export CC=mpicc \
    && export CXX=mpicxx \
    && export FC=mpifort \
    && export F77=mpifort \
    && env \
    && sed -i 's/gcc/mpicc/g' arch/configure.defaults \
    && sed -i 's/gfortran/mpifort/g' arch/configure.defaults \
    && ./configure_new <<< $'0\n0\n1\n0\nY\nN\nN' \
    && ./compile_new -j 8 VERBOSE=1 \
    && find $(pwd)/install -ls \
    && rm -rf ./_build/


# CONFIGURE & COMPILE WPS 4.6.0
# (WPS does not yet recogize Linux aarch64 gfortran, but the conf is the same as x86_64)
RUN cd /pi-wrf/WRF_System/WPS/ \
    && export WRF_ROOT=/pi-wrf/WRF_System/WRFV4.6.0/install \
    && export INCLUDE="/usr/include:" \
    && sed -i 's/Linux x86_64, gfortran/Linux x86_64 aarch64, gfortran/g' arch/configure.defaults \
    && ./configure_new <<< $'0\nN\nY\nY' \
    && ./compile_new -j 8 VERBOSE=1 \
    && find $(pwd)/install -ls \
    && rm -rf ./_build/

COPY <<EOF /tmp/conda-env.yaml
channels:
  - conda-forge
dependencies:
  - python =3.11
  - cartopy
  - cfgrib
  - geocat-comp
  - hdf5 =1.12
  - jupyterlab
  - matplotlib
  - mpi4py
  - openmpi =5*=external_*
  - netcdf4
  - numpy <2
  - pandas
  - pip
  - requests
  - scipy
  - xarray[viz]
EOF

#         requests jupyter ipyleaflet tzwhere hvplot ffmpeg scipy geocat-comp netCDF4 \
#         cfgrib "xarray[viz]" Pillow folium && \

RUN echo "installing ${WRF_SYSTEM_CONDA_ENV}" \
    && . /pi-wrf/init-conda.sh \
    && cat /tmp/conda-env.yaml \
    && conda env create \
             --yes \
             --prefix ${WRF_SYSTEM_CONDA_ENV} \
             --file /tmp/conda-env.yaml \
    && conda activate ${WRF_SYSTEM_CONDA_ENV} \
    && conda list \
    && which python \
    && which pip \
    && conda clean --yes --all \
    && rm -rf /tmp/* /var/tmp/*

# Set the working directory
WORKDIR /app

# Copy your local files into the containers working directory
COPY . /app

# Start an interactive shell with Python 3
CMD ["/bin/bash"]
