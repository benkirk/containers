FROM ubuntu:latest


ADD extras/docker-clean /usr/bin/docker-clean

RUN echo "apt update & setup" \
    && chmod a+rx /usr/bin/docker-clean \
    && apt update \
    && apt install -y \
           python3-pip curl libxml2 \
           git \
    && mkdir -p /opt/local && mkdir -p /container \
    && docker-clean

RUN cd /tmp \
    && curl -O https://developer.download.nvidia.com/compute/cuda/12.3.1/local_installers/cuda_12.3.1_545.23.08_linux.run \
    && sh ./cuda_12.3.1_545.23.08_linux.run --silent --toolkit --no-man-page --no-drm \
    && rm -rf /tmp/cuda* \
    && rm -rf \
          /usr/local/cuda-*/nsight-*/ \
          /usr/local/cuda-*/nsightee_plugins/ \
          /usr/local/cuda-*/compute-sanitizer/ \
    && echo "Done." \
    && docker-clean

#     && find /usr/local/cuda-*/ -name "*_static.a"  | xargs rm -f \

# Local Variables:
# mode: sh
# End:
