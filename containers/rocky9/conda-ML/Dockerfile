FROM docker.io/rockylinux/rockylinux:9

ARG CUDA_VERSION=11.8
ARG CONDA_ENV=my-tf-env

ENV CONDA_ENV=${CONDA_ENV}

ADD extras/docker-clean /usr/bin/docker-clean

# Basic OpenHPC development environment setup, derived from Install_guide-Rocky8-Warewulf-SLURM-2.4
RUN echo "yum/dnf config" \
    && set -x \
    && adduser plainuser \
    && chmod a+rx /usr/bin/docker-clean && docker-clean \
    && yum -y update \
    && yum -y install --allowerasing which git tar curl xz bzip2 patch \
    && docker-clean

# RUN echo "Cuda" \
#     && curl -O https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-rhel9-11-8-local-11.8.0_520.61.05-1.x86_64.rpm \
#     && rpm -i cuda-repo-rhel9-11-8-local-11.8.0_520.61.05-1.x86_64.rpm && rm -f cuda-repo-rhel9-11-8-local-11.8.0_520.61.05-1.x86_64.rpm \
#     && dnf -y install cuda && rm /var/cuda-repo-*/*.rpm && dnf config-manager --disable cuda-rhel9-11-8-local \
#     && docker-clean

RUN mkdir -p /container/miniconda3 \
    && cd /tmp && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash ./Miniconda3-latest-Linux-x86_64.sh -b -u -p /container/miniconda3 \
    && ln -sf /container/miniconda3/etc/profile.d/conda.sh /container/conda.cfg \
    && chown -R plainuser: /home/plainuser/ /container \
    && docker-clean

USER plainuser
SHELL ["/bin/bash", "-lc"]

# RUN source /container/conda.cfg \
#     && conda config --add channels conda-forge \
#     && export CONDA_OVERRIDE_CUDA=${CUDA_VERSION} \
#     && conda create --yes \
#              --prefix /container/${CONDA_ENV} \
#              python==3.10.* pip \
#              tensorflow-gpu cuda-version=${CUDA_VERSION} cudatoolkit=${CUDA_VERSION}.* \
#              numpy scipy matplotlib pandas \
#              pydoe \
#     && docker-clean
#
# RUN source /container/conda.cfg \
#     && conda activate /container/${CONDA_ENV} \
#     && pip install jaxlib 'jax[cuda11_local]' -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
#     && docker-clean

RUN source /container/conda.cfg \
    && conda config --add channels conda-forge \
    && conda create --yes \
             --prefix /container/${CONDA_ENV} \
             python==3.10.* pip \
             numpy scipy matplotlib pandas \
             pydoe \
    && docker-clean

RUN source /container/conda.cfg \
    && conda activate /container/${CONDA_ENV} \
    && pip install \
           'tensorflow[and-cuda]' \
           jaxlib 'jax[cuda12_pip]' -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
    && docker-clean

COPY test_tf+jax_install.py /container/test_tf+jax_install.py

RUN /container/${CONDA_ENV}/bin/python /container/test_tf+jax_install.py

# Local Variables:
# mode: sh
# End:
