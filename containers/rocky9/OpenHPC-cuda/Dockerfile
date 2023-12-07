FROM benjaminkirk/rocky9-openhpc:latest

ARG COMPILER_VERSION=gnu12
ARG CUDA_VERSION=11.8

USER root

RUN echo "Cuda" \
    && curl -O https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-rhel9-11-8-local-11.8.0_520.61.05-1.x86_64.rpm \
    && rpm -i cuda-repo-rhel9-11-8-local-11.8.0_520.61.05-1.x86_64.rpm && rm -f cuda-repo-rhel9-11-8-local-11.8.0_520.61.05-1.x86_64.rpm \
    && dnf -y install cuda && rm /var/cuda-repo-*/*.rpm && dnf config-manager --disable cuda-rhel9-11-8-local \
    && docker-clean


RUN mkdir /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda
COPY extras/cuda-${CUDA_VERSION} /opt/ohpc/pub/moduledeps/${COMPILER_VERSION}/cuda/${CUDA_VERSION}

RUN mkdir -p /opt/local/miniconda3 \
    && cd /tmp && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash ./Miniconda3-latest-Linux-x86_64.sh -b -u -p /opt/local/miniconda3 \
    && docker-clean

USER plainuser

RUN module load cuda && module list \
    && source /opt/local/miniconda3/etc/profile.d/conda.sh \
    && conda config --add channels conda-forge \
    && export CONDA_OVERRIDE_CUDA=${CUDA_VERSION} \
    && conda create --yes --name myenv \
             python==3.10.* pip \
             tensorflow-gpu cuda-version=${CUDA_VERSION} cudatoolkit=${CUDA_VERSION}.* \
             numpy scipy matplotlib pandas \
             pydoe \
    && pip install jaxlib 'jax[cuda11_local]' -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    && docker-clean


# Local Variables:
# mode: sh
# End:
